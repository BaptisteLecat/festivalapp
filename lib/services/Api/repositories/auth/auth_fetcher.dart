import 'package:festivalapp/model/app_user.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class AuthFetcher extends MainFetcher {
  Future<AppUser> whoAmI() async {
    final response = await get(url: "account/whoami");
    print(response.content);
    return AppUser.fromJson(response.content);
  }

  Future<AppUser> login(
      {String? email,
      String? password,
      String? token,
      bool? noToken = false}) async {
    final response = await post(
        url: "auth/login",
        body: (email != null && password != null)
            ? {"email": email, "password": password}
            : {"token": token},
        noToken: noToken);
    print(response);
    return AppUser.fromJson(response.content);
  }

  Future<bool> register(
      {required String name,
      required String firstName,
      required String email,
      required String password,
      bool? noToken = false}) async {
    bool registered = false;
    final response = await post(
        url: "auth/register",
        body: {
          "name": name,
          "firstname": firstName,
          "email": email,
          "password": password
        },
        noToken: noToken);
    print(response);
    if (response.content != null) {
      registered = true;
    }
    return registered;
  }
}
