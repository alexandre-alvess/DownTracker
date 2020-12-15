import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';

class LocationBackgroundService
{
  static Future<bool> isLocationInsideRadius(double latitudeTrack, double longitudeTrack, double latitudeZone, double longitudeZone, double radius)
  {
    var gcd = GreatCircleDistance.fromDegrees(
      latitude1: latitudeZone,
      longitude1: longitudeZone,
      latitude2: latitudeTrack,
      longitude2: longitudeTrack
    );

    if (radius > gcd.haversineDistance())
    {
      return Future.value(true);
    }

    return Future.value(false);
  }

  static Future<void> sendNotificationManager(String userId, {String msg = ''}) async
  {
    var nameUser = '';

    var query = await FirebaseFirestore.instance
                      .collection('users')
                      .where('userAuthId', isEqualTo: userId).get();

    if (query.docs.length > 0)
    {
      nameUser = query.docs.first.data()['name'];
    }

    FirebaseFirestore.instance.collection('chat').add({
      'text': 'Nome: $nameUser...Monitorado fora do raio de zona configurada... $msg',
      'createdAt': Timestamp.now(),
      'userId': userId
    });
  }

  static Future<Map<String, dynamic>> getLocationZoneUser(String userAuthId) async
  {
    var query = await FirebaseFirestore.instance
                      .collection('locationZone')
                      .where('userAuthId', isEqualTo: userAuthId)
                      .where('ativo', isEqualTo: true).get();
    
    Map<String, dynamic> map;

    if (query.docs.length > 0)
    {
      var resultData = query.docs.first.data();

      map = {
        'latitude': resultData['latitude'],
        'longitude': resultData['longitude'],
        'radius': resultData['radius']
      };
    
      return map;
    }

    return null;
  }

  static Future<LatLng> getLocationTrackingUser(String monitoredId) async
  {
    var query = await FirebaseFirestore.instance
                      .collection('locationTracking')
                      .where('monitoredId', isEqualTo: monitoredId)
                      .orderBy('date', descending: true).get();
    
    if (query.docs.length > 0)
    {
      LatLng latLng;

      var resultData = query.docs.first.data();
      
      double latitude = resultData['latitude'];
      double longitude = resultData['longitude'];

      latLng = new LatLng(latitude, longitude);
      
      return latLng;
    }

    return null;
  }

  static Future<bool> isUserMonitored(String userId) async
  {
    var query = await FirebaseFirestore.instance
                  .collection('users')
                  .where('userAuthId', isEqualTo: userId)
                  .get();

    if (query.docs.length > 0)
    {
      if (query.docs.first.data()['tipoUser'].toString().toUpperCase() == 'Monitorado'.toUpperCase())
      {
        return Future.value(true);
      }
    }
    
    return Future.value(false);
  }
}