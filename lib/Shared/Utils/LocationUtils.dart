
const GOOGLE_API_KEY = 'AIzaSyAoJ39QEBzqpJO8ePwH9xcCrw3jHsl4jJo';

class LocationUtils
{
  static String generateLocationPreviewImage({double latitude, double longitude})
  {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:Z%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  /*static Future<String> getAddressFrom(LatLng position) async
  {
    final url = '';

    final response = await http.get(url);
    return json.decode()['results'][0]['formatted_address'];
  }*/
}