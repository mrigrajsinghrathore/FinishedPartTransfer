//////bar page

import 'package:finishedpart/ModelClass/db_model_addinfo.dart';
import 'package:finishedpart/QaQc/DetailCheck.dart';
import 'package:finishedpart/db_Handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:finishedpart/checkinfo.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class BarCodePage extends StatefulWidget {
  const BarCodePage({super.key});

  @override
  State<BarCodePage> createState() => _BarCodePageState();
}

class _BarCodePageState extends State<BarCodePage> {
  var barcode = "";

  bool canProceed = false;
  bool isLoading = false;
  var RoleName;

  var CompanyId;
  var productDetails;
  var barcodevalue;


  Future<void> _scanBarcode() async {
    var barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    if (!mounted) return;

    setState(() {
      barcode = barcodeScanResult;
      canProceed = true;
      if (barcode == "-1") {
        barcode = "";
      }
    });
  }

  Future<void> fetchuserId() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    CompanyId = sharedPref.getString('companyid');
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + CompanyId);
    RoleName = sharedPref.getString('role');
    print("AAAAAAAAAAAAAAAAAASSSSSSSSSSSEEEEEEEEEEEE" + RoleName);
  }

  late SharedPreferences spget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchuserId();
  }


  // void initState() {
  //   super.initState();
  //   RoleName = Get.arguments['valueChoose'];
  //   CompanyId = Get.arguments['companyId'];
  //
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Barcode Scanner',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.cyan, Colors.cyanAccent],
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [IconButton(
            onPressed: () async {
              late SharedPreferences spget;
              spget = await SharedPreferences.getInstance();
              spget.setBool('login_flag', true);

              Get.offAll(LoginPage());
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ))
        ],
      ),

      body: Container(
        //     decoration: BoxDecoration(
        //
        //         image: DecorationImage(image: AssetImage("assets/images/process.png"),
        //             fit: BoxFit.fill,
        // colorFilter: ColorFilter.mode(
        // Colors.white.withOpacity(0.3), // Adjust opacity here (0.0 - fully transparent, 1.0 - fully opaque)
        // BlendMode.dstATop,)
        //         ),
        //     ),
        child: Container(


          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Lottie.asset('assets/Animation/ScanAnim.json',
                    height: 200,
                    repeat: true
                ),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:  Colors.transparent,
                  ),
                  child: Text(
                    barcode ,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),

                    // style: TextStyle(fontSize: 30.0),
                  ),
                ),

                // SizedBox(height: 20.0),
                Container(
                    width: 300,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.cyanAccent.shade100,
                    ),
                  child:TextButton(onPressed: (){
                    _scanBarcode();
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent.shade100,
                        elevation: 5,


                        // padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Scan Barcode",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),))
                ),




                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [

                    Container(
                      margin: EdgeInsets.only(right: 50),
                      child: FloatingActionButton(
                        onPressed: canProceed && !isLoading ? () {
                          setState(() {
                            isLoading = true;
                          });

                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              isLoading = false;
                            });
                            next();
                          });
                        } : null,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (!isLoading)
                              Icon(Icons.arrow_forward, color: Colors.white),
                            if (isLoading)
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                          ],
                        ),
                        backgroundColor: Colors.cyanAccent,
                      ),
                    ),
                  ],
                ),

                // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void next() async {
    var barcodevalue;
    var response = await dbHandler().CheckBar(dbModelAddInformation(
      barCodeNo: barcode,



    )).then((value) {
      print(value);


      barcodevalue = value[0]['barCodeNo'];
      productDetails = value[0]['Description'];
      print(productDetails+'kjnskkskbskfbskbkbs');


      if (barcode == barcodevalue) {
        print(RoleName);

        if (RoleName != 'Production' && productDetails == '') {
          Get.dialog(
            AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Unauthorized Access',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              content: Text('This barcode is not authorized for you yet'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('OK',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),),
                ),

              ],
            ),
          );
          print("indside if");
        }
        else {
          if (RoleName == 'Production') {
            Get.off(CheckInfo(),
                arguments: {"barcodeScanResult": barcode});
          }

          else {
            Get.off(QaQrDetails(),
                arguments: {"barcodeScanResult": barcode});
          }
        }
      }
      }).onError((error, stackTrace) {
      print(barcodevalue);
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Barcode Not Found'),
          content: Text('The scanned barcode is not found in the database.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),),
            ),

          ],
        ),
      );
    });






  }
}
