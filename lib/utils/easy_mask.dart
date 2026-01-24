import 'package:easy_mask/easy_mask.dart';

final phoneMaskFormatter =
    TextInputMask(mask: ['(99) 99999-9999'], reverse: false);

final dateMaskFormatter = TextInputMask(mask: ['99/99/9999'], reverse: false);

final cpfMaskFormatter =
    TextInputMask(mask: ['999.999.999-99'], reverse: false);

final cnpjMaskFormatter =
    TextInputMask(mask: ['99.999.999/9999-99'], reverse: false);

final rgMaskFormatter = TextInputMask(mask: ['99.999.999-9'], reverse: false);

final cepMaskFormatter = TextInputMask(mask: ['99999-999'], reverse: false);
