import 'package:festivalapp/model/app_user.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class AuthFetcher extends MainFetcher {
  Future<AppUser> whoAmI(
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
    return AppUser.fromJson(response);
  }

  Future<bool> register(
      String name, String firstName, String email, String password) async {
    bool registered = false;
    final response = await post(
        url: "auth/register",
        body: {
          "name": name,
          "firstname": firstName,
          "email": email,
          "password": password
        },
        noToken: true);
    print(response);
    if (response != null) {
      registered = true;
    }
    return registered;
  }
}
