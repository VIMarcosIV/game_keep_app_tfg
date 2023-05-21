import 'package:flutter_tfg/pages/gird_page.dart';
import 'package:flutter_tfg/pages/logout_page.dart';
import 'package:flutter_tfg/pages/savedElements_page.dart';

import '../library/imports.dart';

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
      // Aqui van las screens
      Grid_Page(),
      Home_Page(),
      Saved_Elements_Page()
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("TFG APP"),
        //Aqui tiene que estar el icono con el usuario para que le mande a la vista de su cuenta
      ),
      body: _pageOption[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        style: TabStyle.textIn,
        color: Colors.black,
        activeColor: Colors.black,
        height: 55,
        items: [
          // Aqui van los items que saldran abajo en la NavBar
          TabItem(
            icon: Icons.home,
            activeIcon: Icons.home_outlined,
            title: "Inicio",
          ),
          TabItem(
            icon: Icons.collections_bookmark,
            activeIcon: Icons.collections_bookmark_outlined,
            title: "Colecciones",
          ),
          TabItem(
            icon: Icons.bookmark,
            activeIcon: Icons.bookmark_border_rounded,
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
