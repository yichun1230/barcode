import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScanResult(),
    );
  }
}

class ScanResult extends StatefulWidget{

  String value;
  ScanResult({this.value});

  @override
  _ScanResultState createState() => _ScanResultState(this.value);
}

class _ScanResultState extends State<ScanResult> {

  String value;
  _ScanResultState(this.value);

  final ref = FirebaseFirestore.instance.collection('barcode');
  String  pro,car,fat,cal,name,pack,total;//,barcodeScanRes="4710543002305";
  bool _PlussEnabled,_MinusEnabled;
  int num=1;


   Future<void> setData() async {
     await ref.doc(value).get().then((DocumentSnapshot doc) {
      String _name = doc.data()['name'];
      String _cal = doc.data()['calorie'];
      String _pro = doc.data()['protein'];
      String _fat = doc.data()['fat'];
      String _car = doc.data()['carbohydrate'];
      String _pack = doc.data()['perpack'];
      String _total = doc.data()['packnum'];

      setState(() {
        name=_name;
        cal=_cal;
        pro=_pro;
        fat=_fat;
        car=_car;
        pack=_pack;
        total=_total;
      });
    });
  }

  void _Check(){
    (num>=int.parse(total)) ? _PlussEnabled=false : _PlussEnabled=true;
    (num<=1) ? _MinusEnabled=false : _MinusEnabled=true;
  }
  @override
  Widget build(BuildContext context) {

     setData();

    (num<int.parse(total))? _PlussEnabled=true : _PlussEnabled=false ;
    (num==1)? _MinusEnabled=false : _MinusEnabled=true ;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xFF3D82AE),
      body: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(top: height*0.18,left: width*0.05,right: width*0.02),
            title: Text(name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32,
                color: Colors.white,
              ),),
            subtitle: Text("每一份量含 "+pack.toString()+" 公克",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),),
          ),
          Stack(
            children: <Widget>[
              Positioned(
                top: height*0.35,
                  height: height*0.8,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: const Radius.circular(24),
                      ),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 30, left: 18, right: 8, bottom: 10),
                      child: Column(
                        children:<Widget>[
                          SizedBox(height: width*0.13,),
                          Row(
                            children: <Widget>[
                              _RadialProgress(
                                width: width * 0.32,
                                height: width * 0.3,
                                progress: double.parse(cal)/1000*num,
                                cal: double.parse(cal)*num,
                              ),
                              SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _IngredientProgress(
                                  ingredient: "Protein",
                                  progress: double.parse(pro)/15*num,
                                  progressColor: Colors.green,
                                  leftAmount: double.parse(pro)*num,
                                  width: width*0.43,
                                  ),
                                  SizedBox(height: 15,),
                                  _IngredientProgress(
                                    ingredient: "Fat",
                                    progress: double.parse(fat)/30*num,
                                    progressColor: Colors.red,
                                    leftAmount: double.parse(fat)*num,
                                    width: width*0.43,
                                  ),
                                  SizedBox(height: 15,),
                                  _IngredientProgress(
                                    ingredient: "Carbs",
                                    progress: double.parse(car)/60*num,
                                    progressColor: Colors.yellow,
                                    leftAmount: double.parse(car)*num,
                                    width: width*0.43,
                                  ),
                              ],
                              ),
                            ],
                          ),
                          SizedBox(height:width*0.15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RawMaterialButton(
                                onPressed:(){
                                  if(_MinusEnabled){
                                    setState(() {
                                      num-=1;
                                    });
                                    _Check();
                                  }
                                  else null ;
                                },
                                child: Icon(FontAwesomeIcons.minus,color: Color(0xff220055),
                                size: 30,),
                                shape: CircleBorder(),
                                elevation:5.0,
                                fillColor: Color(0xffFAF4F2),
                                padding: const EdgeInsets.all(10.0),
                              ),
                              Text(
                                '$num份',
                                style: TextStyle(fontSize: 44,color:Colors.black),
                              ),
                              RawMaterialButton(
                                onPressed:(){
                                  if(_PlussEnabled){
                                    setState(() {
                                      num+=1;
                                    });
                                    _Check();
                                  }
                                  else null ;
                                },
                                //_PlussEnabled ? () =>plus : null ,
                                child: Icon(FontAwesomeIcons.plus,color: Color(0xFF092A44),
                                  size: 30,),
                                shape: CircleBorder(),
                                elevation: 5.0,
                                fillColor: Color(0xffFAF4F2),
                                padding: const EdgeInsets.all(10.0),
                              ),
                            ],
                          ),
                          SizedBox(height: width*0.2,),
                          FlatButton(
                            height: 50,
                            minWidth: 250,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            color: Color(0xFF3D82AE),
                            onPressed: () {  },
                            child: Text(
                              "新增".toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadialProgress extends StatelessWidget{

  final double height,width,progress,cal;

  const _RadialProgress({Key key, this.height, this.width, this.progress, this.cal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
          progress: progress>1 ? 1 : progress, //0.7    //跟上面有連接
        ),
        child: Container(
          height: height,
          width: width,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(text: cal.toStringAsFixed(1),style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF200087)
                  ),),
                  TextSpan(text: "\n"),
                  TextSpan(text: "kcal",style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF200087)
                  ),),
                ]
              ),
            ),
          )
        ),
    );
  }

}

class _RadialPainter extends CustomPainter{

  final double progress;

  _RadialPainter({this.progress});

  void paint(Canvas canvas,Size size){
    Paint paint =Paint()
      ..strokeWidth=10
        ..color = Colors.black12//Color(0xFF200087)
        ..style=PaintingStyle.stroke //中間變空心
        ..strokeCap = StrokeCap.round;

    Offset center =Offset(size.width/2,size.height/2);
    canvas.drawCircle(center, size.width/2, paint);

    Paint progressPaint =Paint()
      ..strokeWidth=10
      ..color = Colors.blue
      ..shader = LinearGradient(
            colors: [Colors.red,Colors.purple,Colors.purpleAccent])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style=PaintingStyle.stroke //中間變空心
      ..strokeCap = StrokeCap.round;


    double relativeProgress=360*progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90), //改變方向從12點鐘方向往左走
      math.radians(-relativeProgress),  //改變百分比
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class _IngredientProgress extends StatelessWidget {

  final String  ingredient;
  final double leftAmount;
  final double progress,width;
  final Color progressColor;

  const _IngredientProgress({Key key, this.ingredient, this.leftAmount, this.progress, this.progressColor, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height:13,
                  width:width ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height:13,
                  width: progress>1.0 ? width*1.0 : width*progress ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:progressColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8,),
            Text(leftAmount.toStringAsFixed(1)+"g"),
          ],
        ),
      ],
    );
  }
}

