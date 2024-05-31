
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finishedpart/db_Handler.dart';
import 'package:finishedpart/ModelClass/db_model_addinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'db_Handler.dart';

class AddBarDetails extends StatefulWidget {
  const AddBarDetails({super.key});

  @override
  State<AddBarDetails> createState() => _AddBarDetailsState();
}

class _AddBarDetailsState extends State<AddBarDetails> {
  var barcodeno = Get.arguments[0]['barcodeScanResult'];
  TextEditingController ProductName = TextEditingController();
  TextEditingController ManufacturingPlant = TextEditingController();
  TextEditingController ProductDiminsion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,backgroundColor: Colors.cyanAccent,
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: barcodeno),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Barcode No"
                ),

              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: ProductName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Product Name"
                ),

              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: ManufacturingPlant,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Manufacturing Plant"
                ),

              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller:  ProductDiminsion,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Product Diminsion"
                ),

              ),
            ),
            ElevatedButton(onPressed: () async{
              await dbHandler()..insertData(dbModelAddInformation(
                  barCodeNo: barcodeno.trim(),
                  productName: ProductName.text.trim(),
                  manufacturingPlant:
                  ManufacturingPlant.text.trim(),
                  productDimension: ProductDiminsion.text.trim(),
                  Description: "",
                  Review: "",
                 ProductionCompanyId:"" ,
                QaQcRemark: "",
                QaQcStatus: "",
                QaQcCompanyId: "",
                StoreRemark: "",
                StoreStatus: "",
                StoreCompanyId: "",

              ))
                  .then((value) => {print("Inserted")})
                  .onError((error, stackTrace) => {print('$error')});
            },
                child: Text("Save"))
          ],
        ),
      ),
    );
  }
}
