import 'package:festivalapp/Model/app_user.dart';
import 'package:festivalapp/services/Api/main_fetcher.dart';

class UserFetcher extends MainFetcher {
  UserFetcher() {
    setUserToken();
  }

  Future<AppUser> whoAmI({String? email, String? password, String? token}) async {
    final response = await post("auth/login",
        body: (email != null && password != null)
            ? {"email": email, "password": password}
            : {"token": token});
    print(response);
    return AppUser.fromJson(response);
  }

  Future<bool> register(String name, String firstName, String email, String password) async {
    bool registered = false;
    final response = await post("auth/register",
        body: {"name": name, "firstname": firstName, "email": email, "password": password});
    print(response);
    if (response != null) {
      registered = true;
    }
    return registered;
  }
}
