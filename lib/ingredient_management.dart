import 'package:barcode_scanner/ingredient_courses_2.dart';
import 'package:barcode_scanner/ingredient_courses_3.dart';
import 'package:barcode_scanner/ingredient_courses_4.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'global.dart';
import 'ingredient_courses.dart';
import 'ingredient_courses_1.dart';




Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(food_record());
}


class food_record extends StatelessWidget {
  static final String title = '食材管理';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: MainPage(),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String temp;
  int _selectedIndex = 0;
  //DateTime today = DateTime.now();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String today ;


  final  List<Widget> _widgetOptions = <Widget>[
    Ingredient_Courses(),
    Ingredient_Courses_1(),
    Ingredient_Courses_2(),
    Ingredient_Courses_3(),
    Ingredient_Courses_4(),
  ];

  final refrecord = FirebaseFirestore.instance.collection('ingredient');

  Future<void> getData() async {

    var difference;

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection('a@gmail.com').get();//只顯示該用戶的食材記錄
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name=name_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
       difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
       if(difference.inDays<0) exp_Data[i]=-1;
       else  exp_Data[i]=difference.inDays;
       //print("第$i筆:${exp_Data[i]}");
    }
    ingredient_exp= exp_Data;
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num=num_Data;
  }
  Future<void> getData_1() async {

    var difference;

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection('a@gmail.com').where("class", isEqualTo: "1").get();//只顯示該用戶的食材記錄
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_1=name_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      //print("第$i筆:${exp_Data[i]}");
    }
    ingredient_exp_1= exp_Data;
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_1=num_Data;
  }
  Future<void> getData_2() async {

    var difference;

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection('a@gmail.com').where("class", isEqualTo: "2").get();//只顯示該用戶的食材記錄
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_2=name_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      //print("第$i筆:${exp_Data[i]}");
    }
    ingredient_exp_2= exp_Data;
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_2=num_Data;
  }
  Future<void> getData_3() async {

    var difference;

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection('a@gmail.com').where("class", isEqualTo: "3").get();//只顯示該用戶的食材記錄
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_3=name_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      //print("第$i筆:${exp_Data[i]}");
    }
    ingredient_exp_3= exp_Data;
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_3=num_Data;
  }
  Future<void> getData_4() async {

    var difference;

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection('a@gmail.com').where("class", isEqualTo: "4").get();//只顯示該用戶的食材記錄
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_4=name_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      //print("第$i筆:${exp_Data[i]}");
    }
    ingredient_exp_4= exp_Data;
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_4=num_Data;
  }

  void initState() {
    super.initState();
    getData();
    getData_1();
    getData_2();
    getData_3();
    getData_4();
  }

  void _onItemTapped(int index) { //onTap換index
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     food_record.title,
      //     style : TextStyle(fontSize: 20, color: Colors.black),
      //   ),
      //   centerTitle: true,
      // ),
      body: Column(
        children:[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
            ),
            child: Container(
              color: Color(0xFFFDF1C1),
              height: 200,
                width: MediaQuery.of(context).size.width,
                child: ListTile(
                    contentPadding: EdgeInsets.only(top: 53,left: 30),
                    title: Text("食材管理",
                      style: TextStyle(
                        letterSpacing: 9,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        fontSize: 34,
                        color: Colors.black,
                      ),),
                    subtitle: Text("Save food glorious, \nshame on wasted food.",
                      style: TextStyle(
                        letterSpacing: 5,
                        height: 1.8,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.black45,
                      ),),
                  ),
            ),
          ),
          CurvedNavigationBar(
            //color: Colors.white,
              backgroundColor: Color(0xFFFDF1C1),
              height: 43,
              items: [
                Icon(Icons.list,size: 25,color:Colors.black),
                Icon(Icons.filter_1,size: 25,color:Colors.black),
                Icon(Icons.filter_2,size: 25,color:Colors.black),
                Icon(Icons.filter_3,size: 25,color:Colors.black),
                Icon(Icons.filter_4,size: 25,color:Colors.black)
              ],
              //animationCurve: Curves.fastOutSlowIn,
              index: _selectedIndex, //一開始顯示的頁面
              onTap: _onItemTapped,
          ),
          _widgetOptions.elementAt(_selectedIndex),
          //Ingredient_Courses(),
        ],),
    );
  }
}

