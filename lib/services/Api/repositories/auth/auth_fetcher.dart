import 'package:festivalapp/Model/AppUser.dart';
import 'package:festivalapp/services/Api/main_fetcher.dart';

class AuthFetcher extends MainFetcher {

  Future<AppUser> whoAmI({String? identifier, String? password, String? token}) async {
          print(identifier);
    print(password);
    print((identifier != null && password != null)
            ? {"identifier": identifier, "password": password}
            : {"token": token});
    final response = await this.post("auth/local",
        body: (identifier != null && password != null)
            ? {"identifier": identifier, "password": password}
            : {"token": token});
    print(response);
    return AppUser.fromJson(response);
  }

  Future<bool> register(String userName, String email, String password) async {
    bool registered = false;
    final response = await this.post("auth/local/register",
        body: {"username": userName, "email": email, "password": password});
    print(response);
    AppUser appUser = AppUser.fromJson(response);
    if (appUser.jwt != null) {
      registered = true;
    }
    return registered;
  }
}
