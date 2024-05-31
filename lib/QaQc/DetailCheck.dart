
import 'dart:convert';

import 'package:finishedpart/finalinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Login.dart';
import '../barpage.dart';
import '../db_Handler.dart';

class QaQrDetails extends StatefulWidget {
  const QaQrDetails({super.key});

  @override
  State<QaQrDetails> createState() => _QaQrDetailsState();
}

class _QaQrDetailsState extends State<QaQrDetails> {
  var ScanValue;
  var barCodeValue;
  String? productName;
  String? manufacturing;
  String? manufacturingDimension;
  String? description;
  String? remark;
  var role;
  String? CheckByUser_production;
  String? CheckByUser_QA;
  String? production_mail;
  String? qc_mail;
  String? store_mail;
  var userCompanyID;
  String? username;
  var indexId;
  TextEditingController msg = TextEditingController();


  @override
  void initState() {
    super.initState();
    barCodeValue = Get.arguments['barcodeScanResult'];
    getvalue();
  }

  void getvalue() async {
    await dbHandler().fetchdataProduct(barCodeValue).then(
          (value) async{
            late SharedPreferences spgetrole;
            spgetrole = await SharedPreferences.getInstance();
        setState(() {
          print(value);
          role = spgetrole.getString('role');
          username=spgetrole.getString('');

          userCompanyID = spgetrole.getString('companyid');

          ScanValue = value;
          indexId =
          ScanValue != null ? ScanValue[0]['id'] ?? '' : '';
          productName =
          ScanValue != null ? ScanValue[0]['productName'] ?? '' : '';
          manufacturing =
          ScanValue != null ? ScanValue[0]['manufacturingPlant'] ?? '' : '';
          manufacturingDimension =
          ScanValue != null ? ScanValue[0]['productDimension'] ?? '' : '';
          description =
          ScanValue != null ? ScanValue[0]['Description'] ?? '' : ' ';
          remark = ScanValue != null ? ScanValue[0]['Review'] ?? '' : ' ';


          CheckByUser_production = ScanValue != null
              ? ScanValue[0]['ProductionCompanyId'] ?? ''
              : ' ';
          CheckByUser_QA = ScanValue != null
              ? ScanValue[0]['QaQcCompanyId'] ?? ''
              : ' ';

          getemailvalue();
        });
      },
    ).onError((error, stackTrace) {
      print(error);
    });
  }

  getemailvalue() async {


    await dbHandler().fetchUseremailData(CheckByUser_production,CheckByUser_QA,userCompanyID).then(
          (value) {
        print("inseide pdf");
        // print(value);
        print(value[0]['Email']);
        production_mail=value[0]['Email'].toString().trim();
        qc_mail=value[1]['Email'].toString().trim();
        store_mail=value[2]['Email'].toString().trim();
        print(value[1]['Email']);

      },
    ).onError((error, stackTrace) {
      print(error);
    });
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
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
        actions: [


          IconButton(
            onPressed: () async{
              Get.off(BarCodePage());
            },
            icon: Icon(Icons.qr_code_scanner_rounded,
            color: Colors.white,),
          ),
          IconButton(
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
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _buildProductInfo(),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text("Are you sure?"),
                            content: Text("Do you really want to reject?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No",
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                              ),
                              TextButton(
                                onPressed: () {

                                  Get.back();
                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text("Remark"),
                                      content: Container(
                                        height: 250,
                                        width: 250,
                                        child: TextField(
                                          controller: msg,
                                          maxLines: 10,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white60,
                                          ),
                                        ),

                                      ),
                                      actions: [
                                        TextButton(onPressed: (){

                                          storeRemark();
                                          getemailvalue();
                                          Send_mail();
                                          Get.back();
                                        },
                                            child: Text("Send",
                                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),)
                                      ],
                                    )
                                  );



                                },
                                child: Text("Yes",
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(120, 40),
                    ),
                  ),

                  ElevatedButton(onPressed: () async{
                    var status = "Approved";
                    if(role == 'QA/QC') {
                      await dbHandler().updateQId(
                        indexId,userCompanyID,status
                      ).then((value) {

                        // Handle the result if needed
                      }).onError((error, stackTrace) {
                        print(error);
                      });
                    }
                    else{
                      await dbHandler().updateSId(
                        indexId,userCompanyID,status
                      ).onError((error, stackTrace) {
                        print(error);
                      });
                    }

                    print(userCompanyID);
                    Get.to(FinalInfo(),arguments: {
                    'barocodevalue': barCodeValue
                    });
                  },
                      child: Text("Approve",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      minimumSize: Size(120, 40),)
                  ),


                ],
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black54, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem("Barcode No", barCodeValue),
          SizedBox(height: 12,),
          _buildInfoItem("Product Name", productName),
          SizedBox(height: 12,),
          _buildInfoItem("Manufacturing Plant", manufacturing), SizedBox(height: 12,),
          _buildInfoItem("Product Dimension", manufacturingDimension), SizedBox(height: 12,),
          SizedBox(height: 20),
          _buildInfoItem("Description", description),
          SizedBox(height: 20),
          _buildInfoItem("Review", remark),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value ?? '',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void storeRemark() async{
    var remark = msg.text.trim();
    var stat = "Rejected";
    if (role == 'QA/QC'){
      await dbHandler().updateQRemark(indexId, remark,stat,userCompanyID);
    }
    else{
      await dbHandler().updateSRemark(indexId, remark,stat,userCompanyID);
    }
  }
//storerRemark

  void Send_mail() {
    var Service_id = 'service_w62wg09',
        Template_id = 'template_r96fg7u',
        User_id = 'tGmuCzXaZmCIvTMzi';
    var s = http.post(Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
        'origin': 'http:localhost',
        'Content-Type': 'application/json'
        },

        body: jsonEncode({
        'service_id': 'service_w62wg09',
        'user_id': 'tGmuCzXaZmCIvTMzi',
        'template_id': 'template_r96fg7u',
        'template_params': {
    'from_name': role ,
          'by_name': role,
    'message': msg.text,
    'reply_to':'$production_mail',
    'sender_mail': '$production_mail',
    'Bcc': role == 'Store'?'$qc_mail':"",
    'from_companyId' : userCompanyID,
    'barId' :'$barCodeValue',
     'productname': '$productName'
    }
    }

        ));
  }

}
