import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        title: Container(
          width: double.infinity,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por título',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintStyle: TextStyle(color: Colors.white),
              icon: Icon(Icons.search, color: Colors.white),
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
              return GridItemWidget(
                title: title,
                poster: poster,
                onTap: () => _showOptionsDialog(context, title, poster),
              );
            },
          );
        },
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, String title, String poster) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.bookmark,
                  color: Colors.white,
                ),
                title: Text('Guardar elemento'),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                onTap: () async {
                  // Obtener el ID del usuario logueado
                  String userId = FirebaseAuth.instance.currentUser!.uid;

                  // Verificar si el elemento ya ha sido guardado
                  final snapshot = await FirebaseFirestore.instance
                      .collection('elementosGuardados')
                      .where('userId', isEqualTo: userId)
                      .where('title', isEqualTo: title)
                      .get();

                  if (snapshot.docs.isEmpty) {
                    // El elemento no ha sido guardado, guardarlo en Firestore
                    await FirebaseFirestore.instance
                        .collection('elementosGuardados')
                        .add({
                      'title': title,
                      'poster': poster,
                      'userId': userId,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Elemento guardado correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // El elemento ya ha sido guardado
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('El elemento ya ha sido guardado'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                title: Text('Añadir a colección'),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                onTap: () {
                  // Lógica para añadir a colección
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class GridItemWidget extends StatelessWidget {
  final String title;
  final String poster;
  final GestureTapCallback onTap;

  const GridItemWidget({
    required this.title,
    required this.poster,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4A4A4A),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110.0,
              height: 110.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  poster,
                  fit: BoxFit.contain,
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Grid_Page(),
  ));
}
