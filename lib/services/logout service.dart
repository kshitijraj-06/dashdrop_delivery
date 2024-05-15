
import 'package:firebase_auth/firebase_auth.dart';
class Logout {
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Successfully logged out');
    } catch (error) {
      print('Error logging out: $error');
    }
  }
}