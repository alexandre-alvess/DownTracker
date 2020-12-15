import 'package:AppDown/Shared/MapsLocationBase.dart';
import 'package:AppDown/Shared/Services/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with MapsLocationBase {

  StreamSubscription<LocationData> _locationSubscription;
  String _error;
  Location _locationService = new Location();

  _initListenerLocation() async {

    await _locationService.changeSettings(
      accuracy: LocationAccuracy.HIGH, // define a precisão de localização do usuário
      distanceFilter: 10.0 // define a distância percorrida pelo usuário como parâmetro de atualiação
      /* parâmetro de atualização por tempo, funciona apenas para o Android
        esse parâmetro está configurado como default do flutter */
    );

    try
    {
      var serviceStatus = await _locationService.serviceEnabled();

      if (serviceStatus) {

        var permission = await _locationService.requestPermission();
        if (permission == PermissionStatus.GRANTED) {
          
          //var location = await _locationService.getLocation();

          _locationSubscription = _locationService.onLocationChanged()
          .handleError((dynamic err) {
            setState(() {
              _error = err.code;
            });

            _locationSubscription.cancel();
          })
          .listen((LocationData result) {

            print('localização atual: ' + result.toString());

            setState(() {
              this.cameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude),
                zoom: 16
              );

              moveCamera();
            });
          });
        }
      } else {
        // tenta solicitar ao usuario a permissão de localização
        bool serviceStatusResult = await _locationService.requestService();

        if  (serviceStatusResult) {
          _initListenerLocation();
        }
      }
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    }
  }

  @override
  initLocation() async {

    try {

      var result = await new LocationService().getLocation();

      if (result.status) {
        setState(() {
          this.cameraPosition = CameraPosition(
            target: LatLng(result.location.latitude, result.location.longitude),
            zoom: 16
          );

          moveCamera();
        });
      }

    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initListenerLocation();
    initLocation();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text("Mapas e geolocalização",
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