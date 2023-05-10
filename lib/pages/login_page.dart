import 'package:provider/provider.dart';

import '../library/imports.dart';
import '../provider/auth_provider.dart';

class Login_Page extends StatelessWidget {
  const Login_Page({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: provider.emailController,
                          decoration:
                              InputDecoration(prefixIcon: Icon(Icons.email)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: provider.passwordController,
                          obscureText: true,
                          decoration:
                              InputDecoration(prefixIcon: Icon(Icons.password)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.logearUsuario(context);
                        },
                        child: Text('Entrar'),
                      ),
                      SignInButton(
                        Buttons.Google,
                        onPressed: (
                            // REGISTRO CON GOOGLE
                            ) {
                          // Acción a realizar cuando se presione el botón de Google
                          // por ejemplo, iniciar sesión con Google.
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          provider.registrarUsuario(context);
                        },
                        child: Text('Registrarse'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Home_Page();
          }
        },
      );
    });
  }
}
