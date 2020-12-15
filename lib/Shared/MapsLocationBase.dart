import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapsLocationBase
{
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(-16.691585, -49.296427),
    zoom: 16
  );

  @protected
  dynamic initLocation();

  @protected
  onMapCreated(GoogleMapController googleMapController)  {
    _controller.complete(googleMapController);
  }

  @protected
  moveCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition)
    );
  }
}