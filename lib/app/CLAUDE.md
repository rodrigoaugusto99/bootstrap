# app/ — Arquivos Gerados pelo Stacked

**Nunca edite manualmente nenhum arquivo neste diretório.**

Todos os arquivos são gerados pelo `build_runner` com base em `stacked.json` e nas anotações do Stacked. Qualquer edição manual será sobrescrita na próxima geração.

## Arquivos gerados

| Arquivo | O que é |
|---------|---------|
| `app.dart` | Ponto de entrada do Stacked — registra views, dialogs, bottom sheets |
| `app.locator.dart` | Locator de dependências (serviços registrados) |
| `app.router.dart` | Rotas de navegação |
| `app.dialogs.dart` | Registro de dialogs |
| `app.bottomsheets.dart` | Registro de bottom sheets |
| `app.bottomsheets.custom.dart` | Customização de bottom sheets |
| `app.logger.dart` | Factory do logger (`getLogger`) |

## Para registrar uma nova view, dialog ou bottom sheet

Edite `stacked.json` na raiz de `app/` e rode:

```bash
dart run build_runner build --delete-conflicting-outputs
```
