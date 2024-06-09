import 'package:attendance/admin/home_screen.dart';
import 'package:attendance/admin/models/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AdminProfileScreen extends StatefulWidget {
  final String employeeID;
  final String firstName;
  final String lastName;
  const AdminProfileScreen({
    super.key,
     required this.employeeID, required this.firstName, required this.lastName
    });

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  // ============================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;

  String _employeeID = '';
  String _firstName = ' ';
  String _lastName = ' ';
  String _birthDate = ' ';
  String _address = '';
  double salery = 0;
  String _branch = '';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _saleryController = TextEditingController();

  getEmployeeInfo()async{
    DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('Admins')
      .doc(AdminModel.adminID)
      .collection('${AdminModel.adminUsername} branch employees')
      .doc(widget.employeeID)
      .get();
      setState(() {
        _employeeID = snap['EmployeeID'];
        _firstName = snap['firstName'];
        _lastName = snap['lastName'];
        _birthDate = snap['birthDate'];
        _address = snap['address'];
        salery = snap['salery'];
        _branch = snap['branch'];

      });
  }
  @override
  void initState() {
    super.initState();
    getEmployeeInfo();
  }
  // ============================================================================================
  @override
  Widget build(BuildContext context) {
    screenHight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 15.0),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: 130.0,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0)
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: secondary, size: 52.0,),
                    Text(widget.firstName + ' '+widget.lastName, style: TextStyle(color: Colors.white60),)
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
            _employeeIdField('Employee Id', _employeeID),
            _textField('First Name', _firstNameController, _firstName),
            _textField('Last Name', _lastNameController, _lastName),
            _birthdateField('Birth Date'),
            _textField('Address', _addressController, _address),
            _textField('Salery', _saleryController, salery.toString()),
            _employeeIdField('Branch', _branch),
            _updateButton('Update Employee', 'Delete Employee')

            ],
          )
        ),
      )
    );
  }

  Widget _textField(String title, TextEditingController controller, String placeHolder){
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
            placeholder: placeHolder,
            placeholderStyle: TextStyle(color: Colors.lightBlue,fontSize: 13.0, letterSpacing: 1.0),
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
            child: Text(value, style: TextStyle(color: Colors.green.shade700, fontSize: 13.0,),),
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
  Widget _updateButton(String text1, String text2){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async{
            FocusScope.of(context).unfocus();
            String employeeId = _employeeID;
            String firstName = _firstNameController.text.trim().isNotEmpty ? _firstNameController.text.trim() : _firstName;
            String lastName = _lastNameController.text.trim().isNotEmpty ? _lastNameController.text.trim() : _lastName;
            String birthDate = _birthDate;
            String address = _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : _address;
            String branch = _branch;
            salery = _saleryController.text.isNotEmpty ? double.parse(_saleryController.text.trim()): salery;
        
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
                .collection('${AdminModel.adminUsername} branch employees')
                .doc(employeeId).update({
                  'EmployeeID': employeeId,
                  'firstName': firstName,
                  'lastName': lastName,
                  'birthDate': birthDate,
                  'address': address,
                  'salery': salery,
                  'branch': branch,
                });
                await FirebaseFirestore.instance
                  .collection('Admins')
                  .doc(AdminModel.adminID)
                  .update({
                    'lastEmployeeId': employeeId,
                  });
        
                snackBarSuccess('Employee Updated successfully!');
        
                Future.delayed(Duration(seconds: 4), (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
                });
              } catch (e) {
                snackBar(e.toString());
              }
            } 
          },
          child: Container(
            width: 150.0,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Text(text1, style: TextStyle(color: secondary, fontWeight: FontWeight.w600),),
          ),
        ),
        SizedBox(width: 10.0,),
        GestureDetector(
          onTap: () async{
            showDialog(
              context: context, 
              builder: (context) =>AlertDialog(
                content: Text('do you want to delete ${_firstName} ${_lastName} ?'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async{
                            try {
                            await FirebaseFirestore.instance
                            .collection('Admins')
                            .doc(AdminModel.adminID)
                            .collection('${AdminModel.adminUsername} branch employees')
                            .doc(_employeeID)
                            .delete();
                       
                          snackBarSuccess('The Employee deleted successfully!');

                          Future.delayed(Duration(seconds: 2), (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
                          });
                          } catch (e) {
                            snackBar(e.toString());
                          }
                        },
                        child: Text('Yes')
                      ),
                      SizedBox(width: 30.0,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('No')
                      ),
                    ],
                  )
                ],
              )
            );
          },
          child: Container(
            width: 150.0,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Text(text2, style: TextStyle(color: secondary, fontWeight: FontWeight.w600),),
          ),
        ),
      ],
    );
  }

}