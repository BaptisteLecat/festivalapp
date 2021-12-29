import 'dart:io';

import 'package:festivalapp/common/success/api/api_success.dart';
import 'package:http/http.dart' as http;
import 'package:festivalapp/common/error/api/api_exception.dart';
import 'dart:convert';

import 'package:festivalapp/services/Auth/shared_preferences.dart';

import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class MainFetcher {
  static String userToken = "noToken";
  //String apiUrl = "https://10.19.8.120:8000/api";
  String apiUrl = "https://festivapp.alwaysdata.net/api";

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
      print(error);
      throw Exception("Aucun token fournit.");
    });
  }

  dynamic _convertResponsetoJson(http.Response response) {
    final List<dynamic> data;
    if (response.body.contains("hydra:member")) {
      final dynamic map = jsonDecode(response.body.toString());
      data = map["hydra:member"];
      return data.cast<Map<String, dynamic>>();
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> get(
      {required String url,
      Map<String, String>? headers,
      bool? noToken = false,
      bool? toJsonLd}) async {
    print(MainFetcher.userToken);
    var responseJson;
    try {
      print(_urlBuilder(url));
      if (!noToken!) {
        await _setUserToken();
      }
      final response = await http.get(Uri.parse(_urlBuilder(url)),
          headers: headers == null
              ? {
                  "Content-Type": "application/ld+json",
                  "Accept": "application/json",
                  "Authorization": "Bearer ${MainFetcher.userToken}"
                }
              : headers);
      responseJson = _returnResponse(response: response, toJsonLd: toJsonLd);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(
      {required String url,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      bool? noToken = false,
      bool? toJsonLd}) async {
    var responseJson;
    try {
      print(_urlBuilder(url));
      if (!noToken!) {
        await _setUserToken();
      }
      final response = await http.post(Uri.parse(_urlBuilder(url)),
          headers: headers == null
              ? MainFetcher.userToken != "noToken" && !noToken
                  ? {
                      "Accept": "application/ld+json",
                      "Content-Type": "application/x-www-form-urlencoded",
                      "Authorization": "Bearer ${MainFetcher.userToken}"
                    }
                  : {
                      "Accept": "application/ld+json",
                      "Content-Type": "application/x-www-form-urlencoded",
                    }
              : headers,
          body: body,
          encoding: Utf8Codec());
      responseJson = _returnResponse(response: response, toJsonLd: toJsonLd);
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

  Future<dynamic> patch(
      {required String url,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      bool? noToken = false,
      bool? toJsonLd}) async {
    var responseJson;
    try {
      print(_urlBuilder(url));
      if (!noToken!) {
        await _setUserToken();
      }
      final response = await http.patch(Uri.parse(_urlBuilder(url)),
          headers: headers == null
              ? {
                  "Accept": "application/ld+json",
                  "Content-Type": "application/x-www-form-urlencoded",
                  "Authorization": "Bearer ${MainFetcher.userToken}"
                }
              : headers,
          body: jsonEncode(body),
          encoding: Utf8Codec());
      responseJson = _returnResponse(response: response, toJsonLd: toJsonLd);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  Future<ApiSuccess> delete(
      {required String url,
      Map<String, String>? headers,
      bool? toJsonLd}) async {
    ApiSuccess responseJson;
    try {
      await _setUserToken();
      print("delete ${_urlBuilder(url)}");
      final response = await http.delete(Uri.parse(_urlBuilder(url)),
          headers: headers == null
              ? {
                  "Accept": "application/ld+json",
                  "X-AUTH-DEVICE": "${MainFetcher.userToken}"
                }
              : headers);
      responseJson = _returnResponse(response: response, hasNoBody: true);
    } on SocketException {
      throw FetchDataException(message: 'No Internet connection');
    }
    return responseJson;
  }

  ApiSuccess _returnResponse(
      {required http.Response response,
      bool? toJsonLd,
      bool hasNoBody = false}) {
    //Use for Delete, because this method return anything.
    var returnedResponse;
    if (!hasNoBody) {
      returnedResponse = jsonDecode(response.body);
      jsonDecode(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        returnedResponse = ApiSuccess(
            statusCode: response.statusCode,
            content: this._convertResponsetoJson(response));
        print("success");
        if (toJsonLd == null || !toJsonLd) {
          returnedResponse = ApiSuccess(
              statusCode: response.statusCode,
              content: this._convertResponsetoJson(response));
        }
      } else {
        _handlingHttpCode(response, returnedResponse);
      }
    } else {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        returnedResponse = ApiSuccess(statusCode: response.statusCode);
      } else {
        _handlingHttpCode(response, []);
      }
    }
    return returnedResponse;
  }

  void _handlingHttpCode(http.Response response, dynamic returnedResponse) {
    print(response.body);
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(
            message: (returnedResponse["title"] != null)
                ? returnedResponse["title"]
                : returnedResponse["message"]);
      case 401:
        throw UnauthorisedException(
            message: (returnedResponse["title"] != null)
                ? returnedResponse["title"]
                : returnedResponse["message"]);
      case 402:
        throw PaymentRequiredException(
            message: (returnedResponse["title"] != null)
                ? returnedResponse["title"]
                : returnedResponse["message"]);
      case 403:
        throw ForbiddenException(
            message: (returnedResponse["title"] != null)
                ? returnedResponse["title"]
                : returnedResponse["message"]);
      case 404:
        throw NotFoundException(
            message: (returnedResponse["title"] != null)
                ? returnedResponse["title"]
                : returnedResponse["message"]);
      case 409:
        throw ConflictException(
            message: (returnedResponse["title"] != null)
                ? returnedResponse["title"]
                : returnedResponse["message"]);
      case 500:
        throw ServerException(
            message: (returnedResponse["title"] != null)
                ? returnedResponse["title"]
                : returnedResponse["message"]);
      default:
        throw FetchDataException(
            statusCode: response.statusCode,
            message:
                "${(returnedResponse["title"] != null) ? returnedResponse["title"] : returnedResponse["message"]} : ${response.statusCode}");
    }
  }
}
