import 'dart:async';
import 'dart:convert';

import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => AttendanceState();
}

class AttendanceState extends State<Attendance> {
  String year = DateFormat('yyyy').format(DateTime.now());

  Future<void> selectYear(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        year = DateFormat("yyyy").format(date);
        month_data = [];
        getAttendance();
        isOut = false;
        startTime();
      });
    }
  }

  String currentMonth = DateFormat.LLLL().format(DateTime.now());
  int month_number = int.parse(DateFormat.M().format(DateTime.now()));

  List attendance_data = [];
  List month_data = [];
  bool isOut = false;
  bool reverse = false;

  ItemScrollController itemScrollController = ItemScrollController();

  // ignore: body_might_complete_normally_nullable
  Future<String?> getAttendance() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/attendance_list.php"),
        body: ({
          "action": "attendance_list",
          "auth_key": global_auth_key,
        }));
    var convert_data_to_json = json.decode(response.body);
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        attendance_data = convert_data_to_json['data']['data'];
        for (int i = 0; i < attendance_data.length; i++) {
          if ("${attendance_data[i]['date'].toString().substring(4).split(",").first}" ==
                      currentMonth &&
                  "${attendance_data[i]['date'].toString().split(" ").last}" ==
                      year ||
              "${attendance_data[i]['date'].toString().substring(5).split(",").first}" ==
                      currentMonth &&
                  "${attendance_data[i]['date'].toString().split(" ").last}" ==
                      year) {
            month_data.add(attendance_data[i]);
            // print(month_data);
          }
        }
        month_data = month_data.reversed.toSet().toList();
        // print(month_data);
        // // date_list.sort();
        // reverse == true
        //     ? month_data = month_data.reversed.toList()
        //     : month_data.sort();
      });
    }
  }

  List Month_Name = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  startTime() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, stag);
  }

  void stag() {
    setState(() {
      isOut = true;
    });
  }

  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    getAttendance();
    startTime();
    // print(currentMonth);
    // print(DateFormat.yMEd().format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Attendance List"),
          backgroundColor: Color(0xff274C77),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: FittedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
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
                            if (reverse == false) {
                              setState(() {
                                reverse = true;
                                month_data = month_data.reversed.toList();
                              });
                            } else {
                              setState(() {
                                reverse = false;
                                month_data = month_data.reversed.toList();
                              });
                            }
                          },
                          child: Row(
                            children: [
                              reverse == false
                                  ? Icon(
                                      Icons.sort,
                                      color: app_color,
                                    )
                                  : Transform.rotate(
                                      angle: 180 * math.pi / 180,
                                      child: Icon(
                                        Icons.sort,
                                        size: 30,
                                        color: app_color,
                                      ),
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
                      padding: const EdgeInsets.only(right: 12),
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
                                  color: Color(0xFF274C77),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: IconButton(
                                onPressed: () {
                                  selectYear(context);
                                },
                                icon: Icon(
                                  Icons.calendar_today_rounded,
                                  size: 30,
                                  color: Color(0xFF274C77),
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
              padding: const EdgeInsets.only(left: 12, right: 12),
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
                        child: ScrollablePositionedList.builder(
                            itemScrollController: itemScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: Month_Name.length,
                            initialScrollIndex: month_number - 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    itemScrollController.scrollTo(
                                        index: index,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOutCubic);
                                    setState(() {
                                      currentMonth = Month_Name[index];
                                      month_data = [];
                                      getAttendance();
                                      isOut = false;
                                      startTime();
                                    });
                                  },
                                  child: Text(
                                    Month_Name[index],
                                    style: TextStyle(
                                        color: currentMonth == Month_Name[index]
                                            ? Colors.white
                                            : app_color,
                                        fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: currentMonth == Month_Name[index]
                                        ? app_color
                                        : Colors.white,
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    side: BorderSide(color: app_color),
                                  ),
                                ),
                              );
                            }),
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
                                    "START TIME",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Text(
                                    "END TIME",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 10),
                                  child: Text(
                                    "STATUS",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
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
      // ),
    );
  }

  Widget Card() {
    return month_data.length > 0
        ? ListView.builder(
            itemCount: month_data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 20, top: 5, bottom: 5),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade200),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Text(
                                    "${month_data[index]['date'].toString().substring(4).split(",").first}" ==
                                            currentMonth
                                        ? "0${month_data[index]['date'].toString().substring(0, 1)}"
                                        : month_data[index]['date']
                                            .toString()
                                            .substring(0, 2),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Text(
                                //   DateFormat.E().format(DateTime.now()),
                                //   style: TextStyle(fontSize: 14),
                                // ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            month_data[index]['starttime'] == null
                                ? "null"
                                : month_data[index]['starttime'],
                            style: TextStyle(fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            month_data[index]['endtime'] == null
                                ? "null"
                                : month_data[index]['endtime'],
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            month_data[index]['status'],
                            style: TextStyle(
                                fontSize: 16,
                                color: month_data[index]['status'] == "Active"
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.shade400,
                  )
                ],
              );
            })
        : isOut == true
            ? Center(
                child: Text(
                  "Data Not Found",
                  style: TextStyle(fontSize: 20),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
  }
}
