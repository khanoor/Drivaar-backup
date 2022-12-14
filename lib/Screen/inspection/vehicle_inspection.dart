import 'package:drivaar/Screen/home_page.dart';
import 'package:drivaar/Screen/inspection/inspection_question.dart';
import 'package:drivaar/Screen/invoice/invoice.dart';
import 'package:drivaar/Screen/invoice/invoice_tab.dart';
import 'package:drivaar/Screen/profile.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class vehicle_inspection extends StatefulWidget {
  List question = [];
  String auth_key = '';
  vehicle_inspection({Key? key, required this.question, required this.auth_key})
      : super(key: key);

  @override
  State<vehicle_inspection> createState() => _vehicle_inspectionState();
}

String year = DateFormat('yyyy').format(DateTime.now());

class _vehicle_inspectionState extends State<vehicle_inspection> {
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (date != null) {
      setState(() {
        year = DateFormat("yyyy").format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Vehicle Inspection"),
        ),
        backgroundColor: Colors.grey.shade200,
        bottomNavigationBar: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                  auth_key: widget.auth_key,
                                  name: global_name)));
                    },
                    icon: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "HOME",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      // Navigator.pushReplacement(
                      // context,
                      // MaterialPageRoute(
                      //     builder: (context) => super.widget));
                    },
                    icon: const Icon(
                      Icons.assessment_rounded,
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
                      Navigator.pushReplacement(
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
                  Navigator.pushReplacement(context,
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
                        radius: 22.0,
                        backgroundImage: NetworkImage(global_profile_image),
                      ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Container(
                  decoration: BoxDecoration(
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
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InspectionQuestion(
                                  question: widget.question)));
                    },
                    child: const Text(
                      "ADD INSPECTION",
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50),
                      elevation: 0,
                      // shape: StadiumBorder(),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: FittedBox(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          decoration: BoxDecoration(
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
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sort,
                                  color: app_color,
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  "Sort",
                                  style: TextStyle(
                                      color: (Color(0xff274C77)), fontSize: 16),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                              primary: Colors.white,
                              elevation: 0,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
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
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  year,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff274C77),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: IconButton(
                                  onPressed: () {
                                    selectStartDate(context);
                                  },
                                  icon: Icon(
                                    Icons.calendar_today_rounded,
                                    size: 30,
                                    color: Color(0xff274C77),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "January",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: app_color,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "February",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "March",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "April",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "May",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "June",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "July",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "August",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "September",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "October",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "November",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "December",
                                    style: TextStyle(
                                        color: Color(0xff274C77), fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade200),
                            child: FittedBox(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "DATE",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: Text(
                                      "VEHICLE",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: Text(
                                      "ODOMETER",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 10),
                                    child: Text(
                                      "CHECKS",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade200),
                            alignment: Alignment.center,
                            child: Text(
                              "Weekend : 23 Sunday",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Card(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Card() {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return FittedBox(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade200),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "22",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "SAT",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Column(
                      children: [
                        Text(
                          "SUZUKI RITZ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "MS 0514R",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "1420",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      "10",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ),
                  Text(
                    "/",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "10",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  )
                ],
              ),
            ),
          );
        });
  }
}
