# Assinaturas (compra pela loja + validação no backend)

Camada de compra extraída do `refugio`, onde foi testada de ponta a ponta em produção no Android: compra,
validação no backend, restauração, renovação, cancelamento e expiração. Já faz parte do template
(`lib/services/purchase_service.dart` e `entitlement_service.dart`, registrados no `@StackedApp`), mas
**só roda se o app cobra**: nada é inicializado no startup até alguém descomentar as duas linhas do passo 3.
App gratuito simplesmente não usa.

> O `subscription_service.dart` antigo (sem backend, só `expiryTimeMillis`) foi removido: estes dois serviços o
> substituem. O backend correspondente está em `api_bootstrap` (`functions/src/modules/app-store`,
> `google-play` e `firestore/*-subscriptions.ts`).

## O que há

| Arquivo | O que faz |
|---|---|
| `lib/services/purchase_service.dart` | Fala com a loja (`in_app_purchase`): ofertas e preços, compra, restauração, `purchaseStream`. Valida no backend (`/purchases/validate`, `/purchases/restore`) e **só então** finaliza a transação (`completePurchase`). Expõe `offers`, `flow`, `lastMessage`, `storeAvailable` (`ValueNotifier`). Também tem `refresh()` (`/purchases/refresh`). |
| `lib/services/entitlement_service.dart` | Lê `entitlements/{uid}` (o backend é quem decide). Expõe `premium` e `entitlement`. Reavalia no vencimento + folga (timer), ao voltar para o app (`resumed`) e pede `refresh` ao backend uma vez por sessão quando o acesso venceu há pouco (menos de 3 dias, status ainda ativo/grace). |
| `lib/models/entitlement_model.dart` | Modelo do documento; `isPremiumAt` com `renewalSlack` de 10 minutos. |
| `lib/firestore/entitlements.dart` | `watchEntitlement` e `getOrCreateAppAccountToken` (UUID exigido pela Apple, guardado em `users/{uid}`). |
| `lib/utils/purchase_enums.dart` | `EntitlementStatus`, `PurchasePlan` (`annual`, `monthly`), `PurchaseFlowState`. |
| `lib/utils/purchase_constants.dart` | Ids dos produtos (`productAnnual`, `productMonthly`, `subscriptionProductIds`). |

Regras de negócio preservadas (não "simplifique"):

- A transação só é finalizada (`completePurchase`) **depois** que `/purchases/validate` responde OK. Se a
  chamada falhar, a loja reentrega na próxima abertura e nenhuma compra fica sem dono.
- `isPremiumAt`: status `active`/`grace` com `accessUntil + 10 min` no futuro. O acesso não cai nos segundos
  entre o vencimento e a renovação chegar do backend. `expired` e `revoked` **não têm folga**.
- Timer de reavaliação em `accessUntil + renewalSlack + 1s` (não agenda se faltar mais de 30 dias).
- Erro 403 do backend mostra a mensagem dele; qualquer outra falha mostra "Recebemos sua compra, mas não
  conseguimos confirmar agora. Ela será liberada automaticamente." (a compra segue pendente na loja).

## Contrato com o backend

Rotas autenticadas (Bearer do Firebase Auth): `POST /purchases/validate`, `POST /purchases/restore`,
`POST /purchases/refresh`. Corpo Android: `{platform: 'android', purchaseToken, productId}`; iOS:
`{platform: 'ios', signedTransaction}`. O backend grava `entitlements/{uid}` com `status`
(`none|active|grace|expired|revoked`), `accessUntil` (Timestamp), `productId`, `platform`, `autoRenew`,
`isTrial`, `trialEndsAt`. O app nunca escreve isso. Ligação compra ↔ usuário: `obfuscatedAccountId`
(SHA-256 do uid, Google) e `appAccountToken` (UUID em `users/{uid}`, Apple). Lado do servidor: `api_bootstrap` (`functions/src`, módulos de assinatura) e o `functions/` do `refugio`.

As `firestore.rules` precisam: negar escrita em `entitlements/*` ao cliente e permitir ao próprio usuário
gravar `appAccountToken` em `users/{uid}`.

## Passo a passo (app que cobra)

1. **Ids dos produtos**: em `lib/utils/purchase_constants.dart`, troque `app.anual` / `app.mensal` pelos ids
   reais (os mesmos nas duas lojas e no backend), ex.: `refugio.anual`.
2. **Backend**: ativar o módulo de assinaturas do `api_bootstrap` (ver o README dele) e publicar as regras do
   Firestore: negar escrita em `entitlements/*` ao cliente e permitir ao próprio usuário gravar
   `appAccountToken` em `users/{uid}`.
