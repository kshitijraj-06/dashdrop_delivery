import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettings extends StatefulWidget{
  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
   return Stack(
     children: [
       Scaffold(
         body: Text('Account Settings'),
       )
     ],
   );
  }
}