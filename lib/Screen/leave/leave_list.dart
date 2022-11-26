// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:drivaar/Screen/leave/leave_request.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LeaveList extends StatefulWidget {
  LeaveList({Key? key}) : super(key: key);

  @override
  State<LeaveList> createState() => LeaveListState();
}

class LeaveListState extends State<LeaveList> {
  List request_data = [];

  Future<String?> fetch_request() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/request_dayoff_list.php"),
        body: ({
          "action": "request_dayoff_list",
          "auth_key": global_auth_key,
        }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['error'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        request_data = convert_data_to_json['data']['data'];
        // print(request_data);
      });
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  @override
  void initState() {
    super.initState();
    fetch_request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Leave List"),
        backgroundColor: Color(0xff274C77),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: app_color,
        onPressed: () async {
          String add = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => LeaveRequest()));

          if (add == "add") {
            fetch_request();
          }
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: request_data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Container(
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
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 15, right: 15, bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Text(
                                "Date",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF274C77),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                ": ${request_data[index]["date"]}",
                                style: const TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 5, right: 15, bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Text(
                                "Notes",
                                style: TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                ": ${request_data[index]["notes"]}",
                                style: const TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 5, right: 15, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Text(
                                "Status",
                                style: TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                ": ${request_data[index]["status"]}",
                                style: TextStyle(
                                  color: request_data[index]["status"] ==
                                          "Rejected"
                                      ? Colors.red
                                      : request_data[index]["status"] ==
                                              "Pending"
                                          ? Colors.grey
                                          : Colors.lightGreen,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          request_data.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }
}