3. **Inicializar no startup** (`StartupViewModel.runStartupLogic`): descomentar as duas linhas que já estão lá,
   depois de `_authService.init()` (o login, mesmo anônimo, precisa existir):

   ```dart
   locator<EntitlementService>().init();
   unawaited(locator<PurchaseService>().init());
   ```

   O `PurchaseService.init()` consulta a loja; não bloqueie a abertura do app esperando por ele. Se o app
   tem logout que troca o escopo do locator, os dois serviços já são registrados de novo no `signOut`.
4. **Lojas**: produtos de assinatura criados no App Store Connect e no Play Console, com o mesmo id; no iOS, a
   capability In-App Purchase ligada no Xcode. Antes de testar, o contrato de Apps Pagos da Apple precisa estar
   **Ativo** (`docs/novo-app/preencher-campos/contrato-apps-pagos-apple.md`).
5. **Telas**: paywall e Ajustes seguem as regras abaixo. Roteiro de teste:
   `docs/novo-app/preencher-campos/testar-assinaturas.md`.

> Dependências (`in_app_purchase` e correlatas) já estão no `pubspec.yaml`. Em app gratuito elas entram no
> binário mas ficam sem uso; se quiser enxugar, remova os serviços de compra e as dependências.

## Regras de UI (aprendidas em produção)

Telas de assinatura (paywall, Ajustes) não fazem parte do módulo, mas todas devem seguir estas regras.

### (a) O fluxo de compra é GLOBAL

`PurchaseService.flow` é um só para o app inteiro. O paywall o dispara, e as abas em `IndexedStack`
(Ajustes) ficam vivas o tempo todo. Se Ajustes reagisse a qualquer mudança do fluxo, mostraria toast e
loading de uma compra que não é dela. Regra: o ViewModel de Ajustes **só reage se foi ele que pediu a
restauração** (`_restoreRequested`); o loading idem, e **quem mostra o loading é quem esconde**.

```dart
bool _restoreRequested = false;
bool _wasPremiumOnRestore = false;

Future<void> handleRestore() {
  _restoreRequested = true;
  _wasPremiumOnRestore = _entitlementService.premium.value;
  return _purchaseService.restore();
}

// No construtor: _purchaseService.flow.addListener(_onFlow);
// No dispose:    _purchaseService.flow.removeListener(_onFlow);
void _onFlow() {
  if (!_restoreRequested) return;
  final flow = _purchaseService.flow.value;
  if (flow == PurchaseFlowState.restoring) {
    showLoading('ajustes restaurar');
  } else {
    hideLoading('ajustes ${flow.name}');
  }
  final message = _purchaseService.lastMessage.value;
  if (flow == PurchaseFlowState.success) {
    AppToast.showToast(
        text: _wasPremiumOnRestore
            ? 'Sua assinatura já está ativa.'
            : 'Compras restauradas.',
        type: ToastType.success);
  } else if (flow == PurchaseFlowState.error && message != null) {
    AppToast.showToast(text: message);
  }
  if (flow != PurchaseFlowState.restoring &&
      flow != PurchaseFlowState.purchasing) {
    _restoreRequested = false;
  }
  notifyListeners();
}

bool get isRestoring =>
    _restoreRequested &&
    _purchaseService.flow.value == PurchaseFlowState.restoring;
```

O paywall, que é uma tela empilhada e dona do fluxo enquanto está aberta, reage a tudo: loading em
`purchasing`/`restoring`, esconde nos demais, toast em `error`, e fecha sozinho quando `premium` vira
`true`. No `init()` chame `_purchaseService.resetFlow()` e, no `dispose()`, `hideLoading(...)`.

```dart
void _onFlow() {
  final flow = _purchaseService.flow.value;
  if (flow == PurchaseFlowState.purchasing ||
      flow == PurchaseFlowState.restoring) {
    showLoading('paywall ${flow.name}');
  } else {
    hideLoading('paywall ${flow.name}');
  }
  final message = _purchaseService.lastMessage.value;
  if (flow == PurchaseFlowState.error && message != null) {
    AppToast.showToast(text: message);
  }
  notifyListeners();
}
```

### (b) Toast ao restaurar

`'Sua assinatura já está ativa.'` se a pessoa já era premium quando tocou em restaurar; senão
`'Compras restauradas.'` (ver `_wasPremiumOnRestore` acima). Sem assinatura na conta da loja, o serviço
mesmo avisa em 12s: `'Não encontramos uma assinatura nesta conta da loja.'`.

### (c) Títulos de Ajustes por status

O documento não muda sozinho quando o prazo passa, por isso o caso "prazo vencido com status ativo" existe.

