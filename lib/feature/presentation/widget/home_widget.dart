import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/config/appColor.dart';
import '../../data/model/direction_model.dart';



AppBar homeAppBar({ required GoogleMapController? controller,
 Marker? origin,
 Marker? destination,
 Directions? info})=>AppBar(
  centerTitle: true,
  title:  Text("Custom Map",style: TextStyle(color: AppColor.white),),
  backgroundColor: AppColor.blue,
  actions: [
    if (origin != null)
      TextButton(
        onPressed: () =>
            controller?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: origin.position,
                  zoom: 14.5,
                  tilt: 50.0,
                ),
              ),
            ),
        style: TextButton.styleFrom(
          foregroundColor: AppColor.greenDark, textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        child: const Text("ORIGIN"),
      ),
    if (destination != null)
      TextButton(
        onPressed: () =>
            controller?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: destination.position,
                  zoom: 14.5,
                  tilt: 50.0,
                ),
              ),
            ),
        style: TextButton.styleFrom(
          foregroundColor: AppColor.greenDark, textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        child: const Text("DEST"),
      ),
  ],
);
