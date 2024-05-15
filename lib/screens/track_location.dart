import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

import '../utils/polyline.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  Position? userLocation;
  late MapmyIndiaMapController controller;
  List<String> profile = [
    DirectionCriteria.PROFILE_DRIVING,
    DirectionCriteria.PROFILE_BIKING,
    DirectionCriteria.PROFILE_WALKING,
  ];
  List<ResourceList> resource = [
    ResourceList(DirectionCriteria.RESOURCE_ROUTE, "N-T"),
    ResourceList(DirectionCriteria.RESOURCE_ROUTE_ETA, "ETA"),
    ResourceList(DirectionCriteria.RESOURCE_ROUTE_TRAFFIC, "T"),
  ];
  int selectedIndex = 0;
  late ResourceList selectedResource;
  DirectionsRoute? route;

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
    setState(() {
      selectedResource = resource[0];
    });
  }

  @override
  Widget build(BuildContext context) {

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
    MapmyIndiaAccountManager.setRestAPIKey("e5ac151416cf50ea2bbef7a0b11f417f");
    MapmyIndiaAccountManager.setMapSDKKey("e5ac151416cf50ea2bbef7a0b11f417f");
    MapmyIndiaAccountManager.setAtlasClientId(
        "96dHZVzsAusFs_55bdWXYmOoLKn7fx4H5isq5gUMhQh9TDOYK3OMcurWGL98yjydKEdvUyOwVyG6HVwdmlnGtg==");
    MapmyIndiaAccountManager.setAtlasClientSecret(
        "lrFxI-iSEg-0wWQDwjbYlPgPkN7yA0YWdc20RE4oViP6rdKxaaVFFbD6pmm1V4z-wVMQXr6ufM3G4D91aEkXX7gbHJIMOJrf");

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
                'Track',
                style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 80,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      child: userLocation == null
                          ? const Center(child: CircularProgressIndicator())
                      :MapmyIndiaMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              userLocation!.latitude, userLocation!.longitude),
                          zoom: 15.0,
                        ),
                        onMapCreated: (map) => {
                          controller = map,
                        },
                        onStyleLoadedCallback: () => {callDirection()},
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                        child: DefaultTabController(
                          length: 3,
                          child: TabBar(
                            tabs: const [
                              Tab(
                                icon: Icon(Icons.directions_car),
                                text: 'Driving',
                              ),
                              Tab(
                                icon: Icon(Icons.directions_bike),
                                text: "Biking",
                              ),
                              Tab(
                                icon: Icon(Icons.directions_walk),
                                text: "Walking",
                              )
                            ],
                            onTap: (value) => {
                              setState(() {
                                selectedIndex = value;
                              }),
                              if(value!=0) {selectedResource = resource[0]},
                              callDirection()
                            },
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black,
                          )
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        selectedIndex == 0
                        ? Container(
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children:
                              resource.map((data) =>
                              Expanded(child: RadioListTile(
                                title: Text(data.text,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 11
                                  )
                                ),),
                                value: selectedResource,
                                groupValue: data,
                                onChanged: (val) {
                                  setState(() {
                                    selectedResource = data;
                                  });
                                  callDirection();
                                },
                              ))).toList(),
                          ),
                        )
                            : Container()
                      ],
                    )
                  ],
                ),
              ),
              route != null
                ? Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(getDurationAndDistance(), style: const TextStyle(fontSize: 18),),
              )
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  String getDurationAndDistance() {
    return '${getFormattedDistance(route!.distance!.floor())}(${getFormattedDuration(route!.duration!.floor())})';
  }

  String getFormattedDuration(int duration) {
    int min = (duration % 3600 / 60).floor();
    int hours =  (duration % 86400 / 3600).floor();
    int days = (duration / 86400).floor();
    if (days > 0) {
      return '$days ${(days > 1 ? "Days" : "Day")} $hours hr ${(min > 0 ? "$min min": "")}';
    } else {
      return (hours > 0 ? '$hours hr ${(min > 0 ? "$min min" : "")}': '$min min');
    }
  }

  String getFormattedDistance(int distance) {

    if ((distance / 1000) < 1) {
      return '$distance mtr.';
    }
    return '${(distance/ 1000).toStringAsFixed(2)} Km.';
  }

  callDirection() async {

    controller.clearSymbols();
    controller.clearLines();
    setState(() {
      route = null;
    });
    try {
      DirectionResponse? directionResponse = await MapmyIndiaDirection(
          origin: LatLng(userLocation!.latitude, userLocation!.longitude),
          destination: const LatLng(28.554676, 77.186982),
          alternatives: false,
          steps: true,
          resource: selectedResource.value,
          profile: profile[selectedIndex])
          .callDirection();
      if (directionResponse != null &&
          directionResponse.routes != null &&
          directionResponse.routes!.isNotEmpty) {
        setState(() {
          route = directionResponse.routes![0];
        });
        Polyline polyline = Polyline.Decode(
            encodedString: directionResponse.routes![0].geometry, precision: 6);
        List<LatLng> latlngList = [];
        if (polyline.decodedCoords != null) {
          polyline.decodedCoords?.forEach((element) {
            latlngList.add(LatLng(element[0], element[1]));
          });
        }
        if (directionResponse.waypoints != null) {
          List<SymbolOptions> symbols = [];
          directionResponse.waypoints?.forEach((element) {
            symbols.add(SymbolOptions(geometry: element.location, iconImage: 'icon'),);
          });
          controller.addSymbols(symbols);
        }
        drawPath(latlngList);
      }
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  void drawPath(List<LatLng> latlngList) {
    controller.addLine(LineOptions(
      geometry: latlngList,
      lineColor: "#3bb2d0",
      lineWidth: 4,
    ));
    LatLngBounds latLngBounds = boundsFromLatLngList(latlngList);
    controller
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, top: 100, bottom: 20, left: 10, right: 10));
  }

  boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}

class ResourceList {
  final String value;
  final String text;

  ResourceList(this.value, this.text);
}
