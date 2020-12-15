import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationZoneModel
{
  String id;
  LatLng position;
  String descrition;
  double radius;
  bool ativo;
  String userAuthId;
  String managerToken;

  LocationZoneModel({this.descrition, 
                     this.id, 
                     this.position, 
                     this.radius, 
                     this.ativo,
                     this.userAuthId,
                     this.managerToken});

  LocationZoneModel.getModel(LocationZoneModel model)
  {
    this.id = model.id;
    this.descrition = model.descrition;
    this.position = model.position;
    this.radius = model.radius;
    this.ativo = model.ativo;
    this.userAuthId = model.userAuthId;
    this.managerToken = model.managerToken;
  }
}