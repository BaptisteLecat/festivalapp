import 'package:festivalapp/model/app_user.dart';
import 'package:festivalapp/services/api/repositories/auth/auth_fetcher.dart';
import 'package:festivalapp/services/api/repositories/user/user_fetcher.dart';
import 'shared_preferences.dart';

class AuthenticationService {
  Future<AppUser?> getCurrentUser() async {
    dynamic user;
    await SharedPreferencesUser().setToken("noToken");
          return await SharedPreferencesUser().getToken().then((token) async {
            if (token != null) {
              print(token);
              await UserFetcher().whoAmI(token: token).then((appUser) {
                user = appUser;
              }).onError((error, stackTrace) {
                return null;
              });
              return user;
            } else {
              return null;
            }
    });
  }

  Future signInWithEmailAndPassword(String identifier, String password) async {
    try {
      AppUser? appUser = await AuthFetcher()
          .whoAmI(identifier: identifier, password: password);
      SharedPreferencesUser().setToken(appUser.jwt);
      SharedPreferencesUser().setUserId(appUser.id);
      return appUser;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future registerInWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      bool success = await AuthFetcher().register(userName, email, password);
      return success;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }
}
