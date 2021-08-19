import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'lang': 'en'
        }));
  }

  static Future<Response> getData(
      {required String url,
       Map<String, dynamic>? query,
      String? token}) async {
    dio.options.headers['Authorization'] = token??'';

    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers['Authorization'] = token??'';

  

    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers['Authorization'] = token??'';

  

    return dio.put(url, queryParameters: query, data: data);
  }
}
