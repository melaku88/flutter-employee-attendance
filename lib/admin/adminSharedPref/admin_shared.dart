import 'package:shared_preferences/shared_preferences.dart';

class AdminSharedPreferances{
  static String usernameKey = 'USERNAMEKEY';

  Future<bool> saveUsername(String username)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(usernameKey, username);
  }

  Future<String?> getUsername()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(usernameKey);
  }

  Future<bool?> deleteUsername()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(usernameKey);
  }
}