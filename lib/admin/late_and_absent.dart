import 'package:attendance/admin/models/admin_model.dart';
import 'package:attendance/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class LateAndAbsentPage extends StatefulWidget {
  final String employeeID;
  final String firstName;
  final String lastName;
  const LateAndAbsentPage({
    super.key,
    required this.employeeID, required this.firstName, required this.lastName
  });

  @override
  State<LateAndAbsentPage> createState() => _LateAndAbsentPageState();
}

class _LateAndAbsentPageState extends State<LateAndAbsentPage> {
  // =======================================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;

  String _month = DateFormat('MMMM').format(DateTime.now());

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
    _getLateAndAbsnt();
  }
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminAuthChecker()));
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
                child: Container(
                  child: Text(
                    '${widget.firstName}\'s Monthly Attendance',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
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
                height: 200.0,
                child: Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                      .collection('Admins')
                      .doc(AdminModel.adminID)
                      .collection('${AdminModel.adminUsername} branch employees')
                      .doc(widget.employeeID)
                      .collection('Late and Absence') 
                      .snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                            var data = snapshot.data!.docs[index];
                            return DateFormat('MMMM').format(data['date'].toDate()) == _month ? Container(
                              height: 150.0,
                              margin: EdgeInsets.only(top: 20.0),
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
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Number of Late', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),),
                                        Container(width: 100.0, height: 1, color: Colors.black26, margin: EdgeInsets.symmetric(vertical: 5.0),),
                                        Text(data['late'].toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),)
                                      ],
                                    )
                                  ),
                                  Container(width: 1.0, height: 130.0, color: Colors.black12,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Number of Absent', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),),
                                        Container(width: 100.0, height: 1, color: Colors.black26, margin: EdgeInsets.symmetric(vertical: 5.0),),
                                        Text(data['absent'].toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),)
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ) : Container();
                          }
                        );
                      }else{
                        return Container();
                      }
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}