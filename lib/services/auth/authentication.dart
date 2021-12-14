import 'package:festivalapp/model/app_user.dart';
import 'package:festivalapp/services/api/repositories/auth/auth_fetcher.dart';
import 'package:festivalapp/services/api/repositories/user/user_fetcher.dart';
import 'shared_preferences.dart';

class AuthenticationService {
  Future<AppUser?> getCurrentUser() async {
    dynamic user;
    return await SharedPreferencesUser().getToken().then((token) async {
      if (token != null) {
        print(token);
        await AuthFetcher().whoAmI(token: token).then((appUser) {
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

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    AppUser? appUser = await AuthFetcher()
        .whoAmI(email: email, password: password, noToken: true);
    print("token: ${appUser.jwt}");
    await SharedPreferencesUser().setToken(appUser.jwt);
    return appUser;
  }

  Future registerInWithEmailAndPassword(
      String name, String firstname, String email, String password) async {
    return await AuthFetcher().register(
        name: name,
        firstName: firstname,
        email: email,
        password: password,
        noToken: true);
  }
}
