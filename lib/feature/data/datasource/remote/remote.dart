import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/config/appString.dart';
import '../../model/direction_model.dart';


class DirectionsRepository{

  DirectionsRepository(){
  dio = Dio();
  dio
  ..options.baseUrl =  AppString.base
  ..options.connectTimeout = const Duration(seconds: 30000)
  ..options.receiveTimeout = const Duration(seconds: 30000)
  ..httpClientAdapter
  ..options.headers =AppString.header;
}
  late  Dio dio;
  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destinination,
  }) async{
    final response = await dio.get(
        AppString.base+AppString.directionsApi,
        queryParameters: {
          'origin':'${origin.latitude},${origin.longitude}',
          'destination':'${destinination.latitude},${destinination.longitude}',
          'key':AppString.googleApiKey,
        }
    );
    if(response.statusCode==200){
      return Directions.fromMap(response.data);
    }
    return null;
  }
}