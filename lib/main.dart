import 'dart:async';
import 'package:barcode_scanner/Ocr.dart';

import 'ScanResult.dart';
import 'addData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';//安裝package在pubspace.yaml
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final ref = FirebaseFirestore.instance.collection('barcode');
  String _scanBarcode = '';
  String _name="";
  String _calorie="",_pro="",_fat="",_carb="";
  bool _exit=false;

  @override
  Future initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Widget swapWidget;
    Widget contentWidget;

    if (_exit==false) {
      contentWidget=new Text("");
    } else {
      contentWidget=new Text("條碼 :"+_scanBarcode+"\n"
          +"品名 :"+_name+"\n"
          +"熱量 :"+_calorie+"\n"
          +"蛋白質 :"+_pro+"\n"
          +"脂肪 :"+_fat+"\n"
          +"碳水化合物 :"+_carb+"\n",

          style: TextStyle(fontSize: 20));
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            onPressed: () async {
                              await scanBarcodeNormal();
                              if(_exit==false){  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Ocr(value: _scanBarcode)),);
                              }
                              else
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ScanResult(value: _scanBarcode)),);
                            },
                            child: Text("Start barcode scan")),
                        //contentWidget,
                      ]));
            })));
  }

  Future<void> scanBarcodeNormal() async {

    String barcodeScanRes;
    bool exit;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return; //判斷頁面是否被釋放


    await ref.doc(barcodeScanRes).get().then((DocumentSnapshot doc) {
      exit=doc.exists;
      print(_exit);
      if(doc.exists==true) {
        _name = doc.data()['name'];
        _calorie = doc.data()['calorie'];
        _pro = doc.data()['protein'];
        _fat = doc.data()['fat'];
        _carb = doc.data()['carbohydrate'];
      }
    });

    setState(() {
      _scanBarcode = barcodeScanRes;
      _exit=exit;
    });
  }



}
class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}