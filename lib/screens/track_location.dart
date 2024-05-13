import 'package:flutter/material.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class LiveLocation extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    MapmyIndiaAccountManager.setRestAPIKey("e5ac151416cf50ea2bbef7a0b11f417f");
    MapmyIndiaAccountManager.setMapSDKKey("e5ac151416cf50ea2bbef7a0b11f417f");
    MapmyIndiaAccountManager.setAtlasClientId("96dHZVzsAusFs_55bdWXYmOoLKn7fx4H5isq5gUMhQh9TDOYK3OMcurWGL98yjydKEdvUyOwVyG6HVwdmlnGtg==");
    MapmyIndiaAccountManager.setAtlasClientSecret("lrFxI-iSEg-0wWQDwjbYlPgPkN7yA0YWdc20RE4oViP6rdKxaaVFFbD6pmm1V4z-wVMQXr6ufM3G4D91aEkXX7gbHJIMOJrf");
    final apiKey = "e5ac151416cf50ea2bbef7a0b11f417f";

    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body: MapmyIndiaMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(28.6139, 77.2088), // Replace with desired coordinates
          zoom: 15.0,
        ),
      ),
    );
  }


}