import '../library/imports.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthType _authType = AuthType.signIn;
  AuthType get authType => _authType;

  setAuthType() {
    _authType =
        _authType == AuthType.signIn ? AuthType.signUp : AuthType.signIn;
  }

  // REGISTRAR UN USUARIO
  registrarUsuario(BuildContext context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('La contraseña es muy débil'),
          backgroundColor: Colors.red,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Este correo ya existe'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
  //

  // LOGUEAR USUARIO CON EMAIL/PASSWORD
  logearUsuario(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // El inicio de sesión fue exitoso
      // Puedes realizar acciones adicionales aquí si es necesario
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Credenciales inválidas'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error al iniciar sesión'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}

enum AuthType { signUp, signIn }
