import 'dart:convert';

import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({Key? key}) : super(key: key);

  @override
  State<LeaveRequest> createState() => LeaveRequestState();
}

class LeaveRequestState extends State<LeaveRequest> {
  final formKey = GlobalKey<FormState>();

  TextEditingController request = TextEditingController();

  String selectedStartDate = 'Start Date';
  String selectedEndDate = 'End Date';

  DateTime currentDate = DateTime.now();

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (date != null) {
      setState(() {
        selectedStartDate = DateFormat("yyyy-MM-dd").format(date);
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? endDate = await showDatePicker(
      context: context,
      initialDate: DateFormat("yyyy-MM-dd").parse(selectedStartDate),
      firstDate: DateFormat("yyyy-MM-dd").parse(selectedStartDate),
      lastDate: DateTime(2050),
    );
    if (endDate != null) {
      setState(() {
        selectedEndDate = DateFormat("yyyy-MM-dd").format(endDate);
      });
    }
  }

  Future<String?> leaveRequest() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/request_dayoff.php"),
        body: ({
          "action": "request_dayoff",
          "auth_key": global_auth_key,
          'notes': request.text,
          'start_date': selectedStartDate,
          'end_date': selectedEndDate,
        }));
    var convert_data_to_json = json.decode(response.body);
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        request.text = "";
        selectedStartDate = "Start Date";
        selectedEndDate = "End Date";
      });

      Fluttertoast.showToast(
          msg: convert_data_to_json['data']['success'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      Navigator.pop(context, "add");
    } else {
      Fluttertoast.showToast(
          msg: convert_data_to_json['data']['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Request Leave"),
        backgroundColor: Color(0xff274C77),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 0, left: 20, right: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Request Leave",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  // child: TextFormField(
                  //   decoration: const InputDecoration(
                  //     hintText: "Start Date",
                  //     prefixIcon: Icon(Icons.calendar_today),
                  //     border: const OutlineInputBorder(),
                  //     enabledBorder: OutlineInputBorder(
                  //         borderRadius:
                  //             BorderRadius.all(Radius.circular(4)),
                  //         borderSide: BorderSide(
                  //             width: 2, color: app_color)),
                  //   ),
                  //   onTap: () {
                  //     selectStartDate(context);
                  //   },
                  // ),

                  child:
                      ButtonBar(alignment: MainAxisAlignment.start, children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        selectStartDate(context);
                      },
                      label: Text(
                        selectedStartDate,
                        style: TextStyle(color: app_color),
                      ),
                      icon: Icon(
                        Icons.calendar_today,
                        color: app_color,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        side: BorderSide(width: 2, color: app_color),
                      ),
                    )
                  ]),
                ),
                // ),
                Expanded(
                  flex: 1,
                  child: ButtonBar(alignment: MainAxisAlignment.end, children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        selectEndDate(context);
                      },
                      label: Text(
                        selectedEndDate,
                        style: TextStyle(color: app_color),
                      ),
                      icon: Icon(
                        Icons.calendar_today,
                        color: app_color,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        side: BorderSide(width: 2, color: app_color),
                      ),
                    )
                  ]),
                ),
                // ),
              ]),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 10, left: 10, right: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: request,
                cursorColor: app_color,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Note';
                  }
                  return null;
                },
                maxLines: 3,
                // maxLength: 200,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: "Enter Notes",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: app_color,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 2, color: app_color),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 2, color: app_color),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 10, left: 10, right: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (selectedStartDate != "Start Date" &&
                      selectedEndDate != "End Date") {
                    // print(global_auth_key);
                    // print(request.text);
                    // print(selectedStartDate);
                    // print(selectedEndDate);
                    leaveRequest();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Select Start or End Date",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1);
                  }
                }
              },
              child: const Text(
                "Send Request",
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                primary: app_color,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
