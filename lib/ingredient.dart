import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Ingredient(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Ingredient extends StatefulWidget {
  @override
  _IngredientState createState() => _IngredientState();
}

class _IngredientState extends State<Ingredient> {
  final TextEditingController _txtName = new TextEditingController();
  final TextEditingController _txtNum = new TextEditingController();
  final TextEditingController _txtExp = new TextEditingController();
  final TextEditingController _txtClass = new TextEditingController();
  final ref = FirebaseFirestore.instance.collection('ingredient');
  String dropdownValue = '1';

  DateTime selectedDate=DateTime.now();
  DateTime selectedExp=DateTime.now();

  var _formKey = GlobalKey<FormState>();


  _selectExp() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: selectedExp,
        firstDate: DateTime(1990),
        lastDate: DateTime(2100)
    );

    if(date==null) return;

    setState(() {
      selectedExp=date;
      _txtExp
        ..text = DateFormat('yyyy-MM-dd').format(selectedExp)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _txtExp.text.length,
            affinity: TextAffinity.upstream));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  "食材管理" ,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    TextFormField(
                      controller: _txtName,
                      validator: (val)=>val.isEmpty?"名稱不得空白":null,
                      decoration: InputDecoration(
                          hintText: "請輸入名稱",
                          hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                          labelText: "名稱",
                          labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                          border:  UnderlineInputBorder(),
                          filled: true),
                      maxLength: 15,
                    ),
                    TextFormField(
                      controller: _txtNum,
                      validator: (val)=>val.isEmpty?"數量不得空白":null,
                      decoration: InputDecoration(
                          hintText: "請輸入數量",
                          hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                          labelText: "數量",
                          labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                          border:  UnderlineInputBorder(),
                          filled: true),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _txtExp,
                      readOnly: true,
                      validator: (val)=>val.isEmpty?"有效日期不得空白":null,
                      decoration: InputDecoration(
                          hintText: "請輸入有效日期",
                          hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                          labelText: "有效日期",
                          labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                          border:  UnderlineInputBorder(),
                          filled: true),
                      onTap: _selectExp,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "類別",
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                        DropdownButton(
                          value: dropdownValue,
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['1', '2', '3', '4']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  ]),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      await ref.doc('userdata').collection('a@gmail.com').add(
                          {'name': _txtName.text, 'num': _txtNum.text,"exp":_txtExp.text,"class":dropdownValue})
                          .then((value) =>
                      {
                        _txtName.clear(),
                        _txtNum.clear(),
                        _txtExp.clear()
                      });
                    }
                  },
                  child: Text(
                    'Add Data',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
