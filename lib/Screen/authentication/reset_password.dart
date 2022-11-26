import 'dart:convert';

import 'package:drivaar/Screen/authentication/login_register.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController con_password = TextEditingController();

  String old_pass = '';
  String auth_key = '';

  checkPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      old_pass = (prefs.getString("password") ?? "");
      auth_key = (prefs.getString("auth_key") ?? "");
    });
  }

  Future<void> resetPassword() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/reset_password.php"),
            body: ({
              'auth_key': auth_key,
              'action': 'reset_password',
              'old_password': old_password.text,
              'new_password': new_password.text,
            }));
    var d = json.decode(response.body);
    var message = d['data']['success'];
    if (response.statusCode == 200) {
      // var s = json.decode(response.body);
      // profileData = s['data']['profile'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.remove("email");
        prefs.remove("password");
        prefs.remove("name");
        prefs.remove("contact");
        prefs.remove("country");
        prefs.remove("postcode");
        prefs.remove("address");
        prefs.remove("state");
        prefs.remove("city");
        prefs.remove("depot");
        prefs.remove("type");
        prefs.remove("auth_key");
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginRegister()));
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  @override
  initState() {
    super.initState();
    checkPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: app_color,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 10.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: TextField(
                controller: old_password,
                keyboardType: TextInputType.name,
                style: TextStyle(color: app_color),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  labelText: "Old Password",
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: app_color,
                    fontSize: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: app_color,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    //   borderSide: BorderSide(color: app_color),
                  ),
                  // disabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //     borderSide: BorderSide(color: app_color)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade500)),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 10.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: TextField(
                controller: new_password,
                keyboardType: TextInputType.name,
                // enabled: false,
                style: TextStyle(color: app_color),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  labelText: "New Password",
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: app_color,
                    fontSize: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: app_color,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // borderSide: BorderSide(color: app_color),
                  ),
                  // disabledBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(10),
                  // borderSide: BorderSide(color: app_color),
                  // ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade500)),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 10.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: TextField(
                controller: con_password,
                keyboardType: TextInputType.name,
                style: TextStyle(color: app_color),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  labelText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: app_color,
                    fontSize: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: app_color,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // borderSide: BorderSide(color: app_color),
                  ),
                  // disabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //     borderSide: BorderSide(color: app_color)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade500)),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                primary: app_color,
              ),
              onPressed: () async {
                if (old_password.text == "") {
                  Fluttertoast.showToast(msg: "Enter Old Password");
                } else if (new_password.text == "") {
                  Fluttertoast.showToast(msg: "Enter New Password");
                } else if (con_password.text == "") {
                  Fluttertoast.showToast(msg: "Enter Confirm Password");
                } else if (old_pass == old_password.text) {
                  if (new_password.text == con_password.text) {
                    resetPassword();
                  } else {
                    Fluttertoast.showToast(msg: "Password Not Match");
                  }
                } else {
                  Fluttertoast.showToast(msg: "Old Password Wrong");
                }
              },
              child: const Text("Reset Password"),
            ),
          ),
        ],
      ),
    );
  }
}
