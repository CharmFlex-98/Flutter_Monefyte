import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class CustomColors {
  static late MaterialColor darkBlue;
  static late MaterialColor greyBlue;
  static late MaterialColor greyPurple;
  static late MaterialColor lightBrown;
  static late MaterialColor paleWhite;
  static late MaterialColor lightYellow;
  static late MaterialColor darkRed;
  static late MaterialColor whitePurple;
  // static late MaterialColor darkGreen;
  // static late MaterialColor whiteYellow;
  // static late MaterialColor brown;
  // static late MaterialColor darkBrown;

  static void init() {
    CustomColors.darkBlue =
        MaterialColor(0xFF22223B, _createSwatch(0xFF22223B));
    CustomColors.greyBlue =
        MaterialColor(0xFF4A4E69, _createSwatch(0xFF4A4E69));
    CustomColors.greyPurple =
        MaterialColor(0xFF9A8C98, _createSwatch(0xFF9A8C98));
    CustomColors.lightBrown =
        MaterialColor(0xFFC9ADA7, _createSwatch(0xFFC9ADA7));
    CustomColors.paleWhite =
        MaterialColor(0xFFF2E9E4, _createSwatch(0xFFF2E9E4));
    CustomColors.lightYellow =
        MaterialColor(0xFFF2F3AE, _createSwatch(0xFFF2F3AE));

    CustomColors.darkRed = MaterialColor(0xFF6F1D1B, _createSwatch(0xFF6F1D1B));

    CustomColors.whitePurple =
        MaterialColor(0xFFD1CCDC, _createSwatch(0xFFD1CCDC));
    // CustomColors.darkGreen =
    //     MaterialColor(0xFF424C55, _createSwatch(0xFF424C55));
    // CustomColors.whiteYellow =
    //     MaterialColor(0xFFF5EDF0, _createSwatch(0xFFF5EDF0));
    // CustomColors.brown = MaterialColor(0xFF886F68, _createSwatch(0xFF886F68));
    // CustomColors.darkBrown =
    //     MaterialColor(0xFF3D2C2E, _createSwatch(0xFF3D2C2E));
  }

  static Map<int, Color> _createSwatch(int code) {
    return <int, Color>{
      50: Color(code),
      100: Color(code),
      200: Color(code),
      300: Color(code),
      400: Color(code),
      500: Color(code),
      600: Color(code),
      700: Color(code),
      800: Color(code),
      900: Color(code),
    };
  }
}

class SizeController {
  static late double _screenSize;

  static void init(BuildContext context) {
    _screenSize = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        kBottomNavigationBarHeight);
  }

  static double setHeight(double ratio) {
    return _screenSize * ratio;
  }

  static double setWidth(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.width * ratio;
  }
}

class CurrencyFormatter {
  static final Box _utilsBox = Hive.box('utils');

  CurrencyFormatter() {
    if (_utilsBox.get('currencyFormat') == null ||
        _utilsBox.get('currencySymbol') == null) {
      _utilsBox.put('currencyFormat', 'USD');
      _utilsBox.put('currencySymbol', '\$');
    }
  }

  static String getCurrencyFormat() {
    return _utilsBox.get('currencyFormat');
  }

  static String getCurrencySymbol() {
    return _utilsBox.get('currencySymbol');
  }

  static setCurrencyFormat(String currencyFormat, String currencySymbol) {
    _utilsBox.put('currencyFormat', currencyFormat);
    _utilsBox.put('currencySymbol', currencySymbol);
  }
}

class Palette {
  static const color1 = Color(0xFF264653);
  static const color2 = Color(0xFF2A9D8F);
  static const color3 = Color(0xFFE9C46A);
  static const color4 = Color(0xFFF4A261);
  static const color5 = Color(0xFFE76F51);
  static const color6 = Color(0xFF9A8C98);
  static const color7 = Color(0xFF931F1D);
  static const color8 = Color(0xFFEE92C2);
  static const color9 = Color(0xFF9D6A89);
  static const color10 = Color(0xFFD90368);
  static const color11 = Color(0xFF2978A0);

  static List<Color> getColorPalette() {
    return [
      color1,
      color2,
      color3,
      color4,
      color5,
      color6,
      color7,
      color8,
      color9,
      color10,
      color11
    ];
  }
}

class Utils {
  static void showToastMsg(String msg) {
    Fluttertoast.showToast(msg: msg);
    DateTime startTime = DateTime.now();
    while (DateTime.now().difference(startTime) < const Duration(seconds: 1)) {
      continue;
    }
    Fluttertoast.cancel();
  }
}
