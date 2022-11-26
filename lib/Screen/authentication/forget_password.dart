import 'dart:convert';

import 'package:drivaar/Screen/authentication/login_register.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController forget_password_email = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController con_password = TextEditingController();
  bool email = true;
  String receive_otp = '';

  Future<void> forgetPasswordEmail() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/forget_password.php"),
            body: ({
              'action': 'forget_password',
              'email': forget_password_email.text,
            }));
    var d = json.decode(response.body);
    var message = d['data']['success'];
    if (response.statusCode == 200 && d['status'] == 1) {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => const LoginRegister()));
      setState(() {
        receive_otp = d['data']['otp'];
        email = false;
        // print(receive_otp);
      });

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    } else {
      Fluttertoast.showToast(
          msg: "Enter Wrong Email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<void> forgetPasswordOtp() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/forgetpassword_set.php"),
            body: ({
              'new_password': new_password.text,
              'email': forget_password_email.text,
              'isotp': "1",
            }));
    var d = json.decode(response.body);
    var message = d['data']['success'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginRegister()));

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
          Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
        backgroundColor: app_color,
      ),
      body: email == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 5),
                  child: TextField(
                    controller: forget_password_email,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: app_color),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      labelText: "Enter Email",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: app_color,
                        fontSize: 16.0,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: app_color,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: app_color),
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 5, right: 20, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      primary: app_color,
                    ),
                    onPressed: () async {
                      if (forget_password_email.text == "") {
                        Fluttertoast.showToast(msg: "Enter Email");
                      } else {
                        forgetPasswordEmail();
                      }
                    },
                    child: const Text("Send OTP"),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 5, right: 20, bottom: 5),
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
                        borderSide: BorderSide(color: app_color),
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 5, right: 20, bottom: 10),
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
                        borderSide: BorderSide(color: app_color),
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 5),
                  child: TextField(
                    controller: otp,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: app_color),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      labelText: "Enter OTP",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: app_color,
                        fontSize: 16.0,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: app_color,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: app_color),
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: app_color)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 5, right: 20, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      primary: app_color,
                    ),
                    onPressed: () async {
                      if (new_password.text == "") {
                        Fluttertoast.showToast(msg: "Enter New Password");
                      } else if (con_password.text == "") {
                        Fluttertoast.showToast(msg: "Enter Confirm Password");
                      } else if (otp.text == "") {
                        Fluttertoast.showToast(msg: "Enter Otp");
                      } else if (new_password.text == con_password.text) {
                        if (receive_otp == otp.text) {
                          forgetPasswordOtp();
                        } else {
                          Fluttertoast.showToast(msg: 'Incorrect Otp');
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'Password Not Match');
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
    );
  }
}
