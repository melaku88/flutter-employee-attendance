import 'package:attendance/users/calendarscreen.dart';
import 'package:attendance/users/models/usermodel.dart';
import 'package:attendance/users/profilescreen.dart';
import 'package:attendance/users/todayscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // =================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Color.fromARGB(255, 242, 121, 121);
  int currentIndex = 1;

  List navigationIcons = [
    Icons.calendar_month_outlined, Icons.check, Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _getId().then((value){
      _getCredincials();
      _getProfilePic();
    });
  }
  Future<void> _getId() async{
    QuerySnapshot snap = await FirebaseFirestore.instance
      .collection('Employees')
      .where('id', isEqualTo: UserModel.employeeId)
      .get();

      setState(() {
        UserModel.id = snap.docs[0].id;
      });
  }

  void _getCredincials()async{
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('Employees').doc(UserModel.id).get();
      setState(() {
        UserModel.canEdit = snap['canEdit'];
        UserModel.firstName = snap['firstName'];
        UserModel.lastName = snap['lastName'];
        UserModel.address = snap['address'];
      });
    } catch (e) {
      return;
    }
  }
    void _getProfilePic()async{
      try {
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('Employees').doc(UserModel.id).get();
        setState(() {
          UserModel.profilePicLink = snap['profilePic'];
        });
      } catch (e) {
        return;
      }
  }

  // =================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: [
          new CalendarScreen(),
          new TodayScreen(),
          new ProfileScreen()
        ],
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        margin: EdgeInsets.only(left:screenWidth/25, right: screenWidth/25, bottom: screenHight/50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              offset: Offset(2, 2)
            )
          ]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for(int i = 0; i < navigationIcons.length; i ++)...<Container>{
              Container(
                child: GestureDetector(
                  onTap: () {
                    currentIndex = i;
                    setState(() {
                      
                    });
                  },
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        navigationIcons[i], 
                        size: 22.0,
                        color: currentIndex == i ? primary : Colors.black38,
                      ),
                      currentIndex == i ? Container(
                      height: 2.0, width: 18.0, color: primary,
                    ) : Container(),
                    ],
                  ),

                ),
              )
            }
          ],
        ),
      ),
    );
  }
}