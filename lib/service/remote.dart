import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/direction_model.dart';
import '.env.dart';

class DirectionsRepository{

  DirectionsRepository(){
  dio = Dio();
  dio
  ..options.baseUrl = _baseUrl
  ..options.connectTimeout = const Duration(seconds: 30000)
  ..options.receiveTimeout = const Duration(seconds: 30000)
  ..httpClientAdapter
  ..options.headers ={'Content-type': 'application/json; charset=UTF-8'};
}
  static const String _baseUrl =
  'https://maps.googleapis.com/maps/api/directions/json?';
  late  Dio dio;

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destinination,
  }) async{
    final response = await dio.get(
        _baseUrl,
        queryParameters: {
          'origin':'${origin.latitude},${origin.longitude}',
          'destination':'${destinination.latitude},${destinination.longitude}',
          'key':googleApiKey,
        }
    );
    print(response.data);
    ///Check if response is successfull
    if(response.statusCode==200){
      return Directions.fromMap(response.data);
    }
    return null;
  }
}