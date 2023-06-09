import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionDetailScreen extends StatelessWidget {
  final String collectionId;

  CollectionDetailScreen({required this.collectionId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;

    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('collections')
        .doc(collectionId)
        .collection('videojuegos');

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('collections')
              .doc(collectionId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Text('');
            }

            final collectionData =
                snapshot.data!.data() as Map<String, dynamic>;
            final collectionName = collectionData?['name'] ?? 'Videojuegos';

            return Text(collectionName);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error al cargar los datos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final videojuegos = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 1.0,
            ),
            padding: EdgeInsets.all(16.0),
            itemCount: videojuegos.length,
            itemBuilder: (BuildContext context, int index) {
              final videojuego = videojuegos[index];
              final title = videojuego['title'] as String;
              final poster = videojuego['poster'] as String;
              final estado = videojuego['estado']
                  as String; // Obtener el estado del videojuego

              return GridItemWidget(
                title: title,
                poster: poster,
                estado: estado,
                onDelete: () {
                  // Eliminar elemento de la colección
                  videojuego.reference.delete();
                },
                onMarkCompleted: () {
                  // Marcar como completado
                  // (Cambiar el estado del videojuego a completado en Firebase)
                  videojuego.reference.update({'estado': 'completado'});
                },
                onMarkInProgress: () {
                  // Marcar como en progreso
                  // (Cambiar el estado del videojuego a en progreso en Firebase)
                  videojuego.reference.update({'estado': 'en progreso'});
                },
                onMarkIncomplete: () {
                  // Marcar como sin completar
                  // (Cambiar el estado del videojuego a sin completar en Firebase)
                  videojuego.reference.update({'estado': 'sin completar'});
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GridItemWidget extends StatelessWidget {
  final String title;
  final String poster;
  final String estado;
  final VoidCallback onDelete;
  final VoidCallback onMarkCompleted;
  final VoidCallback onMarkInProgress;
  final VoidCallback onMarkIncomplete;

  const GridItemWidget({
    required this.title,
    required this.poster,
    required this.estado,
    required this.onDelete,
    required this.onMarkCompleted,
    required this.onMarkInProgress,
    required this.onMarkIncomplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color cardColor;

    if (estado == 'completado') {
      cardColor = Color.fromARGB(100, 46, 125, 50);
    } else if (estado == 'en progreso') {
      cardColor = Color.fromARGB(100, 21, 101, 192);
    } else if (estado == 'sin completar') {
      cardColor = Color.fromARGB(100, 198, 40, 40);
    } else {
      cardColor = Colors.white.withOpacity(0.05);
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Color(0xFF1E1E1E),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      title: Text('Eliminar elemento de la colección'),
                      titleTextStyle:
                          TextStyle(color: Colors.white, fontSize: 14),
                      onTap: () {
                        onDelete();
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      title: Text('Marcar como completado'),
                      titleTextStyle:
                          TextStyle(color: Colors.white, fontSize: 14),
                      onTap: () {
                        onMarkCompleted();
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.hourglass_top,
                        color: Colors.white,
                      ),
                      title: Text('Marcar como en progreso'),
                      titleTextStyle:
                          TextStyle(color: Colors.white, fontSize: 14),
                      onTap: () {
                        onMarkInProgress();
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      title: Text('Marcar como sin completar'),
                      titleTextStyle:
                          TextStyle(color: Colors.white, fontSize: 14),
                      onTap: () {
                        onMarkIncomplete();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
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
