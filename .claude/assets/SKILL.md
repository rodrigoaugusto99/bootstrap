---
name: assets
description: Use SVGs, imagens e fontes via enums tipados para referenciar assets de forma segura no projeto
---


# Assets

- SVGs: `/assets/icons` → enum em `lib/utils/svg_utils.dart` → use `SvgUtil(SvgEnum.logo)`
- Imagens: `/assets/images` → enum em `lib/utils/image_utils.dart` → use `ImageUtil(ImageEnum.background)`
- Fontes: `/assets/fonts` → configurar no `pubspec.yaml` com `family` e `weight`

→ [ex_assets.dart](references/ex_assets.dart)
