import 'package:festivalapp/Model/AppUser.dart';
import 'package:festivalapp/common/error/AuthException.dart';
import 'package:festivalapp/services/Api/repositories/auth/AuthFetcher.dart';
import 'package:festivalapp/services/Api/repositories/user/UserFetcher.dart';
import 'shared_preferences.dart'';

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
      SharedPreferencesUser().setUserId(appUser.user.id);
      return appUser.user;
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
