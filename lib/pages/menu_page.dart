import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

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
      // Home_Page(),
      // UpcomingMovies_Page(),
      // PopularMovies_Page(),
      // BestMovies_Page(),
      // CinemaMovies_Page(),
    ];
    return Scaffold(
      appBar: AppBar(
          title: Text("TMDB APP"),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.orange[400]),
      body: _pageOption[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.orange[400],
        color: Colors.white,
        height: 47,
        items: [
          // Aqui van los items que saldran abajo en la NavBar
          // TabItem(icon: Icons.home, title: "Home"),
          // TabItem(icon: Icons.new_releases, title: "News"),
          // TabItem(icon: Icons.people_alt, title: "Popular"),
          // TabItem(icon: Icons.assessment, title: "T.Rated"),
          // TabItem(icon: Icons.confirmation_number_sharp, title: "Cinemas"),
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
