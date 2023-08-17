import 'package:dio/dio.dart';
import 'package:monii/constants.dart';

Dio dio({String? token}) {
  Dio dio = Dio();

  dio.options.baseUrl = "${AppConstats.baseUrl}/api";

  dio.options.headers['Accept'] = "Application/json";
  if (token != null) {
    dio.options.headers['Authorization'] = "Bearer $token";
  }

  return dio;
}
