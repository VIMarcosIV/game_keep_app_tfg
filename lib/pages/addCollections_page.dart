import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCollectionScreen extends StatefulWidget {
  @override
  _AddCollectionScreenState createState() => _AddCollectionScreenState();
}

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  late final TextEditingController collectionNameController;

  @override
  void initState() {
    super.initState();
    collectionNameController = TextEditingController();
  }

  @override
  void dispose() {
    collectionNameController.dispose();
    super.dispose();
  }

  Future<void> addCollection() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final collectionName = collectionNameController.text.trim();

      if (collectionName.isNotEmpty) {
        final collectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('collections');

        final newCollectionRef = await collectionRef.add({
          'name': collectionName,
        });

        // Aquí puedes realizar alguna acción adicional después de agregar la colección

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Colección agregada correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        collectionNameController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ingrese un nombre válido para la colección'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Colección'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: collectionNameController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Colección',
                labelStyle: TextStyle(
                    color: Colors.yellow), // Cambiar el color del label
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .yellow), // Cambiar el color del borde cuando el TextField no está enfocado
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .yellow), // Cambiar el color del borde cuando el TextField está enfocado
                ),
              ),
              style: TextStyle(
                  color:
                      Colors.white), // Cambiar el color del texto del TextField
            ),
            SizedBox(height: 16.0),
            IconButton(
              onPressed: addCollection,
              icon: Icon(
                Icons.my_library_add_rounded,
                color: Colors.yellow, // Cambiar el color del icono a amarillo
                size: 65,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
