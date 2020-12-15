import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService 
{

  Future<LocationModel> getLocation() async 
  {
    LocationModel model = new LocationModel();
    var locationService = new Location();

    try 
    {
      var serviceStatus = await locationService.serviceEnabled();

      if (serviceStatus) 
      {
        var permission = await locationService.requestPermission();
        
        if (permission == PermissionStatus.GRANTED) 
        {
          var location = await locationService.getLocation();

          model.location = location;
          model.status = true;
        } 
        else 
        {
          model.status = false;
        }
      } 
      else 
      {
        bool serviceStatusResult = await locationService.requestService();

        // tenta solicitar ao usuario a permissão de localização
        if (serviceStatusResult) 
        { 
          this.getLocation();
        }
      }
      return model;
    } 
    on PlatformException catch (err) 
    {
      throw err;
    }
  }
}

class LocationModel
{
  LocationData location;
  bool status;

  LocationModel
  ({
    this.location,
    this.status
  });
}