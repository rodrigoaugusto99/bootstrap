# app/ — Arquivos do Stacked

Quase tudo aqui é gerado pelo `build_runner` a partir de `stacked.json` e das anotações do Stacked; edição
manual some na próxima geração. **Duas exceções, e as duas são obrigatórias em todo app:**

## 🔥 `app.bottomsheets.custom.dart` — escrito à mão, nunca remover

Não é gerado. Envolve cada bottom sheet numa animação própria (`Curves.easeInOutCubicEmphasized`, deslizar
+ escala), porque a do Stacked é linear e fica feia. O `main.dart` chama
`setupBottomSheetUiWithCustomAnimations()`, **nunca** o `setupBottomSheetUi()` do arquivo gerado.

O `setCustomSheetBuilders` daqui **substitui** o do gerado. Toda sheet nova no `stacked.json` precisa entrar
também no mapa deste arquivo, envolvida em `_CustomAnimatedBottomSheet`, senão ela não abre.

## 🔥 `app.logger.dart` — gerado, mas com `filter: ProductionFilter()` à mão

O `Logger` sem filtro usa o `DevelopmentFilter`, que em release **descarta tudo**: nada chega ao Cloud
Logging nem ao Crashlytics, sem erro nenhum. O gerador do Stacked não tem opção de filtro, então a linha
`filter: ProductionFilter(),` no `getLogger` é colocada à mão.

**Depois de todo `stacked generate` (ou `build_runner`), confira se ela continua lá** (`git diff lib/app/app.logger.dart`). Se
sumiu, recoloque antes de gerar build.

## Arquivos gerados

| Arquivo | O que é |
|---------|---------|
| `app.dart` | Ponto de entrada do Stacked — registra views, dialogs, bottom sheets |
| `app.locator.dart` | Locator de dependências (serviços registrados) |
| `app.router.dart` | Rotas de navegação |
| `app.dialogs.dart` | Registro de dialogs |
| `app.bottomsheets.dart` | Registro de bottom sheets (não é chamado pelo `main.dart`; ver acima) |
| `app.logger.dart` | Factory do logger (`getLogger`) — com o `ProductionFilter` à mão |

## Para registrar uma nova view, dialog ou bottom sheet

Edite `stacked.json` na raiz de `app/` e rode `stacked generate` (se ele reclamar de dependências, `dart pub global activate stacked_cli`), ou:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Bottom sheet nova: acrescente também em `app.bottomsheets.custom.dart`. Depois confira o `ProductionFilter`.
