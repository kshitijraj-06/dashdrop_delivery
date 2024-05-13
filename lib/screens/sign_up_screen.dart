import 'package:dashdrop_delivery/functions/square%20tile.dart';
import 'package:dashdrop_delivery/services/auth%20service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dashboard.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool passwordVisible = false;

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
                    'Sign Up',
                    style: GoogleFonts.montserrat(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                ),
                Center(
                  child: Text(
                    'Register Here',
                    style: GoogleFonts.montserrat(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    width: 390,
                    height: 600,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: AlignmentDirectional.centerStart,
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              'Enter Username',
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 12, top: 5, right: 12),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusColor: Colors.green[900],
                                  hoverColor: Colors.black,
                                  fillColor: Colors.green,
                                  hintText: 'Enter your UserName',
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
                              'Enter your email',
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 12, top: 5, right: 12),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusColor: Colors.green[900],
                                  hoverColor: Colors.black,
                                  fillColor: Colors.green,
                                  hintText: 'Enter your Email',
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 12, top: 5, right: 12),
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
                                  hintText: 'Enter your Password',
                                  hintStyle: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(fontSize: 17))),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final message = await AuthService().Register(
                                  email: _emailController.text,
                                  password: _passwordcontroller.text,
                              username: _usernameController.text);
                              if (message!.contains('Success')) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardScreen()));
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(message),
                              ));
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
                            height: 10,
                          ),
                          Text(
                            'Other Sign in Options',
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SquareTile(
                              ImagePath:
                                  'https://as1.ftcdn.net/v2/jpg/03/88/07/84/1000_F_388078454_mKtbdXYF9cyQovCCTsjqI0gbfu7gCcSp.jpg',
                              onTap: () async {
                                bool result = await AuthService().googleSignIn();
                                if(result){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const DashboardScreen()),
                                  );
                                }
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an Account?'),
                              TextButton(onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),
                                );
                              }, child: const Text('Login Here')),
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
  void _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
