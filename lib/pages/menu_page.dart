import 'package:flutter_tfg/pages/logout_page.dart';
import 'package:flutter_tfg/pages/savedElements_page.dart';
import '../library/imports.dart';
import 'addCollections_page.dart';
import 'collections_page.dart';
import 'gird_page.dart';

class Menu_Page extends StatefulWidget {
  const Menu_Page({super.key});

  @override
  State<Menu_Page> createState() => _Menu_PageState();
}

int selectedPage = 0;

class _Menu_PageState extends State<Menu_Page> {
  @override
  Widget build(BuildContext context) {
    var _pageOption = [
      // Aquí van las screens
      Grid_Page(),
      CollectionScreen(),
      Saved_Elements_Page(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 24.0),
            children: [
              TextSpan(
                text: 'Game ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'Keep',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
        elevation: 15,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 33.5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Logout_Page()),
              );
            },
          ),
        ],
      ),
      body: _pageOption[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        style: TabStyle.textIn,
        color: Colors.white,
        activeColor: Colors.white,
        height: 55,
        items: [
          // Aquí van los items que saldrán abajo en la NavBar
          TabItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            title: "Inicio",
          ),
          TabItem(
            icon: Icons.collections_bookmark_outlined,
            activeIcon: Icons.collections_bookmark,
            title: "Colecciones",
          ),
          TabItem(
            icon: Icons.bookmark_border_rounded,
            activeIcon: Icons.bookmark_border,
            title: "Guardados",
          ),
        ],
        initialActiveIndex: selectedPage,
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
