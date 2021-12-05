import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUser {
  ///Key for the userId storage.
  final String _kIdUserPrefs = "idUser";

  ///Key for the stayConnected storage.
  final String _kStayConnectedPrefs = "stayConnected";

  ///Key for the token storage.
  final String _ktokenPrefs = "token";

  /// ------------------------------------------------------------
  /// Method that returns the user id
  /// ------------------------------------------------------------
  Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_kIdUserPrefs) ?? null;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user id
  /// ----------------------------------------------------------
  Future<bool> setUserId(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(_kIdUserPrefs, id);
  }

  /// ------------------------------------------------------------
  /// Method that returns the stayConnected value
  /// ------------------------------------------------------------
  Future<bool?> getStayConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_kStayConnectedPrefs) ?? null;
  }

  /// ----------------------------------------------------------
  /// Method that saves the stayConnected value
  /// ----------------------------------------------------------
  Future<bool> setStayConnected(bool stayConnected) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_kStayConnectedPrefs, stayConnected);
  }

  /// ------------------------------------------------------------
  /// Method that returns the token
  /// ------------------------------------------------------------
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_ktokenPrefs) ?? null;
  }

  /// ----------------------------------------------------------
  /// Method that saves the token
  /// ----------------------------------------------------------
  Future<bool> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_ktokenPrefs, token);
  }

    Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
