import 'dart:async';
import 'dart:convert';

import 'package:drivaar/Screen/authentication/forget_password.dart';
import 'package:drivaar/Screen/home_page.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool login_screen = true;
  bool init = true;
  List profileData = [];

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  int activeStep = 0;

  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: AppBar(
        toolbarHeight: 160,
        backgroundColor: app_color,
        title: Center(
          child: Column(
            children: [
              Image.asset(
                "images/fulllogo.png",
                width: 250,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.5,
            ),
            width: double.infinity,
            child: Image(
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.grey.shade300,
              image: AssetImage('images/logo.png'),
            ),
          ),
          loginPage(),
        ],
      )),
    );
  }

  Widget loginPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 5),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Email",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              // textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 5),
          child: Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
              controller: email,
              // autofocus: true,
              // enabled: _enable,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                // labelText: "Enter Name",
                hintText: "Enter Email",
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  // borderSide: BorderSide(color: Colors.grey.shade500)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0)),
                // disabledBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: BorderSide(color: app_color)),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              // textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 30),
          child: Container(
              alignment: Alignment.centerLeft,
              // width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: password,
                      // autofocus: true,
                      // enabled: _enable,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        // labelText: "Enter Name",
                        hintText: "Enter Password",
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        // suffix: InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       _isHidden = !_isHidden;
                        //     });
                        //   },
                        //   child: Padding(
                        //     padding: EdgeInsets.only(top: 0),
                        //     child: Icon(
                        //       _isHidden ? Icons.visibility : Icons.visibility_off,
                        //       color: app_color,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),

                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // borderSide: BorderSide(color: Colors.grey.shade500)
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0.0)),
                        // disabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //     borderSide: BorderSide(color: app_color)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isHidden = !_isHidden;
                      });
                    },
                    icon: Icon(
                      _isHidden ? Icons.visibility : Icons.visibility_off,
                      color: app_color,
                      size: 30,
                    ),
                  ),
                ],
              )),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 40),
            primary: app_color,
          ),
          onPressed: () {
            login();
          },
          child: const Text(
            "Sign In",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgetPassword()));
            },
            child: Text(
              "Forget Password? Click Here",
              style: TextStyle(color: app_color),
            ),
          ),
        ),
      ],
      // ),
    );
  }

  Widget registerPage() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 5),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "CONTRACTOR REGISTRATION",
                style: TextStyle(
                    color: app_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
            NumberStepper(
                numbers: const [
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                ],
                activeStep: activeStep,
                stepRadius: 16,
                lineLength: 20,
                enableNextPreviousButtons: false,
                activeStepBorderWidth: 0,
                activeStepBorderPadding: 0,
                numberStyle: const TextStyle(color: Colors.white),
                activeStepColor: app_color,
                activeStepBorderColor: app_color),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                primary: app_color,
              ),
              onPressed: () {
                setState(() {
                  if (activeStep <= 6) {
                    activeStep++;
                  }
                });
              },
              child: const Text(
                "CONTINUE",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    if (password.text.isNotEmpty && email.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("https://www.drivaar.com/api/login.php"),
          body: ({'id': email.text, 'password': password.text}));
      var s = json.decode(response.body);
      var ss = s['status'];
      var status = 1;
      if (response.statusCode == 200 && status == ss) {
        var s = json.decode(response.body);
        // profileData = s['data']['profile'];
        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);
        // addData();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("email", email.text.toLowerCase());
        prefs.setString("password", password.text);
        prefs.setString("name", s['data']['profile']['name']);
        // prefs.setString("contact", s['data']['profile']['contact']);
        // prefs.setString("address", s['data']['profile']['address']);
        // prefs.setString("postcode", s['data']['profile']['postcode']);
        // prefs.setString("state", s['data']['profile']['state']);
        // prefs.setString("city", s['data']['profile']['city']);
        // prefs.setString("country", s['data']['profile']['country']);
        // prefs.setString("depot", s['data']['profile']['depot']);
        // prefs.setString("type", s['data']['profile']['type']);
        prefs.setString("auth_key", s['key']['auth_key']);
        global_auth_key = s['key']['auth_key'];
        global_name = s['data']['profile']['name'];
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      auth_key: global_auth_key,
                      name: global_name,
                    )));
      } else {
        var s = json.decode(response.body);
        var ss = s['data']['error'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ss)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Blank field Not Allowed")));
    }
  }

  // addData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("email", email.text.toLowerCase());
  //   prefs.setString("password", password.text);
  // }
}
