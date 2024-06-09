import 'package:attendance/admin/home_screen.dart';
import 'package:attendance/admin/models/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AdminTodayScreen extends StatefulWidget {
  final String employeeID;
  final String firstName;
  final String lastName;
  const AdminTodayScreen({
    super.key,
     required this.employeeID, required this.firstName, required this.lastName
  });
  @override
  State<AdminTodayScreen> createState() => _AdminTodayScreenState();
}

class _AdminTodayScreenState extends State<AdminTodayScreen> {
  // ================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;

  String checkIn = '--/--';
  String checkOut = '--/--';

  _getAttendance()async{
    DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('Admins')
      .doc(AdminModel.adminID)
      .collection('${AdminModel.adminUsername} branch employees')
      .doc(widget.employeeID)
      .collection('Attendance')
      .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
      .get();

    if(snap['checkIn'] != null && snap['checkOut'] == '--/--'){
      setState(() {
        checkIn = snap['checkIn'];
        checkOut = '--/--';
      });
    }else if(snap['checkIn'] != null && snap['checkOut'] != '--/--'){
      setState(() {
        checkIn = snap['checkIn'];
        checkOut = snap['checkOut'];
      });
    }else{
      setState(() {
        checkIn = '--/--';
        checkOut = '--/--';
      });
    }
  }

  _getLateAndAbsnt()async{
    DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('Admins')
      .doc(AdminModel.adminID)
      .collection('${AdminModel.adminUsername} branch employees')
      .doc(widget.employeeID)
      .collection('Late and Absence')
      .doc(DateFormat('MMMM yyyy').format(DateTime.now()))
      .get();
    try {
      setState(() {
        AdminModel.latte = snap['late'];
        AdminModel.absent = snap['absent'];
      });
      print(AdminModel.absent);
      print(AdminModel.latte);
    } catch (e) {
      setState(() {
        AdminModel.latte = 0;
        AdminModel.absent = 0;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getAttendance();
    _getLateAndAbsnt();
  }
  // ================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        toolbarHeight: 40.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
          },
          child: Container(
            width: 200.0,
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.arrow_back_ios_new, size: 19.0, color: secondary,),
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 15.0),
        child: SafeArea(
          child: Container(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 5.0),
                  child: Text(
                    widget.firstName + ' ' + widget.lastName + '(Id: ${widget.employeeID})',
                    style: TextStyle(
                      color: Colors.black54, fontStyle: FontStyle.italic, fontSize: 14.0
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Today\'s Status', style: TextStyle(fontSize: 16.0),)),

                Container(
                  width: screenWidth,
                  height: 100.0,
                  margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(2, 2)
                      )
                    ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Check In', style: TextStyle(color: Colors.black45,),),
                            Container(height: 2.0, width: 30.0, color: Colors.black12, margin: EdgeInsets.symmetric(vertical: 2.0),),
                            Text(checkIn, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
                          ],
                        )
                      ),
                      Container(height: 100.0, width: 1.0, color: Colors.black12,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Check Out', style: TextStyle(color: Colors.black54,),),
                            Container(height: 2.0, width: 30.0, color: Colors.black12, margin: EdgeInsets.symmetric(vertical: 2.0),),
                            Text(checkOut, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
                          ],
                        )
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateTime.now().day.toString(),
                            style: TextStyle(color: Colors.amber.shade900, fontSize: 18.0),),
                          SizedBox(width: 5.0,),
                          Text(
                            DateFormat('MMMM yyyy').format(DateTime.now()),
                          ),
                        ],
                      ),
                      StreamBuilder<Object?>(
                        stream: Stream.periodic(Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('hh:mm:ss a').format(DateTime.now()), 
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),);
                        }
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  // padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      Expanded(
                        child: Container(
                          color: Colors.black12,
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCheckIn(),
                              Text('OR'),
                              SizedBox(height: 5.0,),
                              _buildCheckInLate(),
                              _buildCheckInPermission(),
                              _buildCheckInReasonfull(),
                              _buildCheckInReset(),
                            ],
                          ),
                        )
                      ),

                      Expanded(
                        child: Container(
                          color: Colors.black38,
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCheckOut(),
                              Text('OR'),
                              SizedBox(height: 5.0,),
                              _buildCheckOutLate(),
                              _buildCheckOutPermission(),
                              _buildCheckOutReasonfull(),
                              _buildCheckOutReset(),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                _buildAbsent(),
              ],
            ),
          )
        ),
      ),
    );
  }


  Widget _buildCheckIn(){
    return  Container(
      margin: EdgeInsets.only(bottom: 10.0, left: 10, right: 10.0),
      child: Builder(
        builder: (context){
          final GlobalKey<SlideActionState> key = GlobalKey();
          return SlideAction(
            key: key,
            outerColor: Colors.black38,
            height: 30.0,
            sliderButtonIconSize: 16.0,
            sliderButtonIconPadding: 5.0,
            text: 'Check-In',
            textStyle: TextStyle(fontSize: 13.0, color: Colors.white),
            onSubmit: () async{
              Future.delayed(Duration(milliseconds: 1500),(){
                key.currentState!.reset();
              });

              try {
                setState(() {
                  checkIn = DateFormat('hh:mm a').format(DateTime.now());
                });
              await FirebaseFirestore.instance
                .collection('Admins')
                .doc(AdminModel.adminID)
                .collection('${AdminModel.adminUsername} branch employees')
                .doc(widget.employeeID)
                .collection('Attendance')
                .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                .set({
                  'checkIn':  checkIn,
                  'checkOut': checkOut,
                  'date': Timestamp.now()
                });
              } catch (e) {
                print(e.toString());
              }
            },
          );
        }
      ),
    ); 
  }
  Widget _buildCheckInLate(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkIn = 'Late';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Late and Absence')
          .doc(DateFormat('MMMM yyyy').format(DateTime.now()))
          .set({
            'absent':  AdminModel.absent!,
            'late': AdminModel.latte! + 1,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(3.0)
        ),
        child: Text('Late', style: TextStyle(fontSize: 12.0, color: Colors.black),)
      ),
    );
  }
  Widget _buildCheckInPermission(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkIn = 'Permission';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          color: Colors.green.shade800,
          borderRadius: BorderRadius.circular(3.0)
        ),
        child: Text('Permission', style: TextStyle(fontSize: 12.0, color: Colors.white),)
      ),
    );
  }
  Widget _buildCheckInReasonfull(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkIn = 'Other Reasons';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade700,
          borderRadius: BorderRadius.circular(3.0)
        ),
        child: Text('Other Reasons', style: TextStyle(fontSize: 12.0, color: Colors.white),)
      ),
    );
  }

  Widget _buildCheckInReset(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkIn = '--/--';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Late and Absence')
          .doc(DateFormat('MMMM yyyy').format(DateTime.now()))
          .set({
            'absent':  AdminModel.absent!,
            'late': AdminModel.latte!,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: Colors.amber.shade900,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Text('Reset Check-In', style: TextStyle(color: Colors.white, fontSize: 13.0),),
      ),
    );
  }




  Widget _buildCheckOut(){
    return  Container(
      margin: EdgeInsets.only(bottom: 10.0, left: 10, right: 10.0),
      child: Builder(
        builder: (context){
          final GlobalKey<SlideActionState> key = GlobalKey();
          return SlideAction(
            key: key,
            outerColor: Colors.black38,
            height: 30.0,
            sliderButtonIconSize: 16.0,
            sliderButtonIconPadding: 5.0,
            text: 'Check-Out',
            textStyle: TextStyle(fontSize: 13.0, color: Colors.white),
            onSubmit: () async{
              Future.delayed(Duration(milliseconds: 1500),(){
                key.currentState!.reset();
              });

              try {
                setState(() {
                  checkOut = DateFormat('hh:mm a').format(DateTime.now());
                });
              await FirebaseFirestore.instance
                .collection('Admins')
                .doc(AdminModel.adminID)
                .collection('${AdminModel.adminUsername} branch employees')
                .doc(widget.employeeID)
                .collection('Attendance')
                .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                .set({
                  'checkIn':  checkIn,
                  'checkOut': checkOut,
                  'date': Timestamp.now()
                });
              } catch (e) {
                print(e.toString());
              }
            },
          );
        }
      ),
    ); 
  }
    Widget _buildCheckOutLate(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkOut = 'Late';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Late and Absence')
          .doc(DateFormat('MMMM yyyy').format(DateTime.now()))
          .set({
            'absent':  AdminModel.absent!,
            'late': AdminModel.latte! + 1,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(3.0)
        ),
        child: Text('Late', style: TextStyle(fontSize: 12.0, color: Colors.black),)
      ),
    );
  }

  Widget _buildCheckOutPermission(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkOut = 'Permission';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          color: Colors.green.shade800,
          borderRadius: BorderRadius.circular(3.0)
        ),
        child: Text('Permission', style: TextStyle(fontSize: 12.0, color: Colors.white),)
      ),
    );
  }
  Widget _buildCheckOutReasonfull(){
    return GestureDetector(
            onTap: () async{
        try {
          setState(() {
            checkOut = 'Other Reasons';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
       alignment: Alignment.center,
        padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade700,
          borderRadius: BorderRadius.circular(3.0)
        ),
        child: Text('Other Reasons', style: TextStyle(fontSize: 12.0, color: Colors.white),)
      ),
    );
  }

  Widget _buildCheckOutReset(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkOut = '--/--';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Late and Absence')
          .doc(DateFormat('MMMM yyyy').format(DateTime.now()))
          .set({
            'absent':  AdminModel.absent!,
            'late': AdminModel.latte!,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: Colors.amber.shade900,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Text('Reset Check-Out', style: TextStyle(color: Colors.white, fontSize: 13.0),),
      ),
    );
  }

  Widget _buildAbsent(){
    return GestureDetector(
      onTap: () async{
        try {
          setState(() {
            checkIn = 'Absent';
            checkOut = 'Absent';
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Attendance')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
            'checkIn':  checkIn,
            'checkOut': checkOut,
            'date': Timestamp.now()
          });
        await FirebaseFirestore.instance
          .collection('Admins')
          .doc(AdminModel.adminID)
          .collection('${AdminModel.adminUsername} branch employees')
          .doc(widget.employeeID)
          .collection('Late and Absence')
          .doc(DateFormat('MMMM yyyy').format(DateTime.now()))
          .set({
            'absent':  AdminModel.absent! + 1,
            'late': AdminModel.latte!,
            'date': Timestamp.now()
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)
          )
        ),
        child: Text('Absent', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}