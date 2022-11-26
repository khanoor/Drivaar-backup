import 'dart:convert';

import 'package:drivaar/Screen/home_page.dart';
import 'package:drivaar/Screen/inspection/inspection_question.dart';
import 'package:drivaar/Screen/invoice/view_invoice.dart';
import 'package:drivaar/Screen/profile.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Invoice extends StatefulWidget {
  String auth_key = "";
  Invoice({Key? key, required this.auth_key}) : super(key: key);

  @override
  State<Invoice> createState() => InvoiceState(auth_key: auth_key);
}

class InvoiceState extends State<Invoice> {
  String auth_key = "";
  InvoiceState({required this.auth_key});

  List invoice_data = [];

  Future<String?> fetch_invoice() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/invoice.php"),
            body: ({
              "action": "invoice",
              "auth_key": auth_key,
            }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        invoice_data = convert_data_to_json['data']['data'];
        print(invoice_data);
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
    fetch_invoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      // appBar: AppBar(
      // title: const Text("Invoice"),
      // backgroundColor: app_color,
      // ),
      bottomNavigationBar: Container(
        height: 66,
        decoration: BoxDecoration(
          color: Color(0xff274C77),
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                auth_key: auth_key, name: global_name)));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InspectionQuestion(question: global_question)));
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
              ],
            ),
            Column(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => super.widget));
                  },
                  icon: const Icon(
                    Icons.insert_drive_file_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Text(
                  "INVOICE",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
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
      body:
          // Zoom(
          //   maxZoomHeight: MediaQuery.of(context).size.height * 2.5,
          //   maxZoomWidth: 1000,
          //   scrollWeight: 0.0,
          //   initZoom: 0.0,
          //   child:
          //   SingleChildScrollView(
          Stack(
        children: [
          ListView.builder(
              itemCount: invoice_data.length,
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
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 10, right: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Invoice No",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          ": ${invoice_data[index]["invoice_no"]}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Total",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          ": ${invoice_data[index]["total"]}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Due Date",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          ": ${invoice_data[index]["due"]}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Status",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          ": ${invoice_data[index]["status"]}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: invoice_data[index]
                                                          ["status"] ==
                                                      "HOLD"
                                                  ? Colors.orange.shade800
                                                  : invoice_data[index]
                                                              ["status"] ==
                                                          "APPROVED"
                                                      ? Colors.lightGreen
                                                      : invoice_data[index]
                                                                  ["status"] ==
                                                              "SEND"
                                                          ? Colors
                                                              .green.shade800
                                                          : invoice_data[index][
                                                                      "status"] ==
                                                                  "PENDING"
                                                              ? Colors.grey
                                                              : Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Period",
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w600,
                                              color: app_color),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ": ${invoice_data[index]["period"].toString().split(">>").first}",
                                              style: TextStyle(
                                                  fontSize: 14, color: app_color
                                                  // fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Text(
                                              " >> ${invoice_data[index]["period"].toString().split(">>").last}",
                                              style: TextStyle(
                                                  fontSize: 14, color: app_color
                                                  // fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer(),
                          SizedBox(
                            width: 0,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 150,
                            width: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Color(0xFF274C77),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewInvoice(
                                              invoice_no: invoice_data[index]
                                                  ["invoice_no"],
                                              viewId: invoice_data[index]
                                                  ["View_id"],
                                            )));
                              },
                              icon: Icon(
                                Icons.navigate_next,
                                size: 30,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // DataTable(
                  //   border: TableBorder.all(color: app_color),
                  //   dataRowHeight: 50,
                  //   headingRowHeight: 60,
                  //   columns: const [
                  //     DataColumn(
                  //         label: Text(
                  //       'Total',
                  //       style: TextStyle(
                  //         fontSize: 30,
                  //       ),
                  //     )),
                  //     DataColumn(
                  //         label: Text(
                  //       'Status',
                  //       style: TextStyle(
                  //         fontSize: 30,
                  //       ),
                  //     )),
                  //     DataColumn(
                  //         label: Text(
                  //       'Period',
                  //       style: TextStyle(
                  //         fontSize: 30,
                  //       ),
                  //     )),
                  //     // DataColumn(label: Text('invoice_no')),
                  //     DataColumn(
                  //         label: Text(
                  //       'Due Date',
                  //       style: TextStyle(
                  //         fontSize: 30,
                  //       ),
                  //     )),
                  //     DataColumn(
                  //         label: Text(
                  //       'View',
                  //       style: TextStyle(
                  //         fontSize: 30,
                  //       ),
                  //     ))
                  //   ],

                  //   rows: List.generate(invoice_data.length, (index) {
                  //     final y = invoice_data[index]["total"].toString();
                  //     final x = invoice_data[index]["status"];
                  //     final z = invoice_data[index]["period"];
                  //     final w = invoice_data[index]["due"];

                  //     return DataRow(cells: [
                  //       DataCell(Container(
                  //           alignment: Alignment.center,
                  //           child: Text(
                  //             y,
                  //             // textAlign: TextAlign.center,
                  //             style: const TextStyle(
                  //               fontSize: 24,
                  //             ),
                  //           ))),
                  //       DataCell(Container(
                  //           child: Text(
                  //         x,
                  //         style: const TextStyle(
                  //           fontSize: 24,
                  //         ),
                  //       ))),
                  //       DataCell(Container(
                  //           child: Text(
                  //         w,
                  //         style: const TextStyle(
                  //           fontSize: 24,
                  //         ),
                  //       ))),
                  //       DataCell(Container(
                  //           child: Text(
                  //         z,
                  //         style: const TextStyle(
                  //           fontSize: 24,
                  //         ),
                  //       ))),
                  //       DataCell(Container(
                  //         alignment: Alignment.center,
                  //         child: IconButton(
                  //             padding: const EdgeInsets.only(bottom: 0),
                  //             onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ViewInvoice(
                  //               invoice_no: invoice_data[index]
                  //                   ["invoice_no"],
                  //               viewId: invoice_data[index]
                  //                   ["View_id"],
                  //             )));
                  //             },
                  //             icon: const Icon(
                  //               Icons.remove_red_eye_outlined,
                  //               size: 35,
                  //             )),
                  //       ))
                  //     ]);
                  //   }),
                  // ),
                  // ),
                  // ),
                  //       ),
                  // ),
                  // ],
                );
              }),
          // ),
          invoice_data.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }
}
