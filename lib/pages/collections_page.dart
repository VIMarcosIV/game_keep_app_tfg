import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'collectionDetail_page.dart';

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
          title: Text('Mis Colecciones'),
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
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 1.0,
              ),
              padding: EdgeInsets.all(16.0),
              itemCount: collections.length,
              itemBuilder: (BuildContext context, int index) {
                final collection = collections[index];
                final collectionId = collection.id;
                final collectionName = collection['name'] as String;

                return GestureDetector(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
