import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  static String employeeID = 'EMPLOYEEID';

  // save employee id
  Future<bool> saveEmployeeID(String id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(employeeID, id);
  }

  // get employee id
  Future<String?> getEmployeeID()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(employeeID);
  }
}