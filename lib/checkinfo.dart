import 'package:finishedpart/QaQc/DetailCheck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finishedpart/finalinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'db_Handler.dart';

class CheckInfo extends StatefulWidget {
  const CheckInfo({Key? key});

  @override
  State<CheckInfo> createState() => _CheckInfoState();
}

class _CheckInfoState extends State<CheckInfo> {
  var ScanValue;
  bool isLoading = false;
  var companyId;
  late var barCodeValue;
  TextEditingController? productNameController;
  TextEditingController? manufacturingController;
  TextEditingController? productDimensionController;
  TextEditingController? descriptionController;
  TextEditingController? remarkController;
  var updateId;
  var ProId;
  var roleName;
  var userCompanyID;



  @override
  void initState() {
    super.initState();
    // ("dxfgchvjbkl"+companyId);
    barCodeValue = Get.arguments['barcodeScanResult'];
    // companyId = Get.arguments['companyId1'];
    getvalue();
  }
  checkuserid()async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    userCompanyID = sharedPref.getString('companyid');
  }

  void getvalue() async {
    await dbHandler().fetchdataProduct(barCodeValue).then(
          (value) {

        setState(() {
          checkuserid();


          ScanValue = value;
          updateId = ScanValue != null ? ScanValue[0]['id'] ?? '' : '';
          productNameController = TextEditingController(
              text: ScanValue != null ? ScanValue[0]['productName'] ?? '' : '');
          manufacturingController = TextEditingController(
              text: ScanValue != null ? ScanValue[0]['manufacturingPlant'] ?? '' : '');
          productDimensionController = TextEditingController(
              text: ScanValue != null ? ScanValue[0]['productDimension'] ?? '' : '');
          descriptionController = TextEditingController(
              text: ScanValue != null ? ScanValue[0]['Description'] ?? '' : '');
          remarkController = TextEditingController(
              text: ScanValue != null ? ScanValue[0]['Review'] ?? '' : '');
          companyId = ScanValue != null ? ScanValue[0]['ProductionCompanyId'] ?? '' : '';
        });
      },
    ).onError((error, stackTrace) {
      print(error);
    });
  }
  @override
  Future<void> fetchRole() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    roleName = sharedPref.getString('role');
    print("WWWWWWWWWWWWWWWWW   "+roleName);

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
            ))],
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              // Row(
              //    crossAxisAlignment: CrossAxisAlignment.start,
              //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildInfoItem("Barcode No", barCodeValue),
              //     _buildInfoItem("Product Name", productNameController!.text),
              //   ],
              // ),

              _buildInfoItem("Barcode No", barCodeValue),
              _buildInfoItem("Product Name", productNameController!.text),
              _buildInfoItem("Manufacturing Plant", manufacturingController!.text),
              _buildInfoItem("Manufacturing Dimension", productDimensionController!.text),
              // SizedBox(height: 20),
              _buildEditableItem("Description", descriptionController!),
              _buildEditableItem("Remark", remarkController!),

              ElevatedButton(
                onPressed: !isLoading ? () async {
                  setState(() {
                    isLoading = true; // Set loading state to true when button is pressed
                  });

                  // Simulate loading for 1 second
                  await Future.delayed(Duration(seconds: 1));

                  if (descriptionController != null && remarkController != null) {
                    await dbHandler().updataproduct(
                      updateId,
                      descriptionController!.text,
                      remarkController!.text,
                        userCompanyID,
                    ).then((value) {
                      // Handle the result if needed
                    });
                  }

                  Get.off(FinalInfo(

                  ), arguments: {
                    'barocodevalue': barCodeValue,
                    'companyId2':companyId
                  });

                  setState(() {
                    isLoading = false; // Set loading state to false after 1 second
                  });
                } : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: isLoading ? Colors.transparent : Colors.black,
                  backgroundColor: Colors.cyanAccent.shade400,
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isLoading) // Show text if isLoading is false
                      Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    if (isLoading)
                      // Show loader if isLoading is true
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54, width: 3),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),

        )

      ],
    );
  }

  Widget _buildEditableItem(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54, width: 3),
          ),
          child:   TextField(
            controller: controller,
            maxLines: label == "Description" ? 3 : 1,
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
        )
      ],
    );
  }
}