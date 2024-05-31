import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finishedpart/barpage.dart';
import 'package:finishedpart/createuser.dart';
import 'package:finishedpart/db_Handler.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ModelClass/db_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController companyIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false; // Track loading state
  String checkUserType = '';
  String? valueChoose;
  String? companyidUser;
  var newuser;
  var listItem = ["Production", "QA/QC", "Store"];
  late SharedPreferences sharedPref;
  void initState() {
    super.initState();
    check_value_login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.cyanAccent),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(65),
                    topRight: Radius.circular(65),
                  ),
                ),
                margin: EdgeInsets.only(top: 140),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/Animation/LoginPer.json',
                        height: 200,
                        repeat: true,
                      ),
                      Container(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      SizedBox(height: 17,),
                      Container(

                        width: double.infinity,
                        padding: EdgeInsets.only(left: 12, right: 12),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.cyanAccent.withOpacity(0.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            padding: EdgeInsets.only(left: 28),

                            // Initial Value
                            value: valueChoose,
                            dropdownColor: Colors.cyanAccent.withOpacity(0.4),
                            hint: Text("Select Role",),
                            // Array list of items
                            items: listItem.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text(
                                    items,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (newValue) {
                              setState(() {
                                valueChoose = newValue;
                                print(valueChoose);
                              });
                            },
                          ),
                        ),
                      ),
                      buildTextField(companyIdController, Icons.build, "Company Id"),
                      buildTextField(userIdController, Icons.person, "Username"),
                      buildPasswordField(passwordController),
                      SizedBox(height: 25),
                      Container(
                        width: 300,
                        margin: EdgeInsets.only(bottom: 100),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () async { // Disable button when loading
                            var companyid = companyIdController.text.trim();
                            var username = userIdController.text.trim();
                            var password = passwordController.text.trim();
                            checkUserType = companyIdController.text.trim();
                            companyidUser = companyid;
                            if (companyid.isEmpty || username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please fill all fields'),),
                              );
                            } else {
                              setState(() {
                                isLoading = true; // Start loading
                              });
                              await Future.delayed(Duration(seconds: 3));
                              await login();
                              setState(() {
                                isLoading = false; // Stop loading
                              });
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            minimumSize: Size(150, 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white) ), // Loader
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, IconData icon, String hintText) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.cyanAccent.withOpacity(0.5),
      ),
      child: TextField(
        style: TextStyle(fontWeight: FontWeight.bold),
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white,),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget buildPasswordField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.cyanAccent.withOpacity(0.5),
      ),
      child: TextFormField(
        style: TextStyle(fontWeight: FontWeight.bold),
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "password is required";
          }
          return null;
        },
        obscureText: !isVisible,
        decoration: InputDecoration(
          icon: const Icon(Icons.lock, color: Colors.white,),
          border: InputBorder.none,
          hintText: "Password",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off), color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    var response = await dbHandler().getUserAuth(
      dbModel(
          companyId: companyIdController.text,
          username: userIdController.text,
          password: passwordController.text,
          role: valueChoose
      ),
    );

    if (response == true) {
      if (checkUserType == '0000' ) {
        Get.to(CreateUser());
        print("Testing");
      }
      // else if(valueChoose == 'QA/QC'){
      //   RoleCheck();
      // }
      else {
        sharedPref.setBool("login_flag", false);
        sharedPref.setString('companyid', companyIdController.text);
        sharedPref.setString("role", valueChoose.toString());

        Get.off(BarCodePage(), );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text("Invalid company ID, username, or password.",
          style: TextStyle(color: Colors.red),),
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
    }
  }
  void check_value_login() async {
    sharedPref = await SharedPreferences.getInstance();
    newuser = (sharedPref.getBool('login_flag') ?? true);
    if (newuser == false) {
      Get.off(() => BarCodePage());
    }
  }



}
