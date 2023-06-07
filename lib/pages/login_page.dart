import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../library/imports.dart';
import '../provider/auth_provider.dart';

class Login_Page extends StatelessWidget {
  const Login_Page({Key? key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/logo.png", scale: 8),
                            SizedBox(height: 40),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: provider.emailController,
                                style: TextStyle(
                                    color: Colors.white), // Color del texto
                                cursorColor: Colors.teal, // Color del cursor
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email,
                                      color: Colors.white), // Color del icono
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Color del subrayado cuando no está seleccionado
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Color del subrayado cuando está seleccionado
                                  ),
                                  hintText: 'Correo Electrónico',
                                  hintStyle: TextStyle(
                                      color: Colors
                                          .white70), // Color del texto de sugerencia
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: provider.passwordController,
                                obscureText: true,
                                style: TextStyle(
                                    color: Colors.white), // Color del texto
                                cursorColor: Colors.teal, // Color del cursor
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.password,
                                      color: Colors.white), // Color del icono
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Color del subrayado cuando no está seleccionado
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Color del subrayado cuando está seleccionado
                                  ),
                                  hintText: 'Contraseña',
                                  hintStyle: TextStyle(
                                      color: Colors
                                          .white70), // Color del texto de sugerencia
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  provider.logearUsuario(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text('Entrar'),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: SignInButton(
                                Buttons.Google,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: () {
                                  provider.loguearUsuarioConGoogle(context);
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  provider.registrarUsuario(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(231, 25, 31, 0.86),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text('Registrarse'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