```dart
bool get _isAwaitingRenewal {
  final e = _entitlementService.entitlement.value;
  return !isPremium &&
      e.accessUntil != null &&
      (e.entitlementStatus == EntitlementStatus.active ||
          e.entitlementStatus == EntitlementStatus.grace);
}

String get subscriptionTitle {
  final e = _entitlementService.entitlement.value;
  if (!isPremium) {
    if (_isAwaitingRenewal) return 'Atualizando sua assinatura…';
    return switch (e.entitlementStatus) {
      EntitlementStatus.revoked => 'Assinatura cancelada pela loja',
      EntitlementStatus.expired => 'Sua assinatura terminou',
      _ => 'Você ainda não assina',
    };
  }
  if (e.isTrial) return 'Teste grátis ativo';
  return e.isAnnual ? 'Assinatura anual ativa' : 'Assinatura mensal ativa';
}
```

| Situação | Título |
|---|---|
| `expired` | Sua assinatura terminou |
| `revoked` | Assinatura cancelada pela loja |
| `none` (nunca assinou) | Você ainda não assina |
| prazo vencido, status ainda `active`/`grace` | Atualizando sua assinatura… (detalhe: "Estamos conferindo com a loja.") |
| premium, `autoRenew == false` | detalhe: "Sem renovação: você tem acesso até {data}." |
| premium, `grace` | detalhe: "A loja não conseguiu cobrar. Você tem acesso até {data}; atualize a forma de pagamento na loja." |

### (d) Ofertas vazias no paywall

Se `offers.value` está vazio (loja indisponível, sem rede, produto não aprovado), o paywall mostra o botão
**"Tentar carregar os preços"**. Ao tocar, chama `loadOffers()`; se continuar vazio, toast neutro:
`'Os planos não estão disponíveis agora. Tente de novo em instantes.'`. Nunca mostre preço inventado.

```dart
bool get pricesMissing => _purchaseService.offers.value.isEmpty;

String get ctaLabel => pricesMissing ? 'Tentar carregar os preços' : /* 'Assinar por ...' */;

Future<void> handleSubscribe() async {
  if (pricesMissing) {
    await _purchaseService.loadOffers();
    notifyListeners();
    if (pricesMissing) {
      AppToast.showToast(
          text: 'Os planos não estão disponíveis agora. Tente de novo em instantes.');
    }
    return;
  }
  try {
    await _purchaseService.buy(selected);
  } on AppError catch (e) {
    AppToast.showToast(text: e.message);
  }
}
```

Teste grátis: só anuncie ("7 dias grátis") quando `PlanOffer.hasTrial` for `true` (o serviço já considera a
elegibilidade da conta em cada loja).

### (e) Checklist de teste manual

Android: conta de teste de licença (Play Console → Configurações → Testes de licença) com o app instalado de
uma trilha de teste; as assinaturas de teste renovam em minutos. iPhone: TestFlight com conta sandbox
(Ajustes → App Store → Conta Sandbox); a renovação sandbox é acelerada. Confira também o log do backend.

- [ ] **Comprar**: assinar o plano anual e o mensal; o paywall fecha, aparece "Assinatura ativa", `entitlements/{uid}` fica `active`.
- [ ] **Compra interrompida**: derrubar a rede/o backend entre a loja e a validação; reabrir o app e ver a compra ser reentregue e liberada (transação não finalizada).
- [ ] **Renovar**: esperar o vencimento de teste; o acesso não pisca (folga de 10 min) e a data nova aparece em Ajustes.
- [ ] **Cancelar no meio do período**: cancelar na loja; Ajustes mostra "Sem renovação: você tem acesso até {data}." e o acesso continua.
- [ ] **Expirar**: deixar passar o fim do período; título "Sua assinatura terminou" e conteúdo pago bloqueado. Reembolso/revogação: "Assinatura cancelada pela loja", sem folga.
- [ ] **Reassinar**: assinar de novo depois de expirar.
- [ ] **Restaurar**: em app reinstalado (e em aparelho novo, com uid novo), Ajustes → Restaurar: toast "Compras restauradas."; com assinatura já ativa: "Sua assinatura já está ativa."; conta sem assinatura: "Não encontramos uma assinatura nesta conta da loja." em ~12s.
- [ ] **Restaurar no paywall e em Ajustes não interferem**: comprar pelo paywall com Ajustes aberto na aba não mostra toast nem loading duplicado.
- [ ] **Teste grátis**: conta elegível vê "7 dias grátis" e, ao assinar, "Teste grátis ativo"; conta que já usou o teste não vê a oferta.
- [ ] **Sem loja/sem preços**: modo avião no paywall mostra "Tentar carregar os preços" e, com a rede de volta, carrega.
- [ ] **Cancelar a folha da loja**: fechar a folha de compra volta o paywall ao normal, sem toast de erro.

## O que o módulo NÃO traz

Paywall, Ajustes, textos de marca, regras de quando mostrar o paywall, nem o backend (`/purchases/*`,
webhooks, `entitlements`). Isso é de cada app. Testado em produção apenas no **Android**; o caminho do
iPhone (StoreKit, `appAccountToken`, elegibilidade do teste) está portado do refugio mas ainda deve passar
pelo checklist acima em TestFlight.
