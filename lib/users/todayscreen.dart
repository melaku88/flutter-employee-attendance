import 'dart:async';
import 'package:attendance/users/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  // =================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Color.fromARGB(255, 242, 121, 121);

  String checkIn = '--/--';
  String checkOut = '--/--';

  @override
  void initState() {
    _getRecord();
    super.initState();
  }
  void _getRecord() async{
    // try {
      QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Employees')
        .where('id',isEqualTo: UserModel.employeeId)
        .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
        .collection('Employees')
        .doc(snap.docs[0].id)
        .collection('Record')
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .get();

      if(snap2['checkIn'] != null && snap2['checkOut'] == '--/--'){
        setState(() {
          checkIn = snap2['checkIn'];
          checkOut = '--/--';
        });
      }else if(snap2['checkIn'] != null && snap2['checkOut'] != '--/--'){
        setState(() {
          checkIn = snap2['checkIn'];
          checkOut = snap2['checkOut'];
        });
      }else{
        setState(() {
          checkIn = '--/--';
          checkOut = '--/--';
        });
      }
  }
  // =================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.black38, fontSize: screenWidth/25),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                 'Employee ' + UserModel.employeeId,
                  style: TextStyle(color: Colors.black, fontSize: screenWidth/25, fontStyle: FontStyle.italic),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 25.0),
                child: Text(
                  'Today\'s Status',
                  style: TextStyle(color: Colors.black, fontSize: screenWidth/23, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: screenHight/4.5,
                margin: EdgeInsets.only(top: 15.0, bottom: 20.0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Check In', style: TextStyle(color: Colors.black45, fontSize: 16.0),),
                          Container(width: 20.0, height: 1.5, color: Colors.black26,),
                          Text(checkIn,  style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Container(width: 1.0, height: screenHight/7, color: Colors.black12,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Check Out', style: TextStyle(color: Colors.black45, fontSize: 16.0),),
                          Container(width: 20.0, height: 1.5, color: Colors.black26,),
                          Text(checkOut,  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 3.0),
                child: RichText(
                  text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(color: Colors.black38, fontSize: 14,),
                      )
                    ]
                  )
                ),
              ),
              StreamBuilder<Object?>(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 40.0),
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  );
                }
              ),
              checkOut == '--/--' ? Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth/8, vertical: 10.0),
                child: Builder(
                  builder: (context){
                    final GlobalKey<SlideActionState> key = GlobalKey();
                    return SlideAction(
                      text: checkIn == '--/--' ? 'Slide to Check-In' : 'Slide to Check-Out',
                      outerColor: Colors.black54,
                      height: 35.0,
                      sliderButtonIconSize: 20.0,
                      sliderButtonIconPadding: 5.0,
                      textStyle: TextStyle(fontSize: 14.0, color: Colors.white),
                      key: key,
                      onSubmit: () async{
                       Timer(Duration(milliseconds: 1500), () {
                         key.currentState!.reset();
                        });
                
                        QuerySnapshot snap = await FirebaseFirestore.instance
                        .collection('Employees')
                        .where('id',isEqualTo: UserModel.employeeId)
                        .get();
                
                        DocumentSnapshot snap2 = await FirebaseFirestore.instance
                        .collection('Employees')
                        .doc(snap.docs[0].id)
                        .collection('Record')
                        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                        .get();
                
                        try {
                          String checkIn = snap2['checkIn'];
                          setState(() {
                            checkOut = DateFormat('hh:mm a').format(DateTime.now());
                          });
                          await FirebaseFirestore.instance
                          .collection('Employees')
                          .doc(snap.docs[0].id)
                          .collection('Record')
                          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                          .update({
                            'checkIn': checkIn,
                            'checkOut': DateFormat('hh:mm a').format(DateTime.now()),
                            'date': Timestamp.now()
                          });
                          
                        } catch (e) {
                          setState(() {
                            checkIn = DateFormat('hh:mm a').format(DateTime.now());
                          });
                          await FirebaseFirestore.instance
                          .collection('Employees')
                          .doc(snap.docs[0].id)
                          .collection('Record')
                          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
                          .set({
                            'checkIn': DateFormat('hh:mm a').format(DateTime.now()),
                            'checkOut': '--/--',
                            'date': Timestamp.now()
                          }); 
                        }
                      },
                    );
                  }
                ),
              ) : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 0.5)
                ),
                child: Text('You have completed this day!', style: TextStyle(color: Colors.green, fontSize: 15.0, fontWeight: FontWeight.w600),),
              )
            ],
          )
        ),
      )
    );
  }
}