import 'package:custom_map/service/remote.dart';
import 'package:custom_map/service/utill.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'model/direction_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late GoogleMapController _controller;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  static MapType mode = MapType.hybrid;

  static const CameraPosition _kGooglePlex = CameraPosition(
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
    _controller.dispose();
    super.dispose();
  }

  _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId("origin"),
          infoWindow: const InfoWindow(title: "Origin"),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        //reset dest
        _destination = null;
        //reset info
        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId("destination"),
          infoWindow: const InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
      // get directions
      final directions = await DirectionsRepository().getDirections(
        origin: _origin!.position,
        destinination: pos,
      );
      setState(() => _info = directions);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Custom Map"),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () =>
                  _controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _origin!.position,
                        zoom: 14.5,
                        tilt: 50.0,
                      ),
                    ),
                  ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("ORIGIN"),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () =>
                  _controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _origin!.position,
                        zoom: 14.5,
                        tilt: 50.0,
                      ),
                    ),
                  ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text("DEST"),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: mode,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) => _controller = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
            circles:{
              Circle(circleId: const CircleId("1"),
              center: _origin?.position!=null?_origin!.position:const LatLng(0.0, 0.0),
                radius: 200,
                strokeWidth: 3,
                strokeColor: Colors.black,
                fillColor: Colors.blueAccent.withOpacity(0.2),
              ),
              Circle(circleId: const CircleId("2"),
                center: _destination?.position!=null?_destination!.position:const LatLng(0.0, 0.0),
                radius: 200,
                strokeWidth: 3,
                strokeColor: Colors.black,
                fillColor: Colors.blueAccent.withOpacity(0.2),
              ),
            },
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ]),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
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
            foregroundColor: Colors.black,
            onPressed: () async {
              if (await Permission.location.request().isGranted) {
                setState(() {
                  mode=mode==MapType.hybrid?MapType.normal:MapType.hybrid;
                });
              }
            },
            child: const Icon(
              Icons.mode_of_travel_outlined,
              color: Colors.white,
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
                _controller.animateCamera(_info != null
                    ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
                    :

                CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(Currentposition.latitude,Currentposition.longitude),
                  zoom: 18.1519260406,
                  bearing: 192.8334901395799,
                  tilt: 59.440717697143555,
                )));
                // Either the permission was already granted before or the user just granted it.
              }else {
                //requestPermission();
              }
                },
            child: const Icon(
              Icons.location_on_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


