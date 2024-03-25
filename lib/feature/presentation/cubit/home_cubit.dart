import 'package:custom_map/feature/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/datasource/remote/remote.dart';
import '../../data/model/direction_model.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit():super(HomeInit());

  late Position currentposition;
  GoogleMapController? controller;
  Marker? origin;
  Marker? destination;
  Directions? info;
  MapType mode = MapType.hybrid;

   CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(40.441078, 071.716952),
    zoom: 17.1519260406,
    bearing: 192.8334901395799,
    tilt: 59.440717697143555,
  );

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
    currentposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }



  void currentLoaction()async{
    if (await Permission.location.request().isGranted) {
      controller?.animateCamera(info != null
          ? CameraUpdate.newLatLngBounds(info!.bounds, 100.0)
          :
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentposition.latitude,currentposition.longitude),
        zoom: 17.1519260406,
        bearing: 192.8334901395799,
        tilt: 59.440717697143555,
      )));
    }else {
      requestPermission();
    }
  }

  void addMarker(LatLng pos) async {
    if (origin == null || (origin != null && destination != null)) {
      emit(HomeLoading());
        origin = Marker(
          markerId: const MarkerId("origin"),
          infoWindow: const InfoWindow(title: "Origin"),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        //reset dest
        destination = null;
        //reset info
        info = null;
        emit(HomeLoaded());
    } else {
      emit(HomeLoading());
        destination = Marker(
          markerId: const MarkerId("destination"),
          infoWindow: const InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      emit(HomeLoaded());
      // get directions
      final directions = await DirectionsRepository().getDirections(
        origin: origin!.position,
        destinination: pos,
      );
       info = directions;
    }
  }

  Future<void> replaceMode() async {
    emit(HomeLoading());
        mode=mode==MapType.hybrid?MapType.normal:MapType.hybrid;
        emit(HomeLoaded());
  }
  Future<void> zoomIn() async {
    if (await Permission.location.request().isGranted) {
      controller?.animateCamera(
        CameraUpdate.zoomBy(0.5),
      );
    }
  }
  Future<void> zoomOut() async {
    if (await Permission.location.request().isGranted) {
      controller?.animateCamera(
        CameraUpdate.zoomBy(-0.5),
      );
    }
  }
}