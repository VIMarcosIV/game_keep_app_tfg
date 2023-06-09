import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addCollections_page.dart';
import 'collectionDetail_page.dart';
import 'dart:math';

class CollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('collections');

      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Mis Colecciones'),
              IconButton(
                icon: Icon(Icons.my_library_add_rounded),
                iconSize: 40,
                color: Colors.yellow,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCollectionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: collectionRef.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error al cargar los datos');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final collections = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 0.80,
              ),
              padding: EdgeInsets.all(16.0),
              itemCount: collections.length,
              itemBuilder: (BuildContext context, int index) {
                final collection = collections[index];
                final collectionId = collection.id;
                final collectionName = collection['name'] as String;

                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color(0xFF1E1E1E),
                          title: Text(
                            'Eliminar colección',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            '¿Estás seguro de que quieres eliminar esta colección?',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Eliminar',
                                style: TextStyle(
                                  color: Color.fromRGBO(231, 25, 31, 0.86),
                                ),
                              ),
                              onPressed: () {
                                // Eliminar la colección de Firebase
                                collection.reference.delete();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CollectionDetailScreen(collectionId: collectionId),
                      ),
                    );
                  },
                  child: GridItemWidget(
                    title: collectionName,
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text('Usuario no autenticado'),
        ),
      );
    }
  }
}

class GridItemWidget extends StatelessWidget {
  final String title;

  const GridItemWidget({required this.title});

  Color _generateRandomColor() {
    Random random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromARGB(100, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    Color randomColor = _generateRandomColor();

    return Container(
      decoration: BoxDecoration(
        color: randomColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
