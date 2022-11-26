import 'dart:convert';

import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class OffencesList extends StatefulWidget {
  String auth_key = "";
  OffencesList({Key? key, required this.auth_key}) : super(key: key);

  @override
  State<OffencesList> createState() => _OffencesListState(auth_key: auth_key);
}

class _OffencesListState extends State<OffencesList> {
  String auth_key = "";
  _OffencesListState({required this.auth_key});
  List offences_data = [];

  Future<String?> fetch_offences() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/offences_list.php"),
        body: ({
          "action": "offences_list",
          "auth_key": auth_key,
        }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        offences_data = convert_data_to_json['data']['data'];
        // print(offences_data);
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
    fetch_offences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Offences"),
        backgroundColor: app_color,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: offences_data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
                                "Occurred Date",
                                style: TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                ": ${offences_data[index]["occurred_date"]}",
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
                                "Vehicle Id",
                                style: TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                ": ${offences_data[index]["vehicle_id"]}",
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
                                "PCN Ticket ID",
                                style: TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                ": ${offences_data[index]["pcnticket_typeid"]}",
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
                                "Amount",
                                style: TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                ": ${offences_data[index]["amount"]}",
                                style: const TextStyle(
                                    color: Color(0xFF274C77),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
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
                                "Admin Fee",
                                style: TextStyle(
                                  color: Color(0xFF274C77),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                ": ${offences_data[index]["admin_fee"]}",
                                style: const TextStyle(
                                    color: Color(0xFF274C77),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
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
                              flex: 2,
                              child: offences_data[index]["status"] == "Active"
                                  ? Text(
                                      ": ${offences_data[index]["status"]}",
                                      style: const TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize: 14,
                                      ),
                                    )
                                  : Text(
                                      ": ${offences_data[index]["status"]}",
                                      style: const TextStyle(
                                        color: Colors.red,
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
          offences_data.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }
}
