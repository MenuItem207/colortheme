import 'package:flutter/material.dart';
import 'package:colortheme/src/color_palette_utility.dart';

extension StringParsing on Color {
  /// converts a [Color] to a hex
  String parseHex() {
    return value.toRadixString(16).substring(2);
  }
}

extension ColorParsing on String {
  /// converts a [String] to a [Color]
  Color parseColor() {
    return Color(int.parse('0XFF$this'));
  }
}

class ColorTheme {
  ColorTheme(
    this.baseColorPalette, {
    this.baseColorIndex = 0,
  });

  /// the index of the base color
  final int baseColorIndex;

  /// the original color palette where index 0 is the base color and _baseColorPalette.length >= 2
  final List<Color> baseColorPalette;

  /// the current active color palette where index 0 is the base color and currentColorPalette.length >= 2
  late List<Color> currentColorPalette = baseColorPalette;

  /// updates the colors in [currentColorPalette] based on the existing [baseColorPalette] and the [newBaseColor]
  void updateCurrentColorPalette(Color newBaseColor) {
    List<String> originalColorPalette = [];
    for (Color color in baseColorPalette) {
      originalColorPalette.add(color.parseHex());
    }

    List<String> colorPalette = ColorPaletteUtility.generateColorPalette(
      newBaseColor.parseHex(),
      originalColorPalette,
      baseColourIndex: baseColorIndex,
    );

    for (int i = 0; i < colorPalette.length; i++) {
      currentColorPalette[i] = colorPalette[i].parseColor();
    }
  }
}
