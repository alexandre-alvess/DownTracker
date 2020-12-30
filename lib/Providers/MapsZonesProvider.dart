import 'package:DownTracker/DataAccess/LocationZoneDAO.dart';
import 'package:DownTracker/Shared/Models/LocationZoneModel.dart';
import 'package:DownTracker/Shared/Services/LocationBackgroundService.dart';
import 'package:DownTracker/Shared/Services/SessionService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapsZonesProvider with ChangeNotifier
{
  final serviceDAO = new LocationZoneDAO();
  
  List<LocationZoneModel> _items = [];

  List<LocationZoneModel> get items 
  {
    return [..._items];
  }

  int get count
  {
    return _items.length;
  }

  Future<void> loadZones() async
  {
    final userSession = await SessionService.getSessionMap();
    final isMonitored = await LocationBackgroundService.isUserMonitored(userSession['userId']);

    if (isMonitored)
    {
      await loadZonesMonitored(userSession['userId']);
    }
    else
    {
      await loadZonesMonitor(userSession['userId']);
    }
  }

  Future<void> loadZonesMonitor(String managerTokenId) async 
  {
    _items.clear();

    var query = await FirebaseFirestore.instance
                      .collection('locationZone')
                      .where('managerToken', isEqualTo: managerTokenId)
                      .get();
    
    query.docs.forEach((element) { 
      var data = element.data();

      LocationZoneModel model = new LocationZoneModel();
      model.id = element.id;
      model.ativo = data['ativo'];
      model.descrition = data['descrition'];
      model.position = LatLng(data['latitude'], data['longitude']);
      model.radius = data['radius'];
      model.userAuthId = data['userAuthId'];
      model.managerToken = data['managerToken'];

      _items.add(model);
    });

    notifyListeners();
  }

  Future<void> loadZonesMonitored(String userId) async
  {
    _items.clear();

    var query = await FirebaseFirestore.instance
                      .collection('locationZone')
                      .where('userAuthId', isEqualTo: userId)
                      .get();

    query.docs.forEach((element) { 
      var data = element.data();

      LocationZoneModel model = new LocationZoneModel();
      model.id = element.id;
      model.ativo = data['ativo'];
      model.descrition = data['descrition'];
      model.position = LatLng(data['latitude'], data['longitude']);
      model.radius = data['radius'];
      model.userAuthId = data['userAuthId'];
      model.managerToken = data['managerToken'];

      _items.add(model);
    });

    notifyListeners();
  }

  Future<bool> addZone(LocationZoneModel model) async
  {
    try
    {
      await FirebaseFirestore.instance.collection('locationZone').add({
        'ativo': model.ativo,
        'descrition': model.descrition,
        'latitude': model.position.latitude,
        'longitude': model.position.longitude,
        'radius': model.radius,
        'userAuthId': model.userAuthId,
        'managerToken': model.managerToken,
      });

      _updateZones();

      return true;
    }
    catch (error)
    {
      return false;
    }
  }

  Future<bool> updateZone(LocationZoneModel model) async
  {
    try
    {
      final zoneData = {
        'ativo': model.ativo,
        'descrition': model.descrition,
        'latitude': model.position.latitude,
        'longitude': model.position.longitude,
        'radius': model.radius,
        'userAuthId': model.userAuthId,
        'managerToken': model.managerToken,
      };

      await FirebaseFirestore.instance.collection('locationZone').doc(model.id).set(zoneData);

      _updateZones();

      return true;
    }
    catch (error)
    {
      return false;
    }
  }

  void _updateZones() async
  {
    _items.clear();
    loadZones();    
  }

  LocationZoneModel itemByIndex(int index)
  {
    return _items[index];
  }

}