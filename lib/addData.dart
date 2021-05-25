import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BarcodeDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class BarcodeDemo extends StatelessWidget {

  String value;
  BarcodeDemo({this.value});

  //final TextEditingController _txtBarcode = new TextEditingController();
  final TextEditingController _txtName = new TextEditingController();
  final TextEditingController _txtCalorie = new TextEditingController();
  final ref = FirebaseFirestore.instance.collection('barcode');
  String barcode="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: EdgeInsets.symmetric(horizontal:10,vertical:50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children:[
            Column(
                children: [
                  Text("條碼"+value,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  TextFormField(
                    controller: _txtName,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                    ),
                  ),
                  TextFormField(
                    controller: _txtCalorie,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]")),],
                    decoration: InputDecoration(
                      hintText: "Calorie",
                      hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: ()  async {
                      await ref.doc(value).set({'name':_txtName.text,'calorie':_txtCalorie.text})
                          .then((value) => {_txtName.clear(),_txtCalorie.clear()});
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add Data',
                      style: TextStyle(fontSize: 20),
                    ),),
                ]
            ),
          ],
        ),
      ),
    );
  }
}