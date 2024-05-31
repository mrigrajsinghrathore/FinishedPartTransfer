import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finishedpart/barpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'db_Handler.dart';

class FinalInfo extends StatefulWidget {
  const FinalInfo({Key? key});

  @override
  State<FinalInfo> createState() => _FinalInfoState();
}

class _FinalInfoState extends State<FinalInfo> {
  var ScanValue;
  late var barCodeValue;
  String? productName;
  String? manufacturing;
  String? manufacturingDimension;
  String? description;
  String? remark;
  var  CId;

  @override
  void initState() {
    super.initState();
    barCodeValue = Get.arguments['barocodevalue'];
    // CId=Get.arguments['companyId2'];
    print("dfkjl");
    getvalue();
  }

  void getvalue() async {
    await dbHandler().fetchdataProduct(barCodeValue).then(
          (value) {
        setState(() {
          ScanValue = value;

          productName =
          ScanValue != null ? ScanValue[0]['productName'] ?? '' : '';
          manufacturing =
          ScanValue != null ? ScanValue[0]['manufacturingPlant'] ?? '' : '';
          manufacturingDimension =
          ScanValue != null ? ScanValue[0]['productDimension'] ?? '' : '';
          description =
          ScanValue != null ? ScanValue[0]['Description'] ?? '' : ' ';
          remark = ScanValue != null ? ScanValue[0]['Review'] ?? '' : ' ';
          CId = ScanValue != null ? ScanValue[0]['ProductionCompanyId'] ?? '' : ' ';
          print("dsfsghjkljhgcfxgvbhnjkmljhgfhjkljhgfgchjkl"+CId);


        });

      },

    ).onError((error, stackTrace) {
      print(error);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Get.to(BarCodePage());
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
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _buildProductInfo(),

              Container(
                child: Text(""),
              )
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
          SizedBox(height: 20),

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

}