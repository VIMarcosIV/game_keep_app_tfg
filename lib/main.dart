import 'library/imports.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // whenever your initialization is completed, remove the splash screen:
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'TFG APP',
      debugShowCheckedModeBanner: false,
      home: Login_Page(),
    );
  }
}
