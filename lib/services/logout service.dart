
import 'package:dashdrop_delivery/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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