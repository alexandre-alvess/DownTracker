import 'package:AppDown/Modules/ZonesScreens/ConfigureMapsScreen.dart';
import 'package:AppDown/Shared/Services/NavigatorService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {

  final Function onSelectPosition;
  final double radius;
  final LatLng position;

  LocationInput(this.onSelectPosition, {this.radius, this.position});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  LatLng _selectPosition;
  double _selectRadius;

  //String _previewImageUrl;
  /*void _showPreview(double lat, double lng)
  {
    final staticMapImage = LocationUtils.generateLocationPreviewImage(latitude: lat, longitude: lng);

    setState(() {
      _previewImageUrl = staticMapImage;
    });
  }*/

  void _setDateZone(LatLng position, double radius)
  {
    setState(() {
      _selectPosition = position;
      _selectRadius = radius;
    });
  }

  bool _isValidPreview()
  {
    return _selectPosition != null &&
           _selectRadius != null &&
           _selectRadius >= 100 &&
           _selectRadius <= 500; 
  }

  Future<void> _selectOnMap() async
  {
    // chamar tela e aguardar dado da zona
    var navigatorService = GetIt.I<NavigatorService>().getGlobalKey();
    final List<dynamic> listResult = await navigatorService.currentState.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => _isValidPreview() 
                          ? ConfigureMapsScreen(position: _selectPosition, radius: _selectRadius,)
                          : ConfigureMapsScreen()
      )
    );

    print(listResult);

    if (listResult == null || listResult.length < 2) return;

    final LatLng selectPosition = listResult[0];
    final double radius = listResult[1];

    if (selectPosition == null || radius == null) return;

    //_showPreview(selectPosition.latitude, selectPosition.longitude);
    _setDateZone(selectPosition, radius);
    widget.onSelectPosition(selectPosition, radius);
  }

  void _initForm()
  {
    if (widget.position != null && widget.radius != null && widget.radius >= 100 && widget.radius <= 500)
    {
      _setDateZone(widget.position, widget.radius);
    }
  }

  @override
  void initState() 
  {
    super.initState();
    _initForm();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 212,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
              color: Colors.black
            ),
          ),
          child: !_isValidPreview()
            ? Text('Zona de monitoramento não informada !',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
            ) 
            : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 22),
                Text(' Latitude: ${_selectPosition.latitude}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
                SizedBox(height: 22),
                Container(
                  height: 2.0,
                  color: Colors.black,
                ),
                SizedBox(height: 22),
                Text(' Longitude: ${_selectPosition.longitude}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
                SizedBox(height: 22),
                Container(
                  height: 2.0,
                  color: Colors.black,
                ),
                SizedBox(height: 22),
                Text(' Raio da Zona: $_selectRadius',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                )
              ],
            ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Selecione a Zona',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              textColor: Theme.of(context).accentColor,
              onPressed: _selectOnMap, 
            )
          ],
        )
      ],
    );
  }
}