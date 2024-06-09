import 'package:attendance/admin/home_screen.dart';
import 'package:attendance/admin/late_and_absent.dart';
import 'package:attendance/admin/models/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class AdminMonthlyScreen extends StatefulWidget {
  final String employeeID;
  final String firstName;
  final String lastName;
  const AdminMonthlyScreen({
    super.key,
    required this.employeeID, required this.firstName, required this.lastName
  });

  @override
  State<AdminMonthlyScreen> createState() => _AdminMonthlyScreenState();
}

class _AdminMonthlyScreenState extends State<AdminMonthlyScreen> {
  // =======================================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;

   String _month = DateFormat('MMMM').format(DateTime.now());
  // =======================================================================================================
  @override
  Widget build(BuildContext context) {
    screenHight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
        padding: EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.firstName}\'s Monthly Attendance',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LateAndAbsentPage(employeeID: widget.employeeID, firstName: widget.firstName, lastName: widget.lastName)));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          border: Border.all(color: Colors.lightBlue)
                        ),
                        child: Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.lightBlue, fontSize: 13.0
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                     '_ ' +_month+' _',
                      style: TextStyle(color: Colors.amber.shade800, fontSize: 14, fontWeight: FontWeight.w700),
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
                          // Icon(Icons.arrow_forward_outlined, size: 20.0, color: Colors.black45),
                          SizedBox(width: 10.0,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: primary, width: .5)
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Select a Month ',
                                  style: TextStyle(color: Colors.black87, fontSize: 13,),
                                ),
                                Icon(Icons.arrow_drop_down, color: primary,)
                              ],
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
                height: screenHight - screenHight/3.1,
                padding: EdgeInsets.only(bottom: 5.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                    .collection('Admins')
                    .doc(AdminModel.adminID)
                    .collection('${AdminModel.adminUsername} branch employees')
                    .doc(widget.employeeID)
                    .collection('Attendance')
                    .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          final data = snapshot.data!.docs[index];
                          return DateFormat('MMMM').format(data['date'].toDate()) == _month ? Container(
                            height: 120.0,
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
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      DateFormat('EE\ndd').format(data['date'].toDate()), 
                                      style: TextStyle(color: secondary),),
                                  )
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Check In', style: TextStyle(color: Colors.black54, fontSize: 14.0),),
                                      Container(width: 25.0, height: 1.5, color: Colors.black26, margin: EdgeInsets.symmetric(vertical: 2.0),),
                                      Text(data['checkIn'],  style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                                Container(width: 1.0, height: screenHight/7, color: Colors.black12,),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Check Out', style: TextStyle(color: Colors.black54, fontSize: 14.0),),
                                      Container(width: 25.0, height: 1.5, color: Colors.black26, margin: EdgeInsets.symmetric(vertical: 2.0),),
                                      Text(data['checkOut'],  style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),)
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