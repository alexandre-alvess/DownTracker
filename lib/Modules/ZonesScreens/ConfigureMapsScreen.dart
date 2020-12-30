import 'package:DownTracker/Shared/MapsLocationBase.dart';
import 'package:DownTracker/Shared/Services/LocationService.dart';
import 'package:DownTracker/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfigureMapsScreen extends StatefulWidget 
{
  final LatLng position;
  final double radius;

  const ConfigureMapsScreen({this.position, this.radius});

  @override
  _ConfigureMapsScreenState createState() => _ConfigureMapsScreenState();
}

class _ConfigureMapsScreenState extends State<ConfigureMapsScreen> with MapsLocationBase
{

  String _error;
  LatLng _picketPosition;
  double _zoom = 17.0;
  double _radius = 100;

  bool _isValidPositionAndRadius()
  {
    return _picketPosition != null &&
           _radius != null &&
           _radius >= 100 &&
           _radius <= 500; 
  }

  void _updateCameraPosition()
  {
    this.cameraPosition = CameraPosition(
        target: LatLng(_picketPosition.latitude, _picketPosition.longitude),
        zoom: _zoom
      );
  }

  @override
  initLocation() async
  {
    print('entrou no initlocation');

    try 
    {
      if (widget.position != null && widget.radius != null && widget.radius >= 100 && widget.radius <= 500)
      {
        setState(() {

          _picketPosition = widget.position;
          _updateRadiusAndZoom(widget.radius);
        });
      }
      else
      {
        var result = await new LocationService().getLocation();

        if (result.status) 
        {
          setState(() {
            this.cameraPosition = CameraPosition(
              target: LatLng(result.location.latitude, result.location.longitude),
              zoom: _zoom
            );

            moveCamera();
          });
        }
      }

    } 
    on PlatformException catch (err) 
    {
      setState(() 
      {
        _error = err.code;
      });
    }
  }

  @override
  void initState() 
  {
    super.initState();
    initLocation();
  }

  void _selectZone(LatLng position)
  {
    setState(() 
    {
      _picketPosition = position;  
    });
  }

  _googleMapsWidget()
  {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      compassEnabled: true,
      zoomControlsEnabled: false,
      onTap: _selectZone,
      markers: _picketPosition == null 
      ? null 
      : {
        Marker(
          markerId: MarkerId('p1'),
          position: _picketPosition,
          infoWindow: InfoWindow(
            title: 'Marcador de zona'
          ),
        ),
      },
      circles: _picketPosition == null
      ? null
      : {
        Circle(
          circleId: CircleId('c1'),
          center: _picketPosition,
          fillColor: Colors.blue.withOpacity(0.5),
          radius: _radius,
          strokeWidth: 3,
          strokeColor: Colors.blue
        )
      },
    );
  }

  _rangeRadius()
  {
    return 
    Positioned(
      bottom: 10.0,
      left: 10.0,
      right: 10.0,
      child: Card(
        child: Column(
          children: <Widget>[
            Text(_radius.toInt().toString() + ' Metros',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Slider(
              max: 500, // valor maximo do range
              min: 100, // valor minimo do range
              value: _radius,
              activeColor: Colors.red,
              inactiveColor: Colors.grey,
              divisions: 8,
              onChanged: (double value) {
                print('valor:' + value.toString());

                if (_isValidPositionAndRadius())
                {
                  _updateRadiusAndZoom(value);
                }
                else
                {
                  _updateRadius(value);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _updateRadius(double radius)
  {
    setState(() {
      _radius = radius;
    });
  }

  void _updateRadiusAndZoom(double radius)
  {
    double zoom;
    if (radius >= 100 && radius <= 200)
    {
      zoom = 17.0;
    }
    else if (radius > 200 && radius <= 400)
    {
      zoom = 16.0;
    }
    else if (radius > 400)
    {
      zoom = 15.5;
    }

    setState(() {
      _updateRadius(radius);
      _zoom = zoom;

      _updateCameraPosition();
      moveCamera();

    });
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
        title: Text("Configuração de Zona",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _picketPosition == null
            ? null
            : () {
                var navigatorService = GetIt.I<NavigatorService>().getGlobalKey();
                navigatorService.currentState.pop([_picketPosition, _radius]);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          _googleMapsWidget(),
          _rangeRadius()
        ]
      ),
    );
  }
}