import 'dart:async';

import 'package:drivaar/Screen/home_page.dart';
import 'package:drivaar/Screen/splash/get_start.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('email');
    String? stringValue1 = prefs.getString('password');
    String? auth_key = prefs.getString("auth_key");
    String? name = prefs.getString("name");
    bool? clock_in = prefs.getBool("ClockIn");
    String? inTime = prefs.getString("InTime");
    String? outTime = prefs.getString('OutTime');
    String? inDate = prefs.getString("InDate");
    String? outDate = prefs.getString('OutDate');
    if (stringValue != null && stringValue1 != null) {
      setState(() {
        global_auth_key = auth_key.toString();
        global_name = name.toString();
        clock_in == null ? isClockIn = false : isClockIn = clock_in;
        inTime == null &&
                (inDate == null ||
                    inDate != DateFormat("dd-MM-yyyy").format(DateTime.now()))
            ? InTime = "--.--"
            : InTime = inTime.toString();
        outTime == null &&
                (outDate == null ||
                    outDate != DateFormat("dd-MM-yyyy").format(DateTime.now()))
            ? OutTime = "--.--"
            : OutTime = outTime.toString();
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    auth_key: auth_key.toString(),
                    name: name.toString(),
                  )));
    } else {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => const LoginRegister()));
      isClockIn = false;
      InTime = "--.--";
      OutTime = "--.--";
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const GetStart()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: double.infinity,
        width: double.infinity,
        child: const Image(
          image: AssetImage('images/splash.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
