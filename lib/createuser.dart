
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finishedpart/adminbarcode.dart';

import 'ModelClass/db_model.dart';
import 'db_Handler.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController companyIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController UserName = TextEditingController();
  var value;
  String ? valueChoose;
  var listItem = ["Admin","Production","QA/QC","Store"];
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 12,right: 12),
              margin: EdgeInsets.only(left: 8, right: 8),
              color: Colors.cyanAccent.withOpacity(0.5),

              child: DropdownButton(
                padding: EdgeInsets.only(left: 20),
                // Initial Value
                value: valueChoose,

                hint: Text("Select Role"),


                // Down Arrow Icon
                // icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: listItem.map((String items) {
                  return DropdownMenuItem(
                    value: items,

                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (newValue) {
                  setState(() {
                    valueChoose=newValue;
                    print(valueChoose);
                  });
                },
              ),
            ),

            SizedBox(height: 15,),
            TextField(
              controller: UserName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name"
              ),
            ),
            SizedBox(height: 15,),

            SizedBox(height: 15,),
            TextField(
              controller: companyIdController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "CompanyId"
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username"
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "password"
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: EmailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email"
              ),
            ),
            SizedBox(height: 15,),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: ()async {
                  await dbHandler()
                      .insertUserInfomation(dbModel(
                    Name: UserName.text.trim(),
                    companyId:companyIdController.text.trim(),
                    username:userIdController.text.trim(),
                    password:passwordController.text.trim(),
                    role: valueChoose,
                    Email: EmailController.text.trim(),
                  ))
                      .then((value) => {print("Inserted")})
                      .onError((error, stackTrace) => {print('$error')});
                }, child: Text("Save")),
                ElevatedButton(onPressed: () async{
                  Get.to(AdBar());
                }, child: Text("Scan Barcode"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
