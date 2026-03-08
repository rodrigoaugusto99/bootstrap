# Regras do Projeto

## Regras Gerais

- faça o nome de funções e classes em ingles
- sempre atualize a tela chamando notifyListeners().
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
