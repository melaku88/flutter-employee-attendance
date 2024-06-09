import 'dart:io';

import 'package:attendance/users/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // =========================================================================================
  double screenHight = 0;
  double screenWidth = 0;
  Color primary = Color.fromARGB(255, 242, 121, 121);
  String _birth = ' ';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

void uploadProfilePic() async{

  final image = await ImagePicker().pickImage(source: ImageSource.gallery,
    // maxHeight: 512,
    // maxWidth: 512,
    // imageQuality: 90
  );
   
   Reference ref = await FirebaseStorage.instance.ref().child('${UserModel.employeeId.toLowerCase()}_profilepic.jpg');

   await ref.putFile(File(image!.path));

   ref.getDownloadURL().then((value){
    setState(() {
      UserModel.profilePicLink = value;
    });
    FirebaseFirestore.instance.collection('Employees').doc(UserModel.id).update({
     'profilePic': UserModel.profilePicLink,
   });
   });
}
  // =========================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: SafeArea(
          child: Container(
            width: screenWidth,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    uploadProfilePic();
                  },
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    margin: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: UserModel.profilePicLink == '' ? Icon(Icons.person, size: 40.0,) 
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(UserModel.profilePicLink,width: 80.0, height: 80.0, fit: BoxFit.fill, )
                    ),
                  ),
                ),
                Text('Employee '+UserModel.employeeId),

                SizedBox(height: 30.0,),

                _textFields('First Name', _firstNameController),
                _textFields('Last Name', _lastNameController),
                _birthDate('Birth Date'),
                _textFields('Address', _addressController),
                _button()
              ],
            ),
          )
        ),
      )
    );
  }

  Widget _textFields(String title, TextEditingController controller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 3.0,),
        CupertinoTextField(
          controller: controller,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          style: TextStyle(color: Colors.black45,fontSize: 14.0, letterSpacing: 1.0),
          cursorColor: Colors.black54,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(5.0)
          ),
        ),
        SizedBox(height: 12.0,),
      ],
    );
  }

  Widget _birthDate(String title){
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
                _birth = DateFormat('dd MMMM yyyy').format(value!);
              });
            });
          },
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 15.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_birth, style: TextStyle(color: Colors.black45, fontSize: 14.0),),
                Icon(Icons.arrow_drop_down_circle_outlined, size: 20.0, color: Colors.black38,)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _button(){
    return GestureDetector(
      onTap: () async{
        String firstName = _firstNameController.text.trim();
        String lastName = _lastNameController.text.trim();
        String address = _addressController.text.trim();
        String birthDate = _birth;
        if(UserModel.canEdit){
          if(firstName.isEmpty){
            showSnackBar('Please enter your first name!');
          }else if(lastName.isEmpty){
            showSnackBar('Please enter your last name!');
          }else if(address.isEmpty){
            showSnackBar('Please enter your address!');
          }else if(birthDate == ' '){
            showSnackBar('Please enter your birth date!');
          }else{
            await FirebaseFirestore.instance.collection('Employees').doc(UserModel.id).update({
              'firstName': firstName,
              'lastName': lastName,
              'birthDate': birthDate,
              'address': address,
              'canEdit': false,
            });
          }
        }else{
          showSnackBar('You can\t edit anymore, Please contact support team.');
        }
      },
      child: Container(
        width: 150,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        margin: EdgeInsets.only(top: 15.0),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 15.0),),
      ),
    );
  }

  void showSnackBar(String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Center(child: Text(text)),
      )
    );
  }
}