import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFBF0449);
const Color secondaryColor = Color(0xFF582059);
const Color tertiaryColor = Color(0xFFF2E30C);
const Color quaternaryColor = Color(0xFFF29F05);
const Color quinaryColor = Color(0xFFBF4D0B);

ThemeData getAppTheme({bool darkMode = false}) {
  return ThemeData(
    brightness: darkMode ? Brightness.dark : Brightness.light,
    appBarTheme: AppBarTheme(backgroundColor: Color(0xFFFEFEFE)),
    scaffoldBackgroundColor: Color(0xFFFEFEFE),
    colorScheme: darkMode
        ? ColorScheme.dark(
            primary: primaryColor,
            secondary: secondaryColor,
            tertiary: quaternaryColor,
            surface: quinaryColor,
            background: tertiaryColor,
          )
        : ColorScheme.light(
            primary: primaryColor,
            secondary: secondaryColor,
            tertiary: quaternaryColor,
            surface: quinaryColor,
            background: tertiaryColor,
          ),
  );
}
