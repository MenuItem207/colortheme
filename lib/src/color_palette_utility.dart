import 'dart:math' as math;

/// utility related to generating palettes of color
class ColorPaletteUtility {
  /// uses the relationships derived from [originalColorPalette] where the first hex value is the chosen base color, must be a list of more than 1 hex values
  /// and generates a new palette using a given base color, [newPaletteBaseColor]
  static List<String> generateColorPalette(
    String newPaletteBaseColor,
    List<String> originalColorPalette, {
    int baseColourIndex = 0,
  }) {
    assert(originalColorPalette.length > 1);
    String originalBaseColor = originalColorPalette[baseColourIndex];
    List<List<double>?> relationships = [];
    for (int i = 0; i < originalColorPalette.length; i++) {
      if (i != baseColourIndex) {
        relationships.add(
          hsvRelationship(originalBaseColor, originalColorPalette[i]),
        );
      } else {
        relationships.add(null);
      }
    }

    List<String> newPalette = [];
    for (List<double>? relationship in relationships) {
      if (relationship == null) {
        newPalette.add(newPaletteBaseColor);
      } else {
        newPalette.add(generateDerivedColor(newPaletteBaseColor, relationship));
      }
    }

    return newPalette;
  }

  /// generates a hsv relationship between 2 colors
  static List<double> hsvRelationship(String baseColor, String derivedColor) {
    // Convert the hexadecimal colors to RGB values
    List<int> baseRgb = [
      int.parse(baseColor.substring(0, 2), radix: 16),
      int.parse(baseColor.substring(2, 4), radix: 16),
      int.parse(baseColor.substring(4, 6), radix: 16)
    ];
    List<int> derivedRgb = [
      int.parse(derivedColor.substring(0, 2), radix: 16),
      int.parse(derivedColor.substring(2, 4), radix: 16),
      int.parse(derivedColor.substring(4, 6), radix: 16)
    ];

    // Convert the RGB values to HSV values
    List<double> baseHsv = _rgbToHsv(baseRgb[0], baseRgb[1], baseRgb[2]);
    List<double> derivedHsv =
        _rgbToHsv(derivedRgb[0], derivedRgb[1], derivedRgb[2]);

    // Calculate the difference between the base and derived HSV values
    double hDiff = derivedHsv[0] - baseHsv[0];
    double sDiff = derivedHsv[1] - baseHsv[1];
    double vDiff = derivedHsv[2] - baseHsv[2];

    // Return the HSV differences as a list
    return [hDiff, sDiff, vDiff];
  }

  /// generates a hex value given a base color and the hsv relationship
  static String generateDerivedColor(String baseColor, List<double> hsvDiff) {
    // Convert the base color to RGB values
    List<int> baseRgb = [
      int.parse(baseColor.substring(0, 2), radix: 16),
      int.parse(baseColor.substring(2, 4), radix: 16),
      int.parse(baseColor.substring(4, 6), radix: 16)
    ];

    // Convert the base RGB values to HSV values
    List<double> baseHsv = _rgbToHsv(baseRgb[0], baseRgb[1], baseRgb[2]);

    // Add the differences to the base HSV values
    List<double> derivedHsv = [
      baseHsv[0] + hsvDiff[0],
      baseHsv[1] + hsvDiff[1],
      baseHsv[2] + hsvDiff[2]
    ];

    // Convert the derived HSV values to RGB values
    List<int> derivedRgb =
        _hsvToRgb(derivedHsv[0], derivedHsv[1], derivedHsv[2]);

    // Convert the derived RGB values to integers and format them as hexadecimal values
    String derivedColor =
        derivedRgb.map((i) => i.toRadixString(16).padLeft(2, '0')).join();

    return derivedColor;
  }

  static List<double> _rgbToHsv(int r, int g, int b) {
    double rd = r / 255;
    double gd = g / 255;
    double bd = b / 255;
    double max = math.max(rd, math.max(gd, bd));
    double min = math.min(rd, math.min(gd, bd));
    double h = 0, s, v = max;

    double d = max - min;
    s = max == 0 ? 0 : d / max;

    if (max == min) {
      h = 0;
    } else {
      if (max == rd) {
        h = (gd - bd) / d + (gd < bd ? 6 : 0);
      } else if (max == gd) {
        h = (bd - rd) / d + 2;
      } else if (max == bd) {
        h = (rd - gd) / d + 4;
      }
    }

    h /= 6;

    return [h, s, v];
  }

  static List<int> _hsvToRgb(double h, double s, double v) {
    int r = 0, g = 0, b = 0;

    int i = (h * 6).floor();
    double f = h * 6 - i;
    double p = v * (1 - s);
    double q = v * (1 - f * s);
    double t = v * (1 - (1 - f) * s);

    switch (i % 6) {
      case 0:
        r = (v * 255).round();
        g = (t * 255).round();
        b = (p * 255).round();
        break;
      case 1:
        r = (q * 255).round();
        g = (v * 255).round();
        b = (p * 255).round();
        break;
      case 2:
        r = (p * 255).round();
        g = (v * 255).round();
        b = (t * 255).round();
        break;
      case 3:
        r = (p * 255).round();
        g = (q * 255).round();
        b = (v * 255).round();
        break;
      case 4:
        r = (t * 255).round();
        g = (p * 255).round();
        b = (v * 255).round();
        break;
      case 5:
        r = (v * 255).round();
        g = (p * 255).round();
        b = (q * 255).round();
        break;
    }

    return [r, g, b];
  }
}
