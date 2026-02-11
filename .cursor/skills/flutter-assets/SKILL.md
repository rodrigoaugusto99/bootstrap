---
name: flutter-assets
description: Manages images, SVGs, and fonts in Flutter project. Use when working with assets, images, icons, SVGs, fonts, or when the user mentions asset management, Image.asset, SvgPicture, or font configuration.
---

# Flutter Assets Management

## Localização de Assets

### Imagens e Ícones

- `/assets/icons` - arquivos SVG
- `/assets/images` - arquivos PNG/JPG

### Declaração em Utils

Assets são declarados como enums em:

- `lib/utils/svg_utils.dart`
- `lib/utils/image_utils.dart`

## Declaração de SVGs

```dart
enum SvgEnum {
  logo('logo'),
  icon('icon'),
}
```

## Declaração de Imagens

```dart
enum ImageEnum {
  logo('logo'),
  background('background'),
  photo('photo', ext: 'jpg'),
}
```

## Uso em Widgets

### SVG

```dart
SvgUtil(
  SvgEnum.logo
),
```

### Imagens PNG/JPG

```dart
ImageUtil(
  ImageEnum.background,
),
```

## Fontes

### Localização

Arquivos de fonte ficam em `/assets/fonts`:

```
- Poppins-Bold.ttf
- Poppins-Medium.ttf
- Poppins-Regular.ttf
- Sora-Bold.ttf
- Sora-Regular.ttf
```

### Configuração no pubspec.yaml

```yaml
fonts:
  - family: Poppins
    fonts:
      - asset: lib/assets/fonts/Poppins-Regular.ttf
        weight: 400
      - asset: lib/assets/fonts/Poppins-Medium.ttf
        weight: 500
      - asset: lib/assets/fonts/Poppins-Bold.ttf
        weight: 700
  - family: Sora
    fonts:
      - asset: lib/assets/fonts/Sora-Regular.ttf
        weight: 400
      - asset: lib/assets/fonts/Sora-Bold.ttf
        weight: 700
```

## Regras Importantes

- Sempre declare assets em enums
- Use `SvgUtil` e `ImageUtil` para acessar assets
- Agrupe fontes por família no `pubspec.yaml`
- Especifique o `weight` correto para cada variante de fonte
