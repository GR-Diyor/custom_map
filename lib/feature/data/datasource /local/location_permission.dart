import 'package:geolocator/geolocator.dart';
late Position Currentposition;

void requestPermission()async{
  bool serviceEnabled=false;
  LocationPermission permission = LocationPermission.denied;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  Currentposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}