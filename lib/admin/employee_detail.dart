import 'package:attendance/admin/monthly_screen.dart';
import 'package:attendance/admin/profile_screen.dart';
import 'package:attendance/admin/today_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmployeeDetail extends StatefulWidget {
  final String employeeID;
  final String firstName;
  final String lastName;
  const EmployeeDetail({
    super.key,
    required this.employeeID, required this.firstName, required this.lastName
    });

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  // ========================================================================================
  var currentIndex = 1;
  List bottomNavigationIcons = [Icons.calendar_month_outlined, Icons.check, Icons.person_outline_outlined];

  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;
  // ========================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: primary, toolbarHeight: 0.0,),
      body: IndexedStack(
        index: currentIndex,
        children: [
          AdminMonthlyScreen(employeeID: widget.employeeID, firstName: widget.firstName, lastName: widget.lastName,),
          AdminTodayScreen(employeeID: widget.employeeID, firstName: widget.firstName, lastName: widget.lastName,),
          AdminProfileScreen(employeeID: widget.employeeID, firstName: widget.firstName, lastName: widget.lastName,)
        ],
      ),

      bottomNavigationBar: Container(
        height: 50.0,
        width: screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        // margin: EdgeInsets.only(left: screenWidth/20, right: screenWidth/20, bottom: screenWidth/25),
        decoration: BoxDecoration(
          color: primary,
          // borderRadius: BorderRadius.circular(20.0),
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
            for(int i = 0; i < bottomNavigationIcons.length; ++i)...<Expanded>{
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          bottomNavigationIcons[i], 
                          size: 22.0,
                          color: currentIndex == i ? Colors.amber : Colors.white60,
                        ),
                        SizedBox(height: 1.0,),
                        Container(
                          child: currentIndex == i ? Container(
                          height: 2.0 ,
                          width: 20.0,
                          color: Colors.amber,
                        ) : Container(),
                        )
                      ],
                    ),
                  ),
                )
              )
            }
          ],
        ),
      ),
    );
  }
}