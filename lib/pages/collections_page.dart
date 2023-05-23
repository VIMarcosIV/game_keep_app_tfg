import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'logout_page.dart';

class CreateCollectionScreen extends StatefulWidget {
  const CreateCollectionScreen({Key? key}) : super(key: key);

  @override
  _CreateCollectionScreenState createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final _collectionNameController = TextEditingController();

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  void _createCollection() async {
    final user = FirebaseAuth.instance.currentUser;
    final collectionName = _collectionNameController.text.trim();

    if (collectionName.isNotEmpty) {
      final collectionRef =
          FirebaseFirestore.instance.collection('collections');
      final newCollectionDoc = collectionRef.doc();

      await newCollectionDoc.set({
        'userId': user?.uid,
        'collectionId': newCollectionDoc.id,
        'collectionName': collectionName,
      });

      // Clear the text field
      _collectionNameController.clear();

      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La colección se creó exitosamente.'),
        ),
      );

      // Close the dialog
      Navigator.pop(context);
    } else {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingresa un nombre para la colección.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCreateCollectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text('Crear colección'),
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _collectionNameController,
                decoration: InputDecoration(
                  hintText: 'Ingresa el nombre de la colección',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createCollection,
                    child: Text('Aceptar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade800),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red.shade900),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300, // Establece el ancho deseado para el AppBar
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                _showCreateCollectionDialog(context);
              },
              child: Text('Crear colección'),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(0xFF4A4A4A),
          ),
          // Resto del contenido del Scaffold
        ),
      ),
    );
  }
}
