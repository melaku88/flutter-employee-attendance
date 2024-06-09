import 'package:attendance/admin/home_screen.dart';
import 'package:attendance/admin/models/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  // ========================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;

  String _birthDate = ' ';
  String _employeeID = '';
  String _branch = '';
  double salery = 0;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _saleryController = TextEditingController();

    @override
  void initState() {
    super.initState();
    _getEmployeeID();
  }

  _getEmployeeID(){
    setState(() {
      _employeeID = AdminModel.employeeID!;
      _branch = AdminModel.adminUsername!;
    });
  }
 
  // ========================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, toolbarHeight: 0.0,),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined, size: 20.0, color: primary,)
                    ),
                    SizedBox(width: 40.0,),
                    Text(
                      'Add New Employee',
                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),
                _employeeIdField('Employee Id', _employeeID),
                _textField('First Name', _firstNameController),
                _textField('Last Name', _lastNameController),
                _birthdateField('Birth Date'),
                _textField('Address', _addressController),
                _textField('Salery', _saleryController),
                _employeeIdField('Branch', _branch),
                _registerButton('Add Employee')

              ],
            ),
          )
        ),
      ),
    );
  }
  // }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

  Widget _textField(String title, TextEditingController controller){
    return  Container(
      width: 330.0,
      margin: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 3.0,),
          CupertinoTextField(
            controller: controller,
            cursorColor: Colors.black54,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            style: TextStyle(color: Colors.lightBlue,fontSize: 13.0, letterSpacing: 1.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(5.0)
            ),
          ),
        ],
      ),
    );
  }

  Widget _employeeIdField(String title, String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 3.0,),
        GestureDetector(
          child: Container(
            width: 330.0,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 15.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Text(value, style: TextStyle(color: Colors.lightBlue, fontSize: 13.0,),),
          ),
        ),
      ],
    );
  }


  Widget _birthdateField(String title){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 3.0,),
        GestureDetector(
          onTap: () async{
            await showDatePicker(
              context: context, 
              initialDate: DateTime.now(),
              firstDate: DateTime(1950), 
              lastDate: DateTime.now(),
            ).then((value){
              setState(() {
                _birthDate = DateFormat('dd MMMM yyyy').format(value!);
              });
            });
          },
          child: Container(
            width: 330.0,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 15.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_birthDate, style: TextStyle(color: Colors.lightBlue, fontSize: 13.0),),
                Icon(Icons.arrow_drop_down, size: 20.0, color: Colors.lightBlue,)
              ],
            ),
          ),
        ),
      ],
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

  Widget _registerButton(String text){
    return GestureDetector(
      onTap: () async{
        FocusScope.of(context).unfocus();
        String employeeId = _employeeID;
        String firstName = _firstNameController.text.trim();
        String lastName = _lastNameController.text.trim();
        String birthDate = _birthDate;
        String address = _addressController.text.trim();
        String branch = _branch;
        salery = _saleryController.text.isNotEmpty ? double.parse(_saleryController.text.trim()): 0;

        if(employeeId.isEmpty){
          snackBar('Please enter employee id!');
        }else if(firstName.isEmpty){
          snackBar('Please enter employee first name!');
        }else if(lastName.isEmpty){
          snackBar('Please enter employee last name!');
        }else if(birthDate.isEmpty){
          snackBar('Please enter employee birth date!');
        }else if(address.isEmpty){
          snackBar('Please enter employee address!');
        }else if(branch.isEmpty){
          snackBar('Please enter employee working branch!');
        }else if(salery == 0){
          snackBar('Please enter salery');
        } else{
          try {
            await FirebaseFirestore.instance
            .collection('Admins')
            .doc(AdminModel.adminID)
            .collection('${AdminModel.adminUsername!} branch employees')
            .doc(employeeId).set({
              'EmployeeID': employeeId,
              'firstName': firstName,
              'lastName': lastName,
              'birthDate': birthDate,
              'address': address,
              'salery': salery,
              'branch': branch,
              'timestamp': Timestamp.now(),
              'searchKey': firstName.substring(0,1).toLowerCase(),
            });
            await FirebaseFirestore.instance
              .collection('Admins')
              .doc(AdminModel.adminID)
              .update({
                'lastEmployeeId': employeeId,
              });

            snackBarSuccess('Employee added successfully!');

            Future.delayed(Duration(seconds: 4), (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
            });
          } catch (e) {
            print(e.toString());
            snackBar(e.toString());
          }
        } 
      },
      child: Container(
        width: 200.0,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 15.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Text(text, style: TextStyle(color: secondary, fontWeight: FontWeight.w600),),
      ),
    );
  }
  
}