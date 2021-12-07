import 'package:festivalapp/Model/app_user.dart';
import 'package:festivalapp/services/Api/main_fetcher.dart';

class UserFetcher extends MainFetcher {
  UserFetcher() {
    setUserToken();
  }

  Future<AppUser> whoAmI({String? id, String? email, String? token}) async {
    final response = await post("login",
        body: (id != null && email != null)
            ? {"id": id, "email": email}
            : {"token": token});
    print(response);
    return AppUser.fromJson(response);
  }

  Future<bool> register(
      String id, String name, String firstName, String email) async {
    bool registered = false;
    final response = await post("register",
        body: {"id": id, "name": name, "firstname": firstName, "email": email});
    print(response);
    if (response != null) {
      registered = true;
    }
    return registered;
  }
}
