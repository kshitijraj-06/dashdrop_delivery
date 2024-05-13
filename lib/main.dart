import 'package:dashdrop_delivery/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp( const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  checkIfLogin() async{
    auth.authStateChanges().listen((User? user) {
      if(user!= null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DashDrop - Partners',
      theme: ThemeData(),
      home: const LoginScreen(),
    );
  }
}
