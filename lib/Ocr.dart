import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'ScanResult.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(ocr());
// }


class MyApp extends StatelessWidget {

  // String value;
  // ocr({this.value});
  static final String title = 'Firebase OCR';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.green),
    home: Ocr(),
  );
}
class Ocr extends StatefulWidget {

  String value;
  Ocr({this.value});

  @override
  _OcrState createState() => _OcrState(this.value);
}

class _OcrState extends State<Ocr> {

  String value;
  _OcrState(this.value);

  int isnum=0;//是否已讀經過大卡
  String all,pack,kcal,pro,fat,fat1,fat2,carb,na;//營養標示
  String temp="";//暫存數字
  String result="";
  File image;
  ImagePicker imagePicker;
  File _selectedFile;
  bool _inProcess = false;

  final TextEditingController _txtName = new TextEditingController();
  final TextEditingController _txtAll = new TextEditingController();
  final TextEditingController _txtPack = new TextEditingController();
  final TextEditingController _txtKcal = new TextEditingController();
  final TextEditingController _txtPro = new TextEditingController();
  final TextEditingController _txtFat = new TextEditingController();
  final TextEditingController _txtCarb = new TextEditingController();
  final ref = FirebaseFirestore.instance.collection('barcode');


  int gnum1=2,gnum2=5;//gnum1=大卡以上公克數量 gnum2=大卡以下公克數量


  getImage(ImageSource source) async {
    this.setState((){
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
              ratioX: 1, ratioY: 1),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            //  CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPreset.ratio16x9
          ],
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.original,
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          )
      );

      this.setState((){
        _selectedFile = cropped;
        _inProcess = false;
        performImageLabeling();
      });
    } else {
      this.setState((){
        _inProcess = false;
      });
    }
  }

  performImageLabeling()async
  {
    final FirebaseVisionImage firebaseVisionImage=FirebaseVisionImage.fromFile( _selectedFile);
    final TextRecognizer recognizer = FirebaseVision.instance.cloudTextRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result ="";gnum1=2;gnum2=5;temp="";isnum=0;
    all="";pack="";kcal="";pro="";fat="";fat1="";fat2="";carb="";na="";
    setState(() {
      for(TextBlock block in visionText.blocks)
      {
        final String txt=block.text;//有很多文字block

        for(TextLine line in block.lines)//讀出每個block的每個line
            {
          isnum=0;
          for(TextElement element in line.elements)//讀出每個line的每個element(字)
              {
            if(element.text.contains(new RegExp(r'[0-9]'))) {//如果字裡有數字的話
              temp = element.text; //把數字加到temp裡
              isnum=1;
            }
          }
          if(line.text.contains('大卡')) {
            //Kcal= true;
            gnum1=0;
            kcal=temp;
            result+="熱量:"+kcal;
          }
          else if(isnum==1&&gnum1==2){
            all=temp;
            gnum1-=1;
            result+="每一份量:"+all;
          }
          else if(isnum==1&&gnum1==1){
            pack=temp;
            gnum1-=1;
            result+="本包裝含:"+pack+"份";
          }
          else if(isnum==1&&gnum2==5){
            pro=temp;
            gnum2-=1;
            result+="蛋白質:"+pro;
          }
          else if(isnum==1&&gnum2==4){
            fat=temp;
            gnum2-=1;
            result+="脂肪:"+fat;
          }
          else if(isnum==1&&gnum2==3){
            fat1=temp;
            gnum2-=1;
            result+="飽和脂肪:"+fat1;
          }
          else if(isnum==1&&gnum2==2){
            fat2=temp;
            gnum2-=1;
            result+="反式脂肪:"+fat2;
          }
          else if(isnum==1&&gnum2==1){
            carb=temp;
            gnum2-=1;
            result+="碳水化合物:"+carb;
          }
          else if(line.text.contains('毫克')&&gnum2==0) {
            gnum2-=1;
            na=temp;
            result+="鈉:"+na;
          }

          result += "\n";//每一line換行
        }
        result += "\n";//每一block換行
      }
    });

  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage(''), fit: BoxFit.cover),//放APP的背景圖
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20,),
              child: Column(
                  children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            '選擇照片',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: (){
                            getImage(ImageSource.gallery);
                          },//按一下相簿選圖片
                        ),
                        Padding(padding: EdgeInsets.only(
                          right: 20.0,
                        )),
                        ElevatedButton(
                          child: Text(
                            '開啟相機',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: (){
                            getImage(ImageSource.camera);
                          },//按一下相簿選圖片
                        ),
                      ],),
                  ],),
            ),
            //show result
            SizedBox(height: 8,),
            Text("條碼"+value,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            Column(
              children:[
                TextFormField(
                  
                  controller: _txtName,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  keyboardType: TextInputType.text,
                  // validator: (String value) {
                  //   if (value.isEmpty) {
                  //     return 'Password is Required';
                  //   }
                  //   return null;
                  // },
                  decoration: InputDecoration(
                    labelText: "品名",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: _txtAll..text=all,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "每一份量(公克/毫升)",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: _txtPack..text=pack,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "本包裝含(份)",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: _txtKcal..text=kcal,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "熱量(Kcal)",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: _txtPro..text=pro,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "蛋白質(g)",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                TextField(
                  controller: _txtFat..text=fat,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "脂肪(g)",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                // TextField(
                //   controller: TextEditingController()..text=fat1,
                //   decoration: InputDecoration(
                //     labelText: "飽和脂肪(g)",
                //   ),
                // ),
                // TextField(
                //   controller: TextEditingController()..text=fat2,
                //   decoration: InputDecoration(
                //     labelText: "反式脂肪(g)",
                //   ),
                // ),
                TextField(
                  controller: _txtCarb..text=carb,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "碳水化合物(g)",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                // TextField(
                //   controller: TextEditingController()..text=na,
                //   decoration: InputDecoration(
                //     labelText: "鈉(g)",
                //   ),
                // ),
              ]),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.only(left: 20,right: 20),
                  child: ElevatedButton(
                    child: Text(
                      '送出',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      await ref.doc(value).set
                        ({'name':_txtName.text,
                          'perpack':_txtAll.text,
                          'packnum':_txtPack.text,
                          'calorie':_txtKcal.text,
                          'protein':_txtPro.text,
                          'fat':_txtFat.text,
                          'carbohydrate':_txtCarb.text})
                          .then((value) => {
                            _txtName.clear(),_txtAll.clear(),_txtPack.clear(),
                            _txtKcal.clear(),_txtPro.clear(),_txtFat.clear(),_txtCarb.clear()});
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ScanResult(value: value)),);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
