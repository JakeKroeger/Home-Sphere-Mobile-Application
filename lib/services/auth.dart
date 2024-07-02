import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_home_application/models/user.dart';

class authService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser? _userFromFirebaseUser(User? user) {
    return user != null
        ? MyUser(
            uid: user.uid,
            email: user.email ?? '',
            username: user.displayName ?? '')
        : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //--------------Login----------------
  Future loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //--------------Register----------------
  Future<UserCredential> registerWithEmailPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set the username for the registered user
      await userCredential.user?.updateDisplayName(username);

      return userCredential;
    } catch (e) {
      // Handle any errors that occur during registration
      print('Error registering user: $e');
      throw e;
    }
  }

  //--------------Sign Out----------------
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
