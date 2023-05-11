import '../library/imports.dart';

final ThemeData customTheme = ThemeData(
  primaryColor: Color(0xFF1E1E1E), // Color principal - Fondo oscuro
  hintColor: Color(0xFF00ADB5), // Color de acento - Turquesa
  scaffoldBackgroundColor:
      Color(0xFF1E1E1E), // Color de fondo del scaffold - Fondo oscuro
  appBarTheme: AppBarTheme(
    backgroundColor:
        Color(0xFF1E1E1E), // Color de fondo del AppBar - Fondo oscuro
    elevation: 0, // Sin sombra
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white, // Color del texto del AppBar - Blanco
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white, // Color del texto principal - Blanco
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      color: Color(0xFF00ADB5), // Color del texto secundario - Turquesa
      fontSize: 16,
    ),
    button: TextStyle(
      color: Colors.white, // Color del texto de los botones - Blanco
      fontSize: 16,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Color(
          0xFF00ADB5), // Color de fondo de los botones elevados - Turquesa
      onPrimary:
          Colors.white, // Color del texto de los botones elevados - Blanco
      elevation: 0, // Sin sombra
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);
