
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:geolocator/geolocator.dart';

import 'track_location.dart';

class LiveLocation extends StatefulWidget {
  const LiveLocation({super.key});

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  Position? userLocation;
  late MapmyIndiaMapController controller;

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle permission denied scenario (e.g., display a message)
      print("Location permission denied");
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = position;
      });
    } catch (e) {
      // Handle location service errors (e.g., disabled, timeout)
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    MapmyIndiaAccountManager.setMapSDKKey("e5ac151416cf50ea2bbef7a0b11f417f");
    MapmyIndiaAccountManager.setRestAPIKey("e5ac151416cf50ea2bbef7a0b11f417f");
    MapmyIndiaAccountManager.setAtlasClientId(
        "96dHZVzsAusFs_55bdWXYmOoLKn7fx4H5isq5gUMhQh9TDOYK3OMcurWGL98yjydKEdvUyOwVyG6HVwdmlnGtg==");
    MapmyIndiaAccountManager.setAtlasClientSecret(
        "lrFxI-iSEg-0wWQDwjbYlPgPkN7yA0YWdc20RE4oViP6rdKxaaVFFbD6pmm1V4z-wVMQXr6ufM3G4D91aEkXX7gbHJIMOJrf");

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          body: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
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
              SizedBox(
                height: height / 30,
              ),
              Text(
                'Your Location',
                style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 67,
              ),
              SizedBox(
                width: width / 1.02,
                height: height / 1.8,
                child: userLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : MapmyIndiaMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        userLocation!.latitude, userLocation!.longitude),
                    zoom: 15.0,
                  ),
                  onMapCreated: (map) => {controller = map},
                  onStyleLoadedCallback: () => {addMarker()},
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Tracking()));
                },
                child: Text('Track Recent Order',
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20
                      )
                  ),),
              )
            ],
          ),
        )
      ],
    );
  }

  void addMarker() async {
    Symbol symbol = await controller.addSymbol(SymbolOptions(
        geometry: LatLng(userLocation!.latitude, userLocation!.longitude)));
  }
}
