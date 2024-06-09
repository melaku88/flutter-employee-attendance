import 'package:attendance/admin/add_employee.dart';
import 'package:attendance/admin/adminSharedPref/admin_shared.dart';
import 'package:attendance/admin/employee_detail.dart';
import 'package:attendance/admin/models/admin_model.dart';
import 'package:attendance/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // =================================================================================
  double screenWidth = 0;
  double screenHight = 0;
  Color primary = Colors.black54;
  Color secondary = Colors.white;
  
  String adminID = '',  lastEmpoyeeId = '', employeeID = '', adminUsername = '', idNumString = '';
  int idNumPart = 0;

  var queryResultSet = [];
  var tempSearchStorage = [];

  Future<void>_getAdminID() async{
    QuerySnapshot snap = await FirebaseFirestore.instance
      .collection('Admins')
      .where('username', isEqualTo: AdminModel.adminUsername)
      .get();

    adminID = snap.docs[0].id;
    setState(() {
      AdminModel.adminID = adminID;
    });
  }


   Future<void>_getEmployeeID()async{
    DocumentSnapshot doc = await FirebaseFirestore.instance
    .collection('Admins')
    .doc(AdminModel.adminID)
    .get();

    lastEmpoyeeId = doc['lastEmployeeId'];
    idNumPart = int.parse(doc['lastEmployeeId'].toString().split('-')[1]);
    setState(() {
      AdminModel.lastEmployeeId = lastEmpoyeeId;
      AdminModel.idNumPart = idNumPart + 1;
    });

    }

   _employeeID(){
      adminUsername = AdminModel.adminUsername!;
      idNumString = AdminModel.idNumPart.toString();
      setState(() {
        AdminModel.employeeID = adminUsername + '-' + idNumString;
      });
    }

    _initialSearch(value)async{
      if(value.length == 0){
        setState(() {
          queryResultSet = [];
          tempSearchStorage = [];
        });
      }else if(queryResultSet.isEmpty && value.length == 1){
       await FirebaseFirestore.instance
      .collection('Admins')
      .doc(AdminModel.adminID)
      .collection('${AdminModel.adminUsername} branch employees')
      .where('searchKey', isEqualTo: value.substring(0,1).toLowerCase())
      .get().then((QuerySnapshot snapshot){
        for(int i = 0; i < snapshot.docs.length; i++){
          setState(() {
            queryResultSet.add(snapshot.docs[i].data());
          });
        }
        queryResultSet.forEach((element) { 
          if(element['firstName'].startsWith(value)){
            setState(() {
              tempSearchStorage.add(element);
            });
          }
        });
      });
      }else{
        tempSearchStorage = [];
        queryResultSet.forEach((element) {
          if(element['firstName'].startsWith(value)){
            setState(() {
              tempSearchStorage.add(element);
            });
          }
        });
      }
    }

  @override
  void initState() {
    super.initState();
    _getAdminID().then((value){
      _getEmployeeID().then((value){
        _employeeID();
      });
    });
    _getEmployeeID();
  }

  // =================================================================================
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.grey.shade700, toolbarHeight: 0.0,),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15.0, right: 10.0, top: 20.0, bottom: 15.0),
                color: Colors.grey.shade700,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Employees of '+adminUsername+' branch',
                          style: TextStyle(fontSize: 16.0 , color: secondary),
                        ),
                        GestureDetector(
                          onTap: (){
                            AdminSharedPreferances().deleteUsername();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminAuthChecker()));
                            setState(() {
                              AdminModel.adminUsername = null;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color.fromARGB(255, 159, 143, 95), width: 0.5)
                            ),
                            child: Text('Logout', style: TextStyle(color: Colors.amber, fontSize: 11.0),),
                          ),
                        )
                      ],
                    ),
                    _buildSearch(),
                  ],
                ),
              ),
              Expanded(
                child: queryResultSet.length == 0 ? Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 20.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                      .collection('Admins')
                      .doc(AdminModel.adminID)
                      .collection('${AdminModel.adminUsername} branch employees')
                      .orderBy('timestamp', descending: false)
                      .snapshots(), 
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                            var data = snapshot.data!.docs[index];
                              return Container(
                              width: screenWidth,
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black26, width: 1.0),
                                  bottom: BorderSide(color: Colors.black26, width: 0.5),
                                  left: BorderSide(color: Colors.black26, width: 1.0),
                                  right: BorderSide(color: Colors.black26, width: 1.0),
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text((index+1).toString() + '. '),
                                      Text(data['firstName'] + ' ' + data['lastName'])
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeDetail(
                                        employeeID: data['EmployeeID'], firstName: data['firstName'], lastName: data['lastName']
                                      )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(13.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: Icon(Icons.arrow_forward_ios_outlined, size: 16.0, color: Colors.black45,)
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        );
                      }else if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: SpinKitThreeBounce(itemBuilder: (context, index) => DecoratedBox(
                            decoration: BoxDecoration(
                              color: index.isEven ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(15.0)
                            )
                          )
                        )
                        );
                      }else if(snapshot.hasError){
                        return Text('Something went wrong!');
                      }else{
                        return Container();
                      }
                    }
                  )
                ): ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: tempSearchStorage.map((data){
                    return Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.black26, width: 1.0),
                          bottom: BorderSide(color: Colors.black26, width: 0.5),
                          left: BorderSide(color: Colors.black26, width: 1.0),
                          right: BorderSide(color: Colors.black26, width: 1.0),
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(data['firstName'] + ' ' + data['lastName'])
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeDetail(
                                employeeID: data['EmployeeID'], firstName: data['firstName'], lastName: data['lastName']
                              )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(13.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(5.0)
                              ),
                              child: Icon(Icons.arrow_forward_ios_outlined, size: 16.0, color: Colors.black45,)
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        )
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddEmployee()));
        },
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, color: secondary,)
        ),
      ),
    );
  }
  Widget _buildSearch(){
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: CupertinoTextField(
        onChanged: (value) {
          setState(() {
            _initialSearch(value.toLowerCase());
          });
        },
        cursorColor: Colors.white60,
        cursorWidth: 1.2,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        style: TextStyle(color: Colors.white, fontSize: 14.0, letterSpacing: 1.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(20.0),
        ),
        suffix: Container(
          margin: EdgeInsets.only(right: 0.0),
          padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.5),
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0))
          ),
          child: Icon(Icons.search, color: Colors.black, size: 22.0,)
        ),
      ),
    );
  }
}