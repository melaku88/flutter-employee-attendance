import 'package:attendance/users/homescreen.dart';
import 'package:attendance/users/services/shared_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ==========================================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Color.fromARGB(255, 242, 121, 121);
  bool isPassVisible = false;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ============================================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 242, 121, 121), toolbarHeight: 0.0,),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHight/3,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.0),
                  )
                ),
                child: Center(
                  child: Icon(Icons.person, size: screenWidth/5),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHight/15, bottom: screenHight/20),
                child: Column(
                  children: [
                    Text(
                     'LOGIN',
                      style: TextStyle(fontSize: screenWidth/20, fontWeight: FontWeight.w700,),
                    ),
                    Container(
                      height: 2.0, width: 30.0, color: Colors.grey.shade400,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth/12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('Employee ID', style: TextStyle(fontSize: screenWidth/28, fontWeight: FontWeight.w500),),
                    SizedBox(height: 4.0,),
                    CupertinoTextField(
                      controller: _idController,
                      padding: EdgeInsets.all(8),
                      autocorrect: false,
                      style: TextStyle(color: Colors.black87, fontSize: screenWidth/28),
                      placeholder: 'Employee Id',
                      placeholderStyle: TextStyle(color: Colors.black26, fontSize: screenWidth/28),
                      prefix: Container(
                        margin: EdgeInsets.only(left: 7.0), 
                        child: Icon(Icons.person, color: primary, size: 18,)
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.black38,)
                      ),
                    ),
        
                    SizedBox(height: screenHight/30,),
                    Text('Password', style: TextStyle(fontSize: screenWidth/28, fontWeight: FontWeight.w500),),
                    SizedBox(height: 4.0,),
                    CupertinoTextField(
                      controller: _passwordController,
                      padding: EdgeInsets.all(8),
                      obscureText: isPassVisible ? false : true,
                      style: TextStyle(color: Colors.black87, fontSize: screenWidth/28),
                      placeholder: 'Password',
                      placeholderStyle: TextStyle(color: Colors.black26, fontSize: screenWidth/28),
                      prefix: Container(
                        margin: EdgeInsets.only(left: 7.0), 
                        child: Icon(Icons.key, color: primary, size: 18.0,)
                      ),
                      suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPassVisible = !isPassVisible;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 7.0, right: 7.0), 
                          child:isPassVisible ? Icon( Icons.visibility_off_outlined, color: primary, size: 16.0,) : Icon(Icons.visibility_outlined, color: primary, size: 16.0,)
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.black38,)
                      ),
                    ),
        
                    SizedBox(height: screenHight/30,),
                    GestureDetector(
                      onTap: () async{
                        FocusScope.of(context).unfocus();
                        String employeeID = _idController.text.trim();
                        String employeePassword = _passwordController.text.trim();

                        if(employeeID.isEmpty){
                         snackBar('Employee id is still empty!');
                        }else if(employeePassword.isEmpty){
                         snackBar('Employee password is still empty!');
                        }else{
                          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Employees').where('id', isEqualTo: employeeID).get();

                          try {
                            if(employeePassword == snapshot.docs[0]['password']){
                              await SharedPreferenceHelper().saveEmployeeID(employeeID).then((_){
                                snackBarSuccess('Login Successfully!');
                                Future.delayed(const Duration(milliseconds: 4000), () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                                });
                              });
                            }else{
                              print('Try Again');
                            }
                          } catch (e) {
                            String error = '';
                            if(e.toString() == 'RangeError (index): Invalid value: Valid value range is empty: 0'){
                              setState(() {
                                error = 'Employee id does not exist!';
                              });
                            }else{
                              setState(() {
                                error = e.toString();
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Center(child: Text(error, style: TextStyle(color: primary),),)
                            ));
                              print(e.toString());
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: screenWidth,
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: screenWidth/23, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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