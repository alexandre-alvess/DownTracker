import 'package:DownTracker/DataAccess/BaseDAO.dart';
import 'package:DownTracker/Shared/Models/LocationZoneModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sqflite/sqflite.dart';

class LocationZoneDAO extends BaseDAO<LocationZoneModel>
{

  @override
  String get tableName => "LocationZone";

  @override
  LocationZoneModel toModel(Map<String, dynamic> map)
  {
    LocationZoneModel model = new LocationZoneModel();
    model.id = map['id'];
    model.descrition = map['descrition'];
    model.radius = map['radius'];
    //model.emailNotification = map['emailNotification'];
    //model.phoneNotification = map['phoneNotification'];
    model.position = LatLng(map['latitude'], map['longitude']);
    model.ativo = map['ativo'] == 'S';
    model.managerToken = map['managerToken'];

    return model;
  }

  @override
  Map<String, dynamic> toMapData(LocationZoneModel model)
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = model.id;
    data['longitude'] = model.position.longitude;
    data['latitude'] = model.position.latitude;
    data['descrition'] = model.descrition;
    //data['emailNotification'] = model.emailNotification;
    //data['phoneNotification'] = model.phoneNotification;
    data['radius'] = model.radius;
    data['ativo'] = model.ativo ? 'S' : 'N';
    data['managerToken'] = model.managerToken;

    return data;
  }

  Future<bool> existsZoneActive(int id) async
  {
    var dbClient = await dbContext;
    final query = await dbClient.rawQuery('select count(*) from $tableName where ativo = \'S\' AND id <> ?', [id]);
    return Sqflite.firstIntValue(query) > 0;
  }
}