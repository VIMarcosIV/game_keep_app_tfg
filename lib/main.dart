import 'package:flutter_tfg/pages/logout_page.dart';
import 'package:provider/provider.dart';

import 'library/imports.dart';
import './provider/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.remove(); // Remove the 'await' keyword
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Your App Title',
        debugShowCheckedModeBanner: false,
        theme: customTheme,
        home: Login_Page(),
        routes: {
          '/login': (context) => Login_Page(),
          '/logout': (context) => Logout_Page(),
        },
      ),
    );
  }
}
