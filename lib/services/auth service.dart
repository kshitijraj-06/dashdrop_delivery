import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {

  Future<String?> Register({
    required String email,
    required String password,
    required String username,
}) async {
    try{
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final db = FirebaseFirestore.instance;

      // Create a new user document with a unique ID (consider using user ID)
      final userDocRef = db.collection('users').doc(userCredential.user!.uid);

      // Prepare user data (according to the firestore structure)
      final userData = {
        'email': email,
        'uid' : userCredential.user?.uid,
        'password' : password,
        'phone_number' : userCredential.user?.phoneNumber ?? ' ',
        'photoUrl' : userCredential.user?.photoURL ?? 'https://img.freepik.com/premium-vector/young-smiling-man-holding-pointing-blank-screen-laptop-computer-distance-elearning-education-concept-3d-vector-people-character-illustration-cartoon-minimal-style_365941-927.jpg',
        'name' : userCredential.user?.displayName ?? username,
        'username' : username,
      };
      await userDocRef.set(userData);

      return 'Success';
    }on FirebaseAuthException catch (e) {
      if(e.code == 'weak-password'){
        return 'The Password is too weak.';
      }else if(e.code == 'email-already-in-use'){
        return 'This email is already used by user.';
      }else{
        return e.message;
      }
    }catch (e){
      return e.toString();
    }
  }

  Future<bool> googleSignIn() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if user cancelled or encountered an error
      if (googleUser == null) {
        return false; // Sign-in cancelled
      }

      // Get Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential from Google credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if sign-in was successful
      if (userCredential.user == null) {
        return false; // Sign-in failed
      }

      // Handle new user creation in Firestore (if applicable)
      final User? user = userCredential.user;
      final firestore = FirebaseFirestore.instance;  // Assuming FirebaseFirestore is initialized
      if (userCredential.additionalUserInfo!.isNewUser) {
        await firestore.collection('users').doc(user?.uid).set({
          'name': user?.displayName ?? ' ',
          'uid': user?.uid,
          'photoUrl': user?.photoURL ?? ' ',
          'email': user?.email,
          'username' : user?.displayName,
          'phone_number' : user?.phoneNumber ?? ' ',
          'password' : ' ',
        });
      }

      return true; // Sign-in successful
    } catch (error) {
      print(error); // Log the error for debugging
      return false; // Handle generic error
    }
  }

}
