# Bootstrap

Template Flutter com Stacked + Firebase. Base para novos projetos.

## Stack

- Flutter stable (FVM)
- Stacked `^3.4.0` + `stacked_services`
- Firebase: Auth, Firestore, Storage, Messaging
- Dio para HTTP

## Comandos

```bash
# Rodar o app
flutter run

# Gerar código (após criar/alterar views, dialogs, bottom sheets, locator)
dart run build_runner build --delete-conflicting-outputs
```

> Os arquivos gerados ficam em `lib/app/` — nunca edite manualmente.

## Estrutura

```
lib/
├── app/                        ← gerado, nunca mexa
├── exceptions/app_error.dart   ← AppError
├── firestore/                  ← user, notification, subscription, app
├── models/                     ← UserModel, AddressModel, NotificationModel, SubscriptionModel
├── schemas/                    ← AuthenticateAnonymousSchema, CodeSentSchema, LoginViewSchema,
│                                  UserRegistrationSchema, VerifyCodeSchema,
│                                  GetCoordinatesFromAddressResponse
├── services/                   ← ver lista abaixo
├── utils/                      ← ver lista abaixo
├── ui/
│   ├── common/                 ← app_colors, app_theme, app_strings
│   ├── components/             ← AppButton, CustomAppBar, CustomTextFormField, Loading,
│   │                              PinCodeField, CustomCheckBox, CustomRadioBall,
│   │                              CustomBottomNavigationBar
│   ├── dialogs/info_alert/
│   ├── bottom_sheets/notice/
│   └── views/
│       ├── startup/            ← splash + redirecionamento
│       ├── on_boarding/
│       ├── login/
│       ├── register/
│       ├── complex_register/   ← multi-step com pages/
│       └── home/
├── firebase_options.dart
└── main.dart
```

## Services

| Service | Responsabilidade |
|---------|-----------------|
| `UserService` | Usuário logado (instância + ValueNotifier) |
| `AuthService` | Firebase Auth: email, Google, Apple, anônimo |
| `AppService` | Estado global do app |
| `NotificationService` | FCM + notificações locais |
| `LocationService` | Geolocator + geocoding |
| `ApiService` | HTTP via Dio |
| `SubscriptionService` | Controle de assinaturas |
| `AlarmService` | Alarmes locais |
| `AnalyticsService` | Analytics |
| `ConectivityService` | Monitoramento de rede |

## Utils relevantes

| Arquivo | O que faz |
|---------|-----------|
| `validators.dart` | Validadores estáticos para `TextFormField` |
| `formatters.dart` | Formatação de datas, moeda, telefone, máscaras de input |
| `helpers.dart` | `decContainer`, `styledText`, `heightSeparator`, `widthSeparator`, layout responsivo |
| `shared_preferences.dart` | Wrapper de SharedPreferences (use enums para keys) |
| `constants.dart` | URLs da API, URLs das stores, mensagens de erro globais, flag `DEVELOPMENT` |
| `enums.dart` | Enums globais |
| `svg_util.dart` | Widget `SvgUtil` |
| `image_util.dart` | Widget `ImageUtil` |
| `app_cached_network_image.dart` | Widget de imagem remota com skeleton e fallback de erro |
| `url_launcher.dart` | `openUrl`, `openUrlWithFallback` — abre URLs e e-mails |
| `utils.dart` | `sendWppMessage`, `removeSpecialCaracteres`, `unfocus`, `gerarCpfValido` |
| `app_updater.dart` | Verificação de versão mínima e redirecionamento para a store |
| `custom_transition.dart` | `transitionAnimation()` — animação de slide para navegação |
| `get_context.dart` | `getContext()` — acessa o `BuildContext` fora da árvore de widgets |
| `redirect_user.dart` | Lógica de redirecionamento pós-login |
| `loading.dart` | Controle do overlay de loading |
| `toast.dart` | Toasts |
| `popup.dart` | Popups |
| `firebase_storage.dart` | Wrapper Firebase Storage |
| `image_picker.dart` | Wrapper image_picker |
| `GCPLogger.dart` | `LogOutput` que envia logs para o Google Cloud Logging |
| `logarte.dart` | `LogarteService` — painel de logs em tela + interceptor Dio (apenas dev) |

## Assets

- `assets/images/` — imagens (declaradas em `pubspec.yaml`)
- `assets/icons/` — SVGs (se houver)
- `assets/fonts/` — fontes (configurar em `pubspec.yaml` se necessário)

# Regras do Projeto

## Regras Gerais

- faça o nome de funções e classes em ingles
- Não atualize a tela usando rebuildUi sempre use notifyListeners().
- Nunca mexa nos arquivos dentro de `lib/app/`.
- Não faça comentários no código.
- Não crie arquivos `.svg`. Os arquivos de imagem sempre estarão criados antes.
- Nunca use `print()`. Use o logger. → [ex_logger.dart](examples/ex_logger.dart)
- Nunca faça lógica dentro da View. Sempre faça na ViewModel. → [ex_view_viewmodel.dart](examples/ex_view_viewmodel.dart)

---

## Arquitetura de Diretórios

```
lib/app/              ← gerado, nunca mexa
lib/assets/           ← imagens, ícones, fontes, animações
lib/firestore/        ← apenas comunicação com o Firestore
lib/models/           ← entidades de domínio persistidas
lib/schemas/          ← DTOs (request/response, parâmetros agrupados)
lib/services/         ← sempre singletons
lib/utils/            ← wrappers de pacotes externos
lib/ui/dialogs/       ← dialogs
lib/ui/bottom_sheets/ ← bottom sheets
lib/ui/common/        ← app_colors.dart, app_theme.dart, ui_helpers.dart
lib/ui/components/    ← componentes usados em vários lugares
```

> Componentes usados só em uma tela ficam na mesma pasta da view.

---

## Fluxo de Dados

```
Firestore → Service → ViewModel → View
```

Nunca pule camadas.

### Firestore (`lib/firestore/`)

Só faz queries, try/catches e conversão `Map → Model`. Sem lógica de negócio, sem `BuildContext`, sem acesso a ViewModels ou ValueNotifiers. → [ex_firestore.dart](examples/ex_firestore.dart)

### Services (`lib/services/`)

- São singletons.
- Usam `ValueNotifier` para o modelo do usuário com `addListener`.
- Chamam funções do `firestore/` para leituras e escritas.
- Lançam `AppError` em erros. → [ex_service.dart](examples/ex_service.dart)

### ViewModels

- caso precise rodar uma lógica no inicio, faça o método init() e chame dentro do construtor.
- caso uma função na viewmodel é chamada diretamente pela view, então essa deverá começar com "handle", por exemplo, "handleLogin"
- Chamam os Services e capturam `AppError` para mostrar snackbar/toast.
- Nunca acessam Firestore diretamente.
- Nunca chama uma função diretamente de /lib/firestore. Ao inves disso, chama uma função no service com parametros "comuns" que chama essa função do firestore. → [ex_service.dart](examples/ex_service.dart)

### `lib/ui/common`

- `app_colors.dart` — todas as cores do app.
- `app_theme.dart` — tema global.
- `ui_helpers.dart` — `heightSeparator`, `widthSeparator`, `decContainer`, estilos de texto.

---

## Skills — Leitura Obrigatória

OBRIGATÓRIO: antes de gerar qualquer código, identifique qual contexto se aplica abaixo e use a ferramenta Read para ler APENAS o(s) SKILL.md correspondente(s). Nunca gere código sem ter lido o arquivo primeiro.

| Contexto | Arquivo a ler |
|----------|--------------|
| Criar ou editar ViewModel | [.claude/viewmodel/SKILL.md](.claude/viewmodel/SKILL.md) |
| Criar ou editar View | [.claude/view/SKILL.md](.claude/view/SKILL.md) |
| Criar ou editar Model | [.claude/models/SKILL.md](.claude/models/SKILL.md) |
| Criar ou editar Schema/DTO | [.claude/schemas/SKILL.md](.claude/schemas/SKILL.md) |
| Criar ou editar Dialog ou Bottom Sheet | [.claude/dialogs_and_bottomsheets/SKILL.md](.claude/dialogs_and_bottomsheets/SKILL.md) |
| Criar ou editar Form | [.claude/forms/SKILL.md](.claude/forms/SKILL.md) |
| Navegação entre telas | [.claude/navigation/SKILL.md](.claude/navigation/SKILL.md) |
| Usar Assets (imagens, SVGs) | [.claude/assets/SKILL.md](.claude/assets/SKILL.md) |
| Usar SharedPreferences | [.claude/shared_preferences/SKILL.md](.claude/shared_preferences/SKILL.md) |
| Toggle, seleção de opções | [.claude/toggle_and_selection/SKILL.md](.claude/toggle_and_selection/SKILL.md) |
| Callbacks entre componentes | [.claude/callbacks/SKILL.md](.claude/callbacks/SKILL.md) |
| Criar ou editar View ou Componente de View | [.claude/view/SKILL.md](.claude/view/SKILL.md) |

