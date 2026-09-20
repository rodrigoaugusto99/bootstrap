# assets/icon

Coloque aqui a arte do icone antes de rodar `dart run flutter_launcher_icons`.

| Arquivo | O que e | Requisitos |
|---|---|---|
| `icon.png` | O icone do app | **1024x1024**, quadrado, **sem canal alfa** (`RGB`, nunca `RGBA`), sem cantos arredondados desenhados |
| `icon_foreground.png` | Camada de frente do icone adaptativo do Android | 1024x1024 com **transparencia**, a logo ocupando ~66% do centro (o resto e zona de corte) |

A cor de fundo do icone adaptativo e o `adaptive_icon_background` no `pubspec.yaml` —
troque pela cor da marca do app.

Depois de trocar a arte:

```bash
dart run flutter_launcher_icons
```

> Se nao houver `icon_foreground.png`, remova as duas linhas `adaptive_icon_*` do
> `pubspec.yaml`, senao o comando falha.
