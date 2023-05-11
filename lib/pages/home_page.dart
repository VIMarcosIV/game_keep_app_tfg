import '../library/imports.dart';

@override
class Home_Page extends StatelessWidget {
  const Home_Page({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Game App'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gamepad,
              size: 100,
              color: Theme.of(context).cardColor,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to the Video Game App',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 8),
            Text(
              'Get ready to play and have fun!',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Start Playing'),
            ),
          ],
        ),
      ),
    );
  }
}
