import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated(GoogleMapController googleMapController)
  {
    _controller.complete(googleMapController);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas e geolocalização"),),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          // -16.691585, -49.296427 longitude e latitude de teste
          initialCameraPosition: CameraPosition(
            target: LatLng(-16.691585, -49.296427),
            zoom: 16
          ),
        onMapCreated: _onMapCreated,
        ),
      ),
    );
  }
}