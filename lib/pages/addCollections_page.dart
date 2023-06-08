import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCollectionScreen extends StatefulWidget {
  @override
  _AddCollectionScreenState createState() => _AddCollectionScreenState();
}

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  late final TextEditingController collectionNameController;
  late List<String> existingCollections =
      []; // Inicializar la lista de colecciones existentes

  @override
  void initState() {
    super.initState();
    collectionNameController = TextEditingController();
    fetchExistingCollections();
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
        fetchExistingCollections(); // Actualizar la lista de colecciones existentes
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

  Future<void> fetchExistingCollections() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('collections');

      final snapshot = await collectionRef.get();
      final collections = snapshot.docs
          .map((doc) => doc['name'] as String)
          .toList()
          .cast<String>(); // Conversión explícita a List<String>

      setState(() {
        existingCollections = collections;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Colección'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.white.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Agregar colección:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextField(
                      controller: collectionNameController,
                      decoration: InputDecoration(
                        labelText: 'Introduce un nombre',
                        hintText: 'Nombre de la Colección',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.yellow,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.yellow,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    IconButton(
                      onPressed: addCollection,
                      icon: Icon(
                        Icons.my_library_add_rounded,
                        color: Colors.yellow,
                        size: 65,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Card(
              color: Colors.white.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Colecciones existentes:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (existingCollections.isEmpty)
                      Text(
                        'No hay colecciones existentes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.yellow,
                        ),
                      )
                    else
                      Align(
                        alignment:
                            Alignment.centerLeft, // Alinear a la izquierda
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: existingCollections.map((collection) {
                            return Text(
                              collection,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.yellow,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
