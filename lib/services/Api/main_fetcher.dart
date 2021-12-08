import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:festivalapp/common/error/api/api_exception.dart';
import 'dart:convert';

import 'package:festivalapp/services/Auth/shared_preferences.dart';

import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class MainFetcher {
  static String userToken = "noToken";
  String apiUrl = "https://10.0.3.148:8000/api";

  String _urlBuilder(String subUrl) {
    return "${this.apiUrl}/$subUrl";
  }

  _setUserToken() async {
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
      await _setUserToken();
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
      await _setUserToken();
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

  /*Future<dynamic> postFile(String url, File imageFile,
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
  }*/

  Future<dynamic> patch(String url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    var responseJson;
    try {
      print(_urlBuilder(url));
      await _setUserToken();
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

  dynamic _returnResponse(http.Response response) async {
    var returnedResponse = jsonDecode(response.body);
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print("success");
        return returnedResponse;
      case 400:
        throw BadRequestException(message: returnedResponse["message"]);
      case 404:
        throw BadRequestException(message: returnedResponse["message"]);
      case 403:
        throw UnauthorisedException(message: returnedResponse["message"]);
      case 500:
      default:
        throw FetchDataException(
            message: "${returnedResponse["message"]} : ${response.statusCode}");
    }
  }
}
