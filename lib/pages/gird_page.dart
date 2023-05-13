import 'package:flutter/material.dart';

class Grid_Page extends StatelessWidget {
  const Grid_Page({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Screen'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Número de columnas
        mainAxisSpacing:
            12.0, // Espacio vertical entre los elementos (ajustado)
        crossAxisSpacing:
            12.0, // Espacio horizontal entre los elementos (ajustado)
        padding: EdgeInsets.all(
            16.0), // Separación con el borde de la pantalla (ajustado)
        children: List.generate(8, (index) {
          return _buildGridItem(context, index);
        }),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
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
                horizontal: 8.0,
                vertical: 10.0), // Ajuste del padding horizontal
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
}
