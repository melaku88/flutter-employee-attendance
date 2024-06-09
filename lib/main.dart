import 'package:attendance/admin/adminSharedPref/admin_shared.dart';
import 'package:attendance/admin/home_screen.dart';
import 'package:attendance/admin/login-screen.dart';
import 'package:attendance/admin/models/admin_model.dart';
import 'package:attendance/firebase_options.dart';
import 'package:attendance/users/homescreen.dart';
import 'package:attendance/users/loginscreen.dart';
import 'package:attendance/users/models/usermodel.dart';
import 'package:attendance/users/services/shared_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 242, 121, 121)),
        useMaterial3: true,
        textTheme: GoogleFonts.shareTechMonoTextTheme(),
      ),
      home: AdminAuthChecker(),
      localizationsDelegates: [
        MonthYearPickerLocalizations.delegate
      ],
    );
  }
}


class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  // =========================================================================================
  String? employeeID;

  getCurrentUser()async{
    employeeID = await SharedPreferenceHelper().getEmployeeID();
    UserModel.employeeId = employeeID!;
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  // =========================================================================================
  @override
  Widget build(BuildContext context) {
    return employeeID != null ? HomeScreen() : LoginScreen();
  }
}



class AdminAuthChecker extends StatefulWidget {
  const AdminAuthChecker({super.key});

  @override
  State<AdminAuthChecker> createState() => _AdminAuthCheckerState();
}

class _AdminAuthCheckerState extends State<AdminAuthChecker> {
  // ===========================================================================
  String? adminUsername;
  @override
  void initState() {
    super.initState();
    _getAdminUsername();
  }
  _getAdminUsername()async{
    adminUsername = await AdminSharedPreferances().getUsername();
    setState(() {
      AdminModel.adminUsername = adminUsername!;
    });
  }
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    if(AdminModel.adminUsername != null){
      return AdminHome();
    }else{
      return AdminLogin();
    }
  }
}