import '../library/imports.dart';

Widget gridItemWidget(BuildContext context, int index) {
  final theme = Theme.of(context);

  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF4A4A4A), // Color de fondo gris oscuro (ajustado)
      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo.png", // Ruta de la imagen de muestra
          width: 90, // Ancho de la imagen
          height: 90, // Alto de la imagen
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 8.0, vertical: 10.0), // Ajuste del padding horizontal
          child: Text(
            'Item $index: Titulo de prueba', // Texto del título simplificado
            textAlign: TextAlign.center, // Alineación centrada del texto
            style: theme.textTheme.headline1!.copyWith(
              fontSize: 14.0, // Tamaño de fuente reducido (ajustado)
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
