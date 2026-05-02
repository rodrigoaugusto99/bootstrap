# Common

Arquivos globais de UI compartilhados por todo o app.

## Arquivos

| Arquivo | Responsabilidade |
|---------|-----------------|
| `app_colors.dart` | Todas as cores do app — nunca use cores literais nas Views |
| `app_theme.dart` | Tema global do MaterialApp |
| `app_strings.dart` | Strings globais reutilizáveis |

## Fontes

Fontes são declaradas no `pubspec.yaml` com `family` e `weight`. Nunca hardcode o nome da fonte como string nas Views — use o tema ou uma constante.

```yaml
# pubspec.yaml
fonts:
  - family: Poppins
    fonts:
      - asset: assets/fonts/Poppins-Regular.ttf
        weight: 400
      - asset: assets/fonts/Poppins-Medium.ttf
        weight: 500
      - asset: assets/fonts/Poppins-Bold.ttf
        weight: 700
```
