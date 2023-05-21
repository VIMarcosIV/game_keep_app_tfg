import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Logout_Page extends StatefulWidget {
  const Logout_Page({Key? key}) : super(key: key);

  @override
  State<Logout_Page> createState() => _Logout_PageState();
}

class _Logout_PageState extends State<Logout_Page> {
  final user = FirebaseAuth.instance.currentUser;
  int savedElementsCount = 0;

  @override
  void initState() {
    super.initState();
    countSavedElements();
  }

  void countSavedElements() async {
    final userId = user?.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection(
            'elementosGuardados') // Nombre de la colección que almacena los elementos guardados
        .where('userId', isEqualTo: userId)
        .get();
    setState(() {
      savedElementsCount = querySnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    int collectionsCount = 5; // Número de colecciones (hardcodeado)

    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta de usuario'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user?.photoURL != null)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.grey[800],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número de elementos guardados:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      savedElementsCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.grey[800],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número de colecciones:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      collectionsCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            onPrimary: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            'Cerrar sesión',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
