import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'global.dart';
import 'package:intl/intl.dart';
import 'package:progress_timeline/progress_timeline.dart';
import 'package:timelines/timelines.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timelines Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Checkin_reward(),
    );
  }
}

class Checkin_reward extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Checkin_reward> {

  List isActive=[false,false,false,false,false,false,false];
  List isToday=[false,false,false,false,false,false,false];
  List dailyPoint=[10,20,30,40,50,50,100];
  int theDay;
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String today ;

  final ref = FirebaseFirestore.instance.collection('user_point');

  Future<void> getData() async {

    var difference;

    await ref.doc('a@gmail.com').get().then((DocumentSnapshot doc) {
      userPoint=doc.data()['point'];
      stage=doc.data()['stage'];
      latest=doc.data()['latest'];
    });

    today = formatter.format(now);
    difference = DateTime.parse(today).difference(DateTime.parse(latest));
    if(difference.inDays==1){
      if(stage==7) {
        isToday[0]=true;
        theDay=0;
      }
      else {
        isToday[stage]=true;
        theDay=stage;
        for(var i = 0; i < stage; i++){
          isActive[i]=true;
        }
      }
    }
    else if(difference.inDays==0){
      for(var i = 0; i < stage; i++){
        isActive[i]=true;
      }
    }
    else {
      isToday[0]=true;
      theDay=0;
    }
  print("天:$theDay");


  }

  @override
void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("每日登入獎勵"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text("積分:$userPoint",
              style:TextStyle(
                color: Colors.black,
                fontSize: 20
            ),),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 1,
              color: Colors.grey,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                  width: 400,
                  height: 4,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    statusWidget('Day1', isActive[0], isToday[0]),
                    statusWidget('Day2', isActive[1], isToday[1]),
                    statusWidget('Day3', isActive[2], isToday[2]),
                    statusWidget('Day4', isActive[3], isToday[3]),
                    statusWidget('Day5', isActive[4], isToday[4]),
                    statusWidget('Day6', isActive[5], isToday[5]),
                    statusWidget('Day7', isActive[6], isToday[6]),
                  ],
                ),
              ],
            ),
            SizedBox(height: 35,),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              child: Text("領取"),
              color: Colors.orange,
              onPressed: () async {
                if(isToday[theDay]){
                  setState(() {
                    isActive[theDay]=true;
                  });
                  userPoint+=dailyPoint[theDay];
                  isToday[theDay]=false;
                  await ref.doc('a@gmail.com').set({'stage':theDay+1,'latest':today,'point':userPoint});
                }
              },
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              child: Text("獎勵一: 50點"),
              color: Colors.orange,
              onPressed: () async {
                if(userPoint>50){
                  setState(() {
                    userPoint-=50;
                  });
                  await ref.doc('a@gmail.com').update({'point':userPoint});
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container statusWidget( String status, bool isActive, bool isToday)
  {
    return Container(
      //margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive) ? Colors.orange : Colors.white,
                border: Border.all(
                    color: (isActive) ? Colors.transparent : Colors.orange,
                    width: 3
                ),
            ),
            child: (isActive) ?
            Icon(Icons.check,size: 21,color: Colors.white,):
            Icon(Icons.brightness_1,size: 20,color: (isToday) ?Colors.orange:Colors.transparent,),
          ),
           SizedBox(height: 10,),
          Text(status,
              style: TextStyle(
               fontSize: 12,
                  color: (isActive) ? Colors.orange : Colors.black
              )),
        ],
      ),
    );
  }

}



// child: Column(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     SizedBox(height: 30,),
//     Text("點數:$point",style: TextStyle(fontSize: 32,)),
//     SizedBox(height: 40,),
//     Container(
//       child: progressTimeline,
//     ),
//     SizedBox(height: 10.0,),
//     RaisedButton(
//       padding: EdgeInsets.all(10.0),
//       child: Text("go"),
//       color: Colors.yellow,
//       onPressed: (){
//         progressTimeline.gotoNextStage();
//       },
//     ),
//     RaisedButton(
//       padding: EdgeInsets.all(10.0),
//       child: Text("fail"),
//       color: Colors.green,
//       onPressed: (){
//         progressTimeline.failCurrentStage();
//       },
//     ),
//     RaisedButton(
//       padding: EdgeInsets.all(10.0),
//       child: Text("previous"),
//       color: Colors.pink,
//       onPressed: (){
//         progressTimeline.gotoPreviousStage();
//       },
//     ),
//   ],
// ),