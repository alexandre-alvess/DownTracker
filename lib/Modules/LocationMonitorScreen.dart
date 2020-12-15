import 'dart:async';
import 'package:AppDown/Shared/MapsLocationBase.dart';
import 'package:AppDown/Shared/Services/LocationBackgroundService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMonitorScreen extends StatefulWidget 
{
  final locationMonitoredId;

  LocationMonitorScreen(this.locationMonitoredId);

  @override
  _LocationMonitorScreenState createState() => _LocationMonitorScreenState();
}

class _LocationMonitorScreenState extends State<LocationMonitorScreen> with MapsLocationBase
{
  StreamSubscription<QuerySnapshot> _locationSubscription;

  _initListenerLocation() async
  {
    var querySnapshot = FirebaseFirestore.instance
                .collection('locationTracking')
                .where('userAuthId', isEqualTo: widget.locationMonitoredId)
                .orderBy('date', descending: true).snapshots();

    _locationSubscription = querySnapshot
    .handleError((dynamic err) {
            _locationSubscription.cancel();
          })
    .listen((QuerySnapshot snapshot) { 

      var result = snapshot.docs.first.data();

      setState(() {
        this.cameraPosition = CameraPosition(
          target: LatLng(result['latitude'], result['longitude']),
          zoom: 16
        );

        moveCamera();
      });
    });
  }

  @override
  initLocation() async
  {
    final latLng = await LocationBackgroundService.getLocationTrackingUser(widget.locationMonitoredId);

    setState(() {
      this.cameraPosition = CameraPosition(
        target: latLng,
        zoom: 16
      );

      moveCamera();
    });
  }

  @override
  void initState() {
    super.initState();
    _initListenerLocation();
    initLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text('Mapas e geolocalização',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: this.cameraPosition,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: onMapCreated,
        ),
      ),
    );
  }
}