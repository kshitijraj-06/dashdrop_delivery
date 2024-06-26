import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashdrop_delivery/screens/add%20product.dart';
import 'package:dashdrop_delivery/screens/chats/group_chat.dart';
import 'package:dashdrop_delivery/screens/earning.dart';
import 'package:dashdrop_delivery/screens/live_location.dart';
import 'package:dashdrop_delivery/screens/order_details.dart';
import 'package:dashdrop_delivery/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    String name = user?.displayName ?? '';
    String photoUrl = user?.photoURL ??
        'https://img.freepik.com/premium-vector/young-smiling-man-holding-pointing-blank-screen-laptop-computer-distance-elearning-education-concept-3d-vector-people-character-illustration-cartoon-minimal-style_365941-927.jpg';
    //Colour division ka logic aur defining with maths.
    const Color background = Colors.green;
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    double fillPercent = MediaQuery.of(context).size.height /
        11; // 73.23% neeche se white rhega screen
    double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Stack(children: [
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProfilePage()));
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              photoUrl,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'DashDrop - Partner',
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w500)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageSlideshow(
                          autoPlayInterval: 3500,
                          isLoop: true,
                          children: [
                            Image.network(
                              'https://cdn.pixabay.com/photo/2012/08/27/14/19/mountains-55067_640.png',
                              fit: BoxFit.fill,
                            ),
                            Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/dashdrop-1d768.appspot.com/o/items%2Fbanner2.jpg?alt=media&token=7ebfe473-2724-435d-84b5-3de6683930c0',
                              fit: BoxFit.fill,
                            ),
                            Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/dashdrop-1d768.appspot.com/o/items%2Fbanner3.jpg?alt=media&token=44ee3e5b-b1cc-4f46-8410-d560b8acb3df',
                              fit: BoxFit.fill,
                            )
                          ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Categories',
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                    textStyle:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Container(
                      child: _buildHorizontalCard('Add product', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddProduct()));
                      }),
                    ),
                    Container(
                      child: _buildHorizontalCard('Order Details', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderDetails()));
                      }),
                    ),
                    Container(
                      child: _buildHorizontalCard('My Balance', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FarmerEarningsOverviewPage()));
                      }),
                    ),
                    Container(
                      child: _buildHorizontalCard('Location & Tracking', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LiveLocation()));
                      }),
                    ),
                    Container(
                      child: _buildHorizontalCard('Chat & Support', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(currentUserId: user!.uid)));
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Summary',
                style: GoogleFonts.montserrat(
                    textStyle:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Name :',
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                        child: Text(
                      name,
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 14)),
                      textAlign: TextAlign.end,
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Number of Products Listed :',
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 14)),
                    ),
                    FutureBuilder<int>(
                      future:
                          getTotalProducts(), // Replace with your function to fetch total orders
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Handle errors
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child:
                                  CircularProgressIndicator()); // Show loading indicator
                        }

                        final totalOrders =
                            snapshot.data!; // Access the fetched data (int)

                        return Expanded(
                          child: Text(
                            textAlign: TextAlign.end,
                            '$totalOrders',
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(fontSize: 14)),
                          ),
                        ); // Display the total orders
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total Order :',
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 14)),
                    ),
                    FutureBuilder<int>(
                      future:
                          getTotalOrders(), // Replace with your function to fetch total orders
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Handle errors
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child:
                                  CircularProgressIndicator()); // Show loading indicator
                        }

                        final totalOrders =
                            snapshot.data!; // Access the fetched data (int)

                        return Expanded(
                          child: Text(
                            textAlign: TextAlign.end,
                            '$totalOrders',
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(fontSize: 14)),
                          ),
                        ); // Display the total orders
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Amount (INR) :',
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                        child: Text(
                      '10000',
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 14)),
                      textAlign: TextAlign.end,
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  Future<int> getTotalOrders() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders') // Replace with your actual collection name
          .get();

      return querySnapshot.size;
    } catch (error) {
      print('Error fetching total orders: $error');
      return 0; // Handle error by returning 0 or another default value
    }
  }

  Future<int> getTotalProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      return querySnapshot.size;
    } catch (error) {
      print('Error : $error');
      return 0;
    }
  }

  Widget _buildHorizontalCard(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 7, right: 7),
        child: Card(
          elevation: 3,
          shadowColor: Colors.green,
          surfaceTintColor: Colors.green[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: 90,
            width: 90,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
