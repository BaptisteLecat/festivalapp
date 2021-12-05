import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:festivalapp/common/error/api/ApiException.dart';
import 'dart:convert';

import 'package:festivalapp/services/Auth/SharedPreferences.dart';

import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class MainFetcher {
  static String userToken = "noToken";
  String apiUrl = "http://127.0.0.1/api/";

  String _urlBuilder(String subUrl) {
    return "${this.apiUrl}/$subUrl";
  }

  setUserToken() async {
    await SharedPreferencesUser().getToken().then((value) {
      print("test");
      if (value != "") {
        MainFetcher.userToken = value!;
      }
    }).onError((error, stackTrace) {
      throw Exception("Aucun token fournit.");
    });
  }

  Future<dynamic> get(String url, [Map<String, String>? headers]) async {
    print(MainFetcher.userToken);
    var responseJson;
    try {
      print(_urlBuilder(url));
      final response = await http.get(Uri.parse(_urlBuilder(url)),
          headers: headers == null
              ? {
                  "Content-Type": "application/json",
                  "Accept": "application/json",
                  "Authorization": "Bearer ${MainFetcher.userToken}"
                }
              : headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    var responseJson;
    try {
      print(_urlBuilder(url));
      print(headers == null
          ? MainFetcher.userToken != "noToken"
              ? {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded",
                  "Authorization": "Bearer ${MainFetcher.userToken}"
                }
              : {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded",
                }
          : headers);
      final response = await http.post(Uri.parse(_urlBuilder(url)),
          headers: headers == null
              ? MainFetcher.userToken != "noToken"
                  ? {
                      "Accept": "application/json",
                      "Content-Type": "application/x-www-form-urlencoded",
                      "Authorization": "Bearer ${MainFetcher.userToken}"
                    }
                  : {
                      "Accept": "application/json",
                      "Content-Type": "application/x-www-form-urlencoded",
                    }
              : headers,
          body: body,
          encoding: Utf8Codec());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postFile(String url, File imageFile,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    var responseJson;
    try {
      print(_urlBuilder(url));
      var stream = imageFile.readAsBytes().asStream();

      var multipartFile = new http.MultipartFile(
          'files', stream, imageFile.lengthSync(),
          filename: basename(imageFile.path),
          contentType: MediaType('image', 'png'));

      var request = http.MultipartRequest("POST", Uri.parse(_urlBuilder(url)));
      request.files.add(multipartFile);
      request.headers.addAll(headers == null
          ? MainFetcher.userToken != "noToken"
              ? {
                  "Accept": "application/json",
                  "Authorization": "Bearer ${MainFetcher.userToken}"
                }
              : {
                  "Accept": "application/json",
                }
          : headers);
      print(request.headers);
      var response = await request.send();
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    var responseJson;
    try {
      print(_urlBuilder(url));
      final response = await http.patch(Uri.parse(_urlBuilder(url)),
          headers: headers == null
              ? {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded",
                  "Authorization": "Bearer ${MainFetcher.userToken}"
                }
              : headers,
          body: jsonEncode(body),
          encoding: Utf8Codec());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(dynamic response) async {
    var returnedResponse;
    if (response is http.StreamedResponse) {
      http.Response.fromStream(response).then((test) {
        returnedResponse = test;
      });
    } else {
      returnedResponse = jsonDecode(response.body);
    }
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print("success");
        return returnedResponse;
      case 400:
        throw BadRequestException(message: returnedResponse["error"]);
      case 404:
        throw BadRequestException(message: returnedResponse["error"]);
      case 403:
        throw UnauthorisedException(message: returnedResponse["error"]);
      case 500:
      default:
        throw FetchDataException(
            message: "${returnedResponse["error"]} : ${response.statusCode}");
    }
  }
}