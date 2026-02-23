import 'package:flutter_test/flutter_test.dart';
import 'package:bootstrap/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TryStaggeredAnimationViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
