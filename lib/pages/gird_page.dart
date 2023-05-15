import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Grid_Page extends StatelessWidget {
  const Grid_Page({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('videojuegos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error al cargar los datos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 1.0,
            ),
            padding: EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              String title = document['title'];
              //Añadir el resto de datos
              return gridItemWidget(context, title);
            },
          );
        },
      ),
    );
  }
}

Widget gridItemWidget(BuildContext context, String title) {
  final theme = Theme.of(context);

  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF4A4A4A),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 90,
          height: 90,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headline1!.copyWith(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
