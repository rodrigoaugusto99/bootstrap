// ── lib/utils/svg_utils.dart ──────────────────────────────────────────────────
enum SvgEnum {
  logo('logo'),
  icon('icon');

  const SvgEnum(this.name);
  final String name;
}

// Uso:
SvgUtil(SvgEnum.logo)


// ── lib/utils/image_utils.dart ────────────────────────────────────────────────
enum ImageEnum {
  logo('logo'),
  background('background'),
  photo('photo', ext: 'jpg');

  const ImageEnum(this.name, {this.ext = 'png'});
  final String name;
  final String ext;
}

// Uso:
ImageUtil(ImageEnum.background)


// ── pubspec.yaml — Fontes ─────────────────────────────────────────────────────
//
// fonts:
//   - family: Poppins
//     fonts:
//       - asset: assets/fonts/Poppins-Regular.ttf
//         weight: 400
//       - asset: assets/fonts/Poppins-Medium.ttf
//         weight: 500
//       - asset: assets/fonts/Poppins-Bold.ttf
//         weight: 700
