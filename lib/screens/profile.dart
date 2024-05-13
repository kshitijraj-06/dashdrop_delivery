import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashdrop_delivery/services/logout%20service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  String displayName = ' ';
  String name = '';
  String email = ' ';
  String phone = ' ';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final docRef = firestore.collection('users').doc(user.uid);  // Assuming 'users' collection and uid as ID
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          setState(() {
            name = userData?['name'] ?? ""; // Handle potential missing field
          });
        } else {
          print('No user document found');
        }
      } else {
        print('No user logged in');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }
  Future<void> _getUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          displayName = user.displayName ?? "";
          email = user.email ?? "";
          phone = user.phoneNumber ?? 'null';
        });
      }
    } catch (error) {
      print('Error getting user display name: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String photoUrl = user?.photoURL ?? 'https://img.freepik.com/premium-vector/young-smiling-man-holding-pointing-blank-screen-laptop-computer-distance-elearning-education-concept-3d-vector-people-character-illustration-cartoon-minimal-style_365941-927.jpg';

    //Colour division ka logic aur defining with maths.
    const Color background = Colors.green;
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 73.23; // 73.23% neeche se white rhega screen
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: gradient,
                    stops: stops,
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter))),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('My Profile',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                            ))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                  child: Image.network(
                    photoUrl,
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 35,
                      ),
                      Expanded(
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 22)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 35, left: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 35,
                      ),
                      Expanded(
                          child: Text(
                        user?.email as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(fontSize: 18)),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 35, left: 12),
                  child:
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 35,
                      ),
                      Expanded(
                          child: Text(
                        user?.phoneNumber ?? 'null',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(fontSize: 18)),
                      )),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Logout().logout();
                      Navigator.pushReplacement(
                          //named krna h!!
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'Log Out',
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w700)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }



}





























