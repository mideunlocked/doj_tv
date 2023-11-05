import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isLogged() {
    try {
      User? user = _firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
