import 'dart:async';
import 'dart:convert';

import 'package:drivaar/Screen/accident/add_accident_report.dart';
import 'package:drivaar/Screen/attendance.dart';
import 'package:drivaar/Screen/authentication/login_register.dart';
import 'package:drivaar/Screen/documents/document.dart';
import 'package:drivaar/Screen/inspection/inspection_question.dart';
import 'package:drivaar/Screen/invoice/invoice_tab.dart';
import 'package:drivaar/Screen/leave/leave_list.dart';
import 'package:drivaar/Screen/profile.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feedback/feedback.dart';
import 'offences/offences_list.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String auth_key = "";
  String name = '';
  HomePage({Key? key, required this.auth_key, required this.name})
      : super(key: key);

  @override
  State<HomePage> createState() =>
      HomePageState(auth_key: auth_key, name: name);
}

class HomePageState extends State<HomePage> {
  String auth_key = "";
  String name = '';
  HomePageState({required this.auth_key, required this.name});
  var get_data = [];

  String currentTime = '';

  @override
  void initState() {
    getQuestion();
    getProfile();
    // getId();
    super.initState();
    print(auth_key);
    // print(name);
    global_auth_key = auth_key;
    global_name = name;
    // print(global_auth_key);
    // print(global_name);
    // print(isClockIn);
    // print(DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now()));
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getTime() {
    final String formattedDateTime =
        DateFormat('hh:mm:ss a ').format(DateTime.now()).toString();
    setState(() {
      currentTime = formattedDateTime;
      // print(currentTime);
    });
  }

  Future<String?> getQuestion() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/inspection.php"),
            body: ({
              "action": "inspection",
              "auth_key": auth_key,
            }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['error'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      global_question = convert_data_to_json['data']['inspection_status'];
      setState(() {
        // print(global_question);
        // print(global_question.length);
      });
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<String?> getProfile() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/list_profile.php"),
        body: ({
          "action": "list_profile",
          "auth_key": auth_key,
        }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    // print(message);/
    if (response.statusCode == 200) {
      setState(() {
        global_profile_data = convert_data_to_json['data']['data'];
        global_profile_image = global_profile_data[0]['profile'];
        // print(global_profile_data);
        // print(auth_key);
      });
    }
  }

  Future<void> clockIn() async {
    String time = DateFormat("hh:mm a").format(DateTime.now());
    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/clockIn.php"),
        body: ({
          'auth_key': auth_key,
          'action': 'clockin',
          'starts': time,
          'description': ""
        }));
    var d = json.decode(response.body);
    // var message = d['data']['error'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Fluttertoast.showToast(
          msg: d['data']['clockin_status']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      // Navigator.pop(context);
      // handleStartStop();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("ClockIn", true);
      prefs.setString("InTime", time);
      prefs.setString('InDate', date);
      setState(() {
        isClockIn = true;
        InTime = time;
      });
      // print("200");
    } else {
      Fluttertoast.showToast(
          msg: d['data']['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool("ClockIn", true);
      // setState(() {
      //   isClockIn = true;
      // });
    }
  }

  Future<void> clockOut() async {
    String time = DateFormat("hh:mm a").format(DateTime.now());
    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/clockOut.php"),
            body: ({
              'auth_key': auth_key,
              'action': 'clockout',
              'end': time,
              'description': "",
              "id": ""
            }));
    var d = json.decode(response.body);
    var message = d['data']['error'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Fluttertoast.showToast(
          msg: d['data']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      // Navigator.pop(context);
      // handleStartStop();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("ClockIn", false);
      prefs.setString("OutTime", time);
      prefs.setString('OutDate', date);
      setState(() {
        isClockIn = false;
        OutTime = time;
      });
    } else {
      Fluttertoast.showToast(
          msg: d['data']['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool("ClockIn", false);
      // setState(() {
      //   isClockIn = false;
      // });
    }
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("password");
    prefs.remove("name");
    prefs.remove("contact");
    prefs.remove("address");
    prefs.remove("postcode");
    prefs.remove("state");
    prefs.remove("city");
    prefs.remove("country");
    prefs.remove("depot");
    prefs.remove("type");
    prefs.remove("auth_key");
    prefs.remove("ClockIn");
    prefs.remove("InTime");
    prefs.remove("OutTime");
    prefs.remove("InDate");
    prefs.remove("OutDate");
  }

  var size;
  double itemWidth = 0;
  double itemHeight = 0;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        bottomNavigationBar: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Color(0xff274C77),
            // Color(0xff274C77),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "HOME",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  SizedBox(
                    height: 6,
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => vehicle_inspection(
                      //             question: global_question,
                      //             auth_key: auth_key)));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InspectionQuestion(
                                  question: global_question)));
                    },
                    icon: const Icon(
                      Icons.assessment_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "INSPECTION",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  SizedBox(
                    height: 6,
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvoiceTab()));
                    },
                    icon: const Icon(
                      Icons.insert_drive_file_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "INVOICE",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  SizedBox(
                    height: 6,
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: global_profile_image == ""
                    ? Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: app_color),
                        ),
                        child: Image.asset("images/profile.png"),
                      )
                    : CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(global_profile_image),
                      ),
              ),
            ],
          ),
        ),
        body: Column(children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/drivaarlogo.png",
                          height: 46,
                          width: 46,
                        ),
                        Spacer(),
                        FittedBox(
                          child: Text(
                            "Welcome ${name.split(" ").first} !",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Spacer(),
                        PopupMenuButton(
                          icon: Transform.rotate(
                            angle: 180 * math.pi / 180,
                            child: Icon(
                              Icons.sort,
                              size: 30,
                            ),
                          ),
                          onSelected: (value) async {
                            if (value == 'Notification') {
                              Fluttertoast.showToast(msg: "Under Constraction");
                            } else if (value == 'Leave') {
                              Fluttertoast.showToast(msg: "Under Constraction");
                            } else if (value == 'Help') {
                              Fluttertoast.showToast(msg: "Under Constraction");
                            } else if (value == 'Logout') {
                              removeValues();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginRegister()));
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              // PopupMenuItem(
                              //     child: Text('Notification'),
                              //     value: 'Notification'),
                              // PopupMenuItem(
                              //     child: Text('Leave'), value: 'Leave'),
                              // PopupMenuItem(
                              //   child: Text('Help'),
                              //   value: 'Help',
                              // ),
                              PopupMenuItem(
                                child: Text('Logout'),
                                value: 'Logout',
                              ),
                            ];
                          },
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: Color(0xFF274C77),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          "Attendance",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF274C77),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          // height: 170,
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
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 30, right: 30),
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  // width: 188,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFF274C77),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentTime,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Navigator.pop(context);
                                            if (isClockIn == false) {
                                              showAlertDialog(
                                                  context, "Clock In");
                                            } else {
                                              showAlertDialog(
                                                  context, "Clock Out");
                                            }
                                          },
                                          child: Text(
                                            isClockIn == false
                                                ? "Clock In"
                                                : "Clock Out",
                                            style: TextStyle(
                                                color: (Color(0xff274C77)),
                                                fontSize: 18),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(140, 46),
                                            primary: Colors.white,
                                            elevation: 0,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 35, bottom: 10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Clock In",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF274C77)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            InTime,
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        SizedBox(height: 35),
                                        Text(
                                          "Clock Out",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF274C77)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            OutTime,
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 44, right: 10, bottom: 5, top: 5),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    height: MediaQuery.of(context).size.height *
                                        0.23,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color(0xFF274C77),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Attendance()));
                                      },
                                      icon: Icon(
                                        Icons.navigate_next,
                                        size: 30,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  primary: false,
                                  childAspectRatio: 1,
                                  // (itemWidth / itemHeight) * 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddAccidentReport(
                                                      auth_key: auth_key,
                                                    )));
                                        //  Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             AddThirdPartyReport()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        // height: 500,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(
                                                2.0,
                                                2.0,
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: const Image(
                                                image: AssetImage(
                                                  "images/accident.png",
                                                ),
                                                height: 80,
                                              ),
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Text(
                                              "Report",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff373737),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "Accident",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff373737),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Document()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(
                                                2.0,
                                                2.0,
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Image(
                                                image: AssetImage(
                                                    "images/document.png"),
                                                height: 80,
                                              ),
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Text(
                                              "Company",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff373737),
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "Document",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff373737),
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OffencesList(
                                                        auth_key: auth_key
                                                            .toString())));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(
                                                2.0,
                                                2.0,
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Image(
                                                image: AssetImage(
                                                    "images/offence.png"),
                                                height: 80,
                                              ),
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Text(
                                              "Offence",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff373737),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LeaveList()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(
                                                2.0,
                                                2.0,
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Image(
                                                image: AssetImage(
                                                    "images/leave.png"),
                                                height: 80,
                                              ),
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Text(
                                              "Leave",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff373737),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // InkWell(
                                    //   onTap: () {
                                    //     // Navigator.push(
                                    //     //     context,
                                    //     //     MaterialPageRoute(
                                    //     //         builder: (context) =>
                                    //     //             OffencesList(
                                    //     //                 auth_key: auth_key)));
                                    //   },
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //       borderRadius:
                                    //           BorderRadius.circular(20),
                                    //       color: Colors.white,
                                    //       boxShadow: [
                                    //         BoxShadow(
                                    //           color: Colors.grey.shade300,
                                    //           offset: const Offset(
                                    //             2.0,
                                    //             2.0,
                                    //           ),
                                    //           blurRadius: 10.0,
                                    //         ),
                                    //         BoxShadow(
                                    //           color: Colors.white,
                                    //           offset: const Offset(0.0, 0.0),
                                    //           blurRadius: 0.0,
                                    //           spreadRadius: 0.0,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     child: Column(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         Container(
                                    //           width: 200,
                                    //           decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(15),
                                    //           ),
                                    //           child: Image(
                                    //             image: AssetImage(
                                    //                 "images/issues.png"),
                                    //             height: 80,
                                    //           ),
                                    //         ),
                                    //         Container(
                                    //           height: 5,
                                    //         ),
                                    //         Text(
                                    //           "Issues",
                                    //           textAlign: TextAlign.center,
                                    //           style: TextStyle(
                                    //               color: Color(0xff373737),
                                    //               fontWeight: FontWeight.w600,
                                    //               fontSize: 16),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FeedBack()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(
                                                2.0,
                                                2.0,
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Image(
                                                image: AssetImage(
                                                    "images/feedback.png"),
                                                height: 80,
                                              ),
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Text(
                                              "Feedback",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff373737),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String Status) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: app_color),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget inButton = TextButton(
      child: Text(Status, style: TextStyle(color: app_color)),
      onPressed: () {
        if (Status == "Clock In") {
          // handleStartStop();
          clockIn();
        } else {
          // handleStartStop();
          clockOut();
        }
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$Status"),
      content: Text("Are you sure you want to $Status"),
      actions: [
        cancelButton,
        inButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
