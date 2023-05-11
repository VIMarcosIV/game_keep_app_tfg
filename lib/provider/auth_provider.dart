import 'package:google_sign_in/google_sign_in.dart';

import '../library/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      FirebaseFirestore.instance
          .collection('roles')
          .doc(credential.user!.uid)
          .set({
        'role': 'user',
        'email': credential.user!.email,
      });
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

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('roles')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (!userDoc.exists) {
        FirebaseFirestore.instance
            .collection('roles')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'email': FirebaseAuth.instance.currentUser!.email,
          'role': 'user',
        });
      }

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

  loguearUsuarioConGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('roles')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (!userDoc.exists) {
        FirebaseFirestore.instance
            .collection('roles')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'email': FirebaseAuth.instance.currentUser!.email,
          'role': 'user',
        });
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Ocurrió un error al acceder a las credenciales. Inténtalo de nuevo.'),
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
  }
}

enum AuthType { signUp, signIn }
