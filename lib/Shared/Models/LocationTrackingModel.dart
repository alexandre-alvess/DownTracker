import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTrackingModel
{
  String id;
  LatLng position;
  String date;
  String monitored;
  String monitoredId;

  LocationTrackingModel({this.id, 
                         this.position, 
                         this.date, 
                         this.monitored, 
                         this.monitoredId});

  LocationTrackingModel.getModel(LocationTrackingModel model)
  {
    this.id = model.id;
    this.position = model.position;
    this.date = model.date;
    this.monitored = model.monitored;
    this.monitoredId = model.monitoredId;
  }
}