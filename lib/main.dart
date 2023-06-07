import 'package:flutter/services.dart';
import 'package:flutter_tfg/pages/logout_page.dart';
import 'package:provider/provider.dart';

import 'library/imports.dart';
import './provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterNativeSplash.remove();
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
