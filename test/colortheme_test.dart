import 'package:flutter_test/flutter_test.dart';

import 'package:colortheme/colortheme.dart';
import 'package:flutter/material.dart';

void main() {
  test('test for generating colors', () {
    ColorTheme theme = ColorTheme(
      [
        Color(0xFFE8CDC7),
        Color(0xFFFBF7F1),
        Color(0xFF7A4D4A),
        Color(0xFF000000),
      ],
    );
    theme.updateCurrentColorPalette(const Color(0xFFC7DAE8));
    print(theme.currentColorPalette);
  });
}
