import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashdrop_delivery/screens/sign_up_screen.dart';
import 'package:dashdrop_delivery/services/auth%20service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../functions/square tile.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool passwordVisible = false;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;
  final AuthService _authService = AuthService();




  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.green[700],
          // decoration: BoxDecoration(
          //   color: Colors.green,
          //     image: DecorationImage(
          //         image: NetworkImage(
          //             'https://cdn.discordapp.com/attachments/1235479711111446548/1235644938461511680/food-seamless-background-vector-17877102.png?ex=66351f86&is=6633ce06&hm=1936a072636fb59b04e885b0e427a683e5285bb0a10313755f9c9286d9d685b8&',
          //         ),
          //     fit: BoxFit.cover,
          //     )
          // ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 160,
                ),
                Center(
                  child: Text(
                    'DashDrop',
                    style: GoogleFonts.montserrat(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                ),
                Center(
                  child: Text(
                    'Dropping grocering got easier',
                    style: GoogleFonts.montserrat(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 1.05,
                    height: MediaQuery.of(context).size.height / 1.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.white),
                    child:  Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height/50,
                        ),
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            'Enter your email',
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12, top: 5, right: 12),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusColor: Colors.green[900],
                                hoverColor: Colors.black,
                                fillColor: Colors.green,
                                hintText: 'Enter your email',
                                hintStyle: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(fontSize: 17))),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            'Enter your Password',
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12, top: 5, right: 12),
                          child: TextField(
                            obscureText: passwordVisible,
                            controller: _passwordcontroller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusColor: Colors.green[900],
                                hoverColor: Colors.black,
                                fillColor: Colors.green,
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible = !passwordVisible;
                                      },
                                    );
                                  },
                                ),
                                hintText: 'Enter your password',
                                hintStyle: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(fontSize: 17))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/1.10,
                          child: ElevatedButton(
                            onPressed: () {
                              _handleLogin(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                fixedSize: const Size(370, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: Text(
                              'Submit',
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Other Sign in Options',
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(fontSize: 14)),
                        ),
                         SizedBox(
                          height: MediaQuery.of(context).size.height /300,
                        ),
                        SquareTile(
                          ImagePath:
                              'https://cdn.discordapp.com/attachments/1235479711111446548/1236258714630225920/google.png?ex=663bf866&is=663aa6e6&hm=28c91b2ba890f50e0c214b7d05bd56f0e4e8b917d3286e890f3ef2f352c79f3f&',
                          onTap: () async {
                            bool result = await _authService.googleSignIn();
                            if(result){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DashboardScreen()),
                              );
                            }
                             //_signInWithGoogle();
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height /500,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Not a Member?'),
                            TextButton(onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            }, child: const Text('Register Here')),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordcontroller.text,
      );

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {}
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }
}
