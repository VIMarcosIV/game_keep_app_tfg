import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Saved_Elements_Page extends StatefulWidget {
  const Saved_Elements_Page({Key? key}) : super(key: key);

  @override
  _Saved_Elements_PageState createState() => _Saved_Elements_PageState();
}

class _Saved_Elements_PageState extends State<Saved_Elements_Page> {
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

  Future<void> deleteSavedElement(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('elementosGuardados')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Elemento eliminado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el elemento'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> showDeleteDialog(String title, String documentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
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
                title: Text('Eliminar elemento guardado'),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                onTap: () async {
                  await deleteSavedElement(documentId);
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: TextField(
            controller: searchController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar por título',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
              hintStyle: TextStyle(color: Colors.white),
              icon: Icon(Icons.search, color: Colors.yellow),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('elementosGuardados')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
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

          final savedElements = snapshot.data!.docs.where((doc) {
            final title = doc['title'] as String;
            return title.toLowerCase().startsWith(searchText.toLowerCase());
          }).toList();

          return GridView.builder(
            itemCount: savedElements.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 1.0,
            ),
            padding: EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = savedElements[index];
              String title = document['title'] as String;
              String poster = document['poster'] as String;
              String documentId = document.id;
              return GestureDetector(
                onTap: () {
                  showDeleteDialog(title, documentId);
                },
                child: GridItemWidget(
                  title: title,
                  poster: poster,
                ),
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

  const GridItemWidget({
    required this.title,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Saved_Elements_Page(),
  ));
}
