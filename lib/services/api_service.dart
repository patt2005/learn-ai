import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ApiService {
  static ApiService instance = ApiService();

  // final String _appAppleId = "6738118898";

  Future<Map<String, dynamic>> getJsonContent(String jsonName) async {
    // const apiUrl = "http://localhost:5262/api/get-json";
    // final params = {
    //   "appId": _appAppleId,
    //   "jsonName": jsonName,
    // };

    // try {
    //   Dio dio = Dio();

    //   final response = await dio.get(apiUrl, queryParameters: params);

    //   if (response.statusCode == 200) {
    //     return response.data;
    //   } else {
    //     throw Exception('Failed to fetch JSON content: ${response.statusCode}');
    //   }
    // } on DioException catch (e) {
    //   if (e.response != null) {
    //     debugPrint("Error response: ${e.response?.data}");
    //     throw Exception(
    //         "Request failed with status: ${e.response?.statusCode}");
    //   } else {
    //     debugPrint("Error message: ${e.message}");
    //     throw Exception("Request failed: ${e.message}");
    //   }
    // }
    final dataString = await rootBundle.loadString("data/$jsonName.json");
    return jsonDecode(dataString);
  }
}
