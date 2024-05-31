
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import 'addbardetails.dart';

class AdBar extends StatefulWidget {
  const AdBar({super.key});

  @override
  State<AdBar> createState() => _AdBarState();
}

class _AdBarState extends State<AdBar> {
  @override
  var _barcode = 'Scan ';

  Future<void> _scanBarcode() async {
    var barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    if (!mounted) return;

    setState(() {
      _barcode = barcodeScanResult;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,backgroundColor: Colors.cyanAccent,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Text(
                  _barcode
              ),
            ),
            Container(
              child: ElevatedButton(onPressed: () async{
                _scanBarcode();
              }, child: Text("Scan")),
            ),
            ElevatedButton(onPressed: () async{
              Get.to(AddBarDetails(),arguments: [{"barcodeScanResult":'$_barcode'}]);
            }, child: Text("Add Details")
            )
          ],
        ),
      ),
    );
  }
}
