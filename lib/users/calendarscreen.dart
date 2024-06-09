import 'package:attendance/users/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // =======================================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Color.fromARGB(255, 227, 146, 146);

   String _month = DateFormat('MMMM').format(DateTime.now());
  // =======================================================================================================
  @override
  Widget build(BuildContext context) {
    screenHight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'My Attendance',
                  style: TextStyle(color: Colors.black87, fontSize: screenWidth/25),
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                     '_ ' +_month+' _',
                      style: TextStyle(color: Colors.black87, fontSize: screenWidth/25, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async{
                        final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2099),
                        );
                        setState(() {
                          _month = DateFormat('MMMM').format(month!);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.arrow_forward_outlined, size: 20.0, color: Colors.black45),
                          SizedBox(width: 10.0,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: primary, width: .5)
                            ),
                            child: Text(
                              'Pick a Month',
                              style: TextStyle(color: primary, fontSize: screenWidth/27, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              Container(
                height: screenHight - screenHight/3.5,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Employees').doc(UserModel.id).collection('Record').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          final data = snapshot.data!.docs[index];
                          return DateFormat('MMMM').format(data['date'].toDate()) == _month ? Container(
                            height: screenHight/5,
                            margin: EdgeInsets.only(top: 10, bottom: 10.0),
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
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      DateFormat('EE dd').format(data['date'].toDate()), 
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                                  )
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Check In', style: TextStyle(color: Colors.black45, fontSize: 16.0),),
                                      Container(width: 20.0, height: 1.5, color: Colors.black26,),
                                      Text(data['checkIn'],  style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),)
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
                                      Text(data['checkOut'],  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ) : Container();
                        }
                      );
                    }else{
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}