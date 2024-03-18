import 'package:custom_map/service/remote.dart';
import 'package:custom_map/service/utill.dart';
import 'package:custom_map/widget/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'config/appColor.dart';
import 'model/direction_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   GoogleMapController? controller;
  Marker? origin;
  Marker? destination;
  Directions? info;

  MapType mode = MapType.hybrid;

  static CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(40.441078, 071.716952),
    zoom: 18.1519260406,
    bearing: 192.8334901395799,
    tilt: 59.440717697143555,
  );

  @override
  void initState() {
    requestPermission();

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }


  _addMarker(LatLng pos) async {
    if (origin == null || (origin != null && destination != null)) {
      setState(() {
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
      });
    } else {
      setState(() {
        destination = Marker(
          markerId: const MarkerId("destination"),
          infoWindow: const InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
      // get directions
      final directions = await DirectionsRepository().getDirections(
        origin: origin!.position,
        destinination: pos,
      );
      setState(() => info = directions);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(controller: controller, origin: origin, destination: destination, info: info),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: mode,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: kGooglePlex,
            onMapCreated: (controllers) => controller = controllers,
            markers: {
              if (origin != null) origin!,
              if (destination != null) destination!,
            },
            polylines: {
              if (info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: AppColor.redDark,
                  width: 5,
                  points: info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
            circles:{
              Circle(circleId: const CircleId("1"),
              center: origin?.position!=null?origin!.position:const LatLng(0.0, 0.0),
                radius: 200,
                strokeWidth: 3,
                strokeColor: AppColor.black,
                fillColor: Colors.blueAccent.withOpacity(0.2),
              ),
              Circle(circleId: const CircleId("2"),
                center: destination?.position!=null?destination!.position:const LatLng(0.0, 0.0),
                radius: 200,
                strokeWidth: 3,
                strokeColor: AppColor.black,
                fillColor: AppColor.blueLight.withOpacity(0.2),
              ),
            },
          ),
          if (info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                    color: AppColor.yellowLight,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ]),
                child: Text(
                  '${info!.totalDistance}, ${info!.totalDuration}',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
              ),
            )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            foregroundColor: AppColor.black,
            onPressed: () async {
              if (await Permission.location.request().isGranted) {
                setState(() {
                  mode=mode==MapType.hybrid?MapType.normal:MapType.hybrid;
                });
              }
            },
            child:  Icon(
              Icons.mode_of_travel_outlined,
              color: AppColor.white,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.005+10,
          ),
          FloatingActionButton(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            foregroundColor: Colors.black,
            onPressed: () async {
              if (await Permission.location.request().isGranted) {
                controller?.animateCamera(info != null
                    ? CameraUpdate.newLatLngBounds(info!.bounds, 100.0)
                    :
                CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(Currentposition.latitude,Currentposition.longitude),
                  zoom: 18.1519260406,
                  bearing: 192.8334901395799,
                  tilt: 59.440717697143555,
                )));
                // Either the permission was already granted before or the user just granted it.
              }else {
                requestPermission();
              }
                },
            child:  Icon(
              Icons.location_on_outlined,
              color: AppColor.white,
            ),
          ),
        ],
      ),
    );
  }
}


