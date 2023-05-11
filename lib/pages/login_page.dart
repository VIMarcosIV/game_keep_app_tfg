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
              appBar: AppBar(
                title: Text('Video Game App'),
              ),
              body: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/logo.png", scale: 12),
                    SizedBox(height: 40),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: provider.emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: provider.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.logearUsuario(context);
                      },
                      child: Text('Entrar'),
                    ),
                    SizedBox(height: 16),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        provider.loguearUsuarioConGoogle(context);
                      },
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        provider.registrarUsuario(context);
                      },
                      child: Text('Registrarse'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Menu_Page();
          }
        },
      );
    });
  }
}
