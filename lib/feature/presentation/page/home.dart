import 'package:custom_map/core/config/app_dimension.dart';
import 'package:custom_map/feature/presentation/cubit/home_cubit.dart';
import 'package:custom_map/feature/presentation/cubit/home_state.dart';
import 'package:custom_map/feature/presentation/widget/errors.dart';
import 'package:custom_map/feature/presentation/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/config/appColor.dart';
import '../widget/floating_button.dart';
import '../widget/home_widget.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeCubit homeCubit;




  @override
  void initState() {
    homeCubit = BlocProvider.of(context);
    homeCubit.requestPermission();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    homeCubit.controller?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeState>(
      builder: (context,state) {

        if(state is HomeLoading){
          return const Loading();
        }
        if(state is HomeError){
          return Errors(error: state.error);
        }

        return Scaffold(
          appBar: homeAppBar(controller: homeCubit.controller, origin: homeCubit.origin, destination: homeCubit.destination, info: homeCubit.info),
          body: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                mapType: homeCubit.mode,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: homeCubit.kGooglePlex,
                onMapCreated: (controllers) => homeCubit.controller = controllers,
                markers: {
                  if (homeCubit.origin != null) homeCubit.origin!,
                  if (homeCubit.destination != null) homeCubit.destination!,
                },
                polylines: {
                  if (homeCubit.info != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: AppColor.redDark,
                      width: 5,
                      points: homeCubit.info!.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
                onLongPress: homeCubit.addMarker,
                circles:{
                  Circle(circleId: const CircleId("1"),
                  center: homeCubit.origin?.position!=null?homeCubit.origin!.position:const LatLng(0.0, 0.0),
                    radius: 100,
                    strokeWidth: 3,
                    strokeColor: AppColor.black,
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                  ),
                  Circle(circleId: const CircleId("2"),
                    center: homeCubit.destination?.position!=null?homeCubit.destination!.position:const LatLng(0.0, 0.0),
                    radius: 100,
                    strokeWidth: 3,
                    strokeColor: AppColor.black,
                    fillColor: AppColor.blue.withOpacity(0.2),
                  ),
                },
              ),
              if (homeCubit.info != null)
                Positioned(
                  top: 2.h,
                  child: Container(
                    padding:  EdgeInsets.symmetric(
                      vertical: 0.6.h,
                      horizontal: 1.2.h,
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
                      '${homeCubit.info!.totalDistance}, ${homeCubit.info!.totalDuration}',
                      style: TextStyle(
                          fontSize: AppDimension.textSize(context).bodyLarge!.fontSize, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingButton(icon: Icons.remove, onPressed: homeCubit.zoomOut),
              SizedBox(
                height: 1.h,
              ),
              FloatingButton(icon:Icons.add, onPressed: homeCubit.zoomIn),
              SizedBox(
                height: 4.0.h,
              ),
              FloatingButton(iSprimaryButton:true,icon: Icons.repeat_outlined, onPressed: homeCubit.replaceMode),
              SizedBox(
                height: 1.h,
              ),
              FloatingButton(
                iSprimaryButton: true,
                icon: Icons.location_on_outlined,
                onPressed: homeCubit.currentLoaction,
              ),
            ],
          ),
        );
      }
    );
  }
}


