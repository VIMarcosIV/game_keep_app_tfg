import 'package:flutter/material.dart';

import '../widgets/gridItemWidget.dart';

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
          return gridItemWidget(context, index);
        }),
      ),
    );
  }
}
