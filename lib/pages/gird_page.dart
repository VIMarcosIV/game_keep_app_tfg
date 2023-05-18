import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
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
        bottom: PreferredSize(
          preferredSize: Size.fromRadius(20),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                          borderSide: BorderSide(color: Colors.white),
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
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Guardar elemento'),
                onTap: () {
                  // Obtener el ID del usuario logueado
                  String userId = FirebaseAuth.instance.currentUser!.uid;

                  // Lógica para guardar el elemento en Firestore
                  FirebaseFirestore.instance
                      .collection('elementosGuardados')
                      .add({
                    'title': title,
                    'poster': poster,
                    'userId': userId,
                  });

                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Añadir a colección'),
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
  final GestureLongPressCallback onTap;

  const GridItemWidget({
    required this.title,
    required this.poster,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onLongPress: onTap,
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
