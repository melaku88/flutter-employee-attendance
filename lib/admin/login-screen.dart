import 'package:attendance/admin/adminSharedPref/admin_shared.dart';
import 'package:attendance/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  // ========================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;

  bool isPassVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
 
  // ========================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.black54, toolbarHeight: 0.0,),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth,
                  height: screenHight/3.5,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 60.0, color: secondary,),
                      Text('Admin', style: TextStyle(color: secondary),)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHight/15, bottom: screenHight/20),
                  child: Column(
                    children: [
                      Text(
                      'Login',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Container(
                        height: 2.0, width: 25.0, color: Colors.grey.shade400,
                      )
                    ],
                  ),
                ),

                _usernameTextField('Username', _usernameController, Icons.email_outlined),
                _passwordTextField('Password', _passwordController, isPassVisible ? false : true, Icons.key_outlined, isPassVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                _loginButton('LOGIN')
              ],
            ),
          )
        ),
      ),
    );
  }
  // }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

  Widget _usernameTextField(String title,TextEditingController controller, IconData iconPrfix){
    return  Container(
      width: 330.0,
      margin: EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 3.0,),
          CupertinoTextField(
            controller: controller,
            cursorColor: Colors.black54,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            style: TextStyle(color: Colors.black87,fontSize: 14.0, letterSpacing: 1.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(5.0)
            ),
            prefix: Container(
              margin: EdgeInsets.only(left: 5.0),
              child: Icon(iconPrfix, size: 16.0, color: Colors.black45,)
            ),
          ),
        ],
      ),
    );
  }
  Widget _passwordTextField(String title, TextEditingController controller, bool obsecureText, IconData iconPrfix, IconData iconSufix){
    return  Container(
      width: 330.0,
      margin: EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 3.0,),
          CupertinoTextField(
            controller: controller,
            obscureText: obsecureText,
            cursorColor: Colors.black54,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            style: TextStyle(color: Colors.black87,fontSize: 14.0, letterSpacing: 1.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(5.0)
            ),
            prefix: Container(
              margin: EdgeInsets.only(left: 5.0),
              child: Icon(iconPrfix, size: 18.0, color: Colors.black45,)
            ),
            suffix: GestureDetector(
              onTap: () {
                setState(() {
                  isPassVisible = !isPassVisible;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                child: Icon(iconSufix, size: 18.0, color: Colors.black45,)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton(String text){
    return GestureDetector(
      onTap: () async{
        FocusScope.of(context).unfocus();
        String username = _usernameController.text.trim();
        String password = _passwordController.text.trim();
        if(username.isEmpty){
          snackBar('Please enter your username!');
        }else if(password.isEmpty){
          snackBar('Please enter your password!');
        }else{
          QuerySnapshot snap = await FirebaseFirestore.instance.collection('Admins').where('username', isEqualTo: username).get();
          try {
            if(snap.docs[0]['password'] == password){
              await AdminSharedPreferances().saveUsername(username).then((value){
                snackBarSuccess('Login successfully!');
                Future.delayed(Duration(seconds: 4), (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminAuthChecker()));
                });
              });
            }else{
              snackBar('Wrong username or password!');
            }
          } catch (e) {
            String? error;
            if(e.toString() == 'RangeError (index): Invalid value: Valid value range is empty: 0'){
              setState(() {
                error = 'Employee username does not exist!';
              });
            }else{
              setState(() {
                error = 'Something went wrong';
                print(e.toString());
              });
            }
            snackBar(error!);
          }
        }
      },
      child: Container(
        width: 330.0,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Text(text, style: TextStyle(color: secondary, fontWeight: FontWeight.w600),),
      ),
    );
  }

  //========================= Functions
  void snackBar( String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepOrange.shade800,
        content: Center(child: Text(text, style: TextStyle(color: Colors.white),)),
      )
    );
  }
  void snackBarSuccess( String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade800,
        content: Center(child: Text(text, style: TextStyle(color: Colors.white),)),
      )
    );
  }
  
}