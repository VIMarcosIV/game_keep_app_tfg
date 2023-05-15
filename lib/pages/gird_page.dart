import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Grid_Page extends StatefulWidget {
  const Grid_Page({Key? key}) : super(key: key);

  @override
  _Grid_PageState createState() => _Grid_PageState();
}

class _Grid_PageState extends State<Grid_Page> {
  late final TextEditingController searchController;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromRadius(20),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16), // Añadir relleno a la derecha
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por título',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Establecer color de underline
                        ),
                        hintStyle: TextStyle(color: Colors.white),
                        icon: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('videojuegos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return SnackBar(
              content: Text('Error al cargar los datos'),
              backgroundColor: Colors.red,
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Filtrar los resultados según el texto de búsqueda
          final filteredDocs = snapshot.data!.docs.where((doc) {
            final title = doc['title'] as String;
            return title.toLowerCase().startsWith(searchText.toLowerCase());
          }).toList();

          return GridView.builder(
            itemCount: filteredDocs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 1.0,
            ),
            padding: EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = filteredDocs[index];
              String title = document['title'] as String;
              String poster = document['poster'] as String;
              return gridItemWidget(context, title, poster);
            },
          );
        },
      ),
    );
  }
}

Widget gridItemWidget(BuildContext context, String title, String poster) {
  final theme = Theme.of(context);

  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF4A4A4A),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 110.0, // Tamaño fijo del contenedor de la imagen
          height: 110.0, // Tamaño fijo del contenedor de la imagen
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Radio de borde deseado
            child: Image.network(
              poster,
              fit: BoxFit.contain, // Ajuste de la imagen dentro del contenedor
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headline1!.copyWith(
              fontSize: 10.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

void main() {
  runApp(MaterialApp(
    home: Grid_Page(),
  ));
}
