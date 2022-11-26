import 'dart:convert';

import 'package:drivaar/Screen/documents/view_document.dart';
import 'package:drivaar/Screen/home_page.dart';
import 'package:drivaar/Screen/inspection/inspection_question.dart';
import 'package:drivaar/Screen/invoice/pcn_view.dart';
import 'package:drivaar/Screen/profile.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PCN extends StatefulWidget {
  const PCN({Key? key}) : super(key: key);

  @override
  State<PCN> createState() => PCNState();
}

class PCNState extends State<PCN> {
  List pcn_data = [];

  Future<String?> fetch_pcn() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/pcn_list.php"),
            body: ({
              "action": "pcn_list",
              "auth_key": global_auth_key,
            }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        pcn_data = convert_data_to_json['data']['data'];
        print(pcn_data);
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
    fetch_pcn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                auth_key: global_auth_key, name: global_name)));
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
          // Stack(
          //   children: [
          pcn_data.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columnSpacing: 0,
                        headingRowHeight: 40,
                        dataRowHeight: 40,
                        columns: [
                          DataColumn(
                            label: Container(
                              width: 80,
                              child: Text("Amount"),
                            ),
                          ),
                          DataColumn(
                              label: Container(
                            width: 80,
                            child: Text("Category"),
                          )),
                          DataColumn(
                              label: Container(
                            width: 80,
                            child: Text("Reason"),
                          )),
                          DataColumn(
                              label: Container(
                            width: 120,
                            child: Text("Date"),
                          )),
                          DataColumn(
                              label: Container(
                            width: 26,
                            child: Text("View"),
                          )),
                        ],
                        rows: List.generate(pcn_data.length, (index) {
                          return DataRow(cells: [
                            DataCell(Text(pcn_data[index]["amount"])),
                            DataCell(Text(pcn_data[index]["type"])),
                            DataCell(Text(pcn_data[index]["reason"])),
                            DataCell(Text(pcn_data[index]["date"])),
                            DataCell(IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PcnView(
                                              id: pcn_data[index]['detail'][0]
                                                  ['loanid'],
                                              pcn_data: pcn_data[index]
                                                  ['detail'],
                                            )));
                              },
                              icon: Icon(
                                Icons.remove_red_eye_sharp,
                                color: app_color,
                              ),
                            )),
                          ]);
                        })),
                  ),
                ),
      // Column(
      //     children: [
      //       Padding(
      //         padding:
      //             const EdgeInsets.only(left: 10, top: 10, right: 10),
      //         child: Row(
      //           children: [
      //             Text("Amount"),
      //             Spacer(),
      //             Text("Category"),
      //             Spacer(),
      //             Text("Reason"),
      //             Spacer(),
      //             Text("Date"),
      //             Spacer(),
      //           ],
      //         ),
      //       ),
      //       Expanded(
      //         child: ListView.builder(
      //             itemCount: pcn_data.length,
      //             itemBuilder: (context, index) {
      //               return Padding(
      //                 padding: const EdgeInsets.only(
      //                     left: 10, top: 10, right: 10),
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(4),
      //                     color: Colors.white,
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey.shade300,
      //                         offset: const Offset(
      //                           0.0,
      //                           0.0,
      //                         ),
      //                         blurRadius: 10.0,
      //                       ),
      //                       BoxShadow(
      //                         color: Colors.white,
      //                         offset: const Offset(0.0, 0.0),
      //                         blurRadius: 0.0,
      //                         spreadRadius: 0.0,
      //                       ),
      //                     ],
      //                   ),
      //                   width: double.infinity,
      //                   // child: Padding(
      //                   //   padding: EdgeInsets.only(
      //                   //       left: 20, top: 10, right: 10, bottom: 10),
      //                   child: Row(
      //                     children: [
      //                       Text(pcn_data[index]["amount"]),
      //                       Spacer(),
      //                       Text(pcn_data[index]["type"]),
      //                       Spacer(),
      //                       Text(pcn_data[index]["reason"]),
      //                       Spacer(),
      //                       Text(pcn_data[index]["date"]),
      //                       Spacer(),
      //                     ],
      //                     // ),
      //                     // Row(
      //                     //   crossAxisAlignment: CrossAxisAlignment.start,
      //                     //   children: [
      //                     //     Expanded(
      //                     //       child: Container(
      //                     //         child: Column(
      //                     //           children: [
      //                     //             Row(
      //                     //               children: [
      //                     //                 Expanded(
      //                     //                   child: Text(
      //                     //                     "Loan ID",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //                 Expanded(
      //                     //                   flex: 2,
      //                     //                   child: Text(
      //                     //                     ": ${pcn_data[index]["loanid"]}",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //               ],
      //                     //             ),
      //                     //             SizedBox(
      //                     //               height: 10,
      //                     //             ),
      //                     //             Row(
      //                     //               children: [
      //                     //                 Expanded(
      //                     //                   child: Text(
      //                     //                     "Amount",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //                 Expanded(
      //                     //                   flex: 2,
      //                     //                   child: Text(
      //                     //                     ": ${pcn_data[index]["amount"]}",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //               ],
      //                     //             ),
      //                     //             SizedBox(
      //                     //               height: 10,
      //                     //             ),
      //                     //             Row(
      //                     //               children: [
      //                     //                 Expanded(
      //                     //                   child: Text(
      //                     //                     "Category",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //                 Expanded(
      //                     //                   flex: 2,
      //                     //                   child: Text(
      //                     //                     ": ${pcn_data[index]["category"]}",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //               ],
      //                     //             ),
      //                     //             SizedBox(
      //                     //               height: 10,
      //                     //             ),
      //                     //             Row(
      //                     //               children: [
      //                     //                 Expanded(
      //                     //                   child: Text(
      //                     //                     "Invoiced",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //                 Expanded(
      //                     //                   flex: 2,
      //                     //                   child: Text(
      //                     //                     ": ${pcn_data[index]["invoiced"]}",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //               ],
      //                     //             ),
      //                     //             SizedBox(
      //                     //               height: 10,
      //                     //             ),
      //                     //             Row(
      //                     //               crossAxisAlignment:
      //                     //                   CrossAxisAlignment.start,
      //                     //               children: [
      //                     //                 Expanded(
      //                     //                   child: Text(
      //                     //                     "Paid",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //                 Expanded(
      //                     //                   flex: 2,
      //                     //                   child: Column(
      //                     //                     crossAxisAlignment:
      //                     //                         CrossAxisAlignment.start,
      //                     //                     children: [
      //                     //                       Text(
      //                     //                         ": ${pcn_data[index]["paid"]}",
      //                     //                         style: TextStyle(
      //                     //                           fontSize: 14,
      //                     //                           color: pcn_data[index]
      //                     //                                       ["paid"] ==
      //                     //                                   "paid"
      //                     //                               ? Colors.lightGreen
      //                     //                               : Colors.redAccent,
      //                     //                           fontWeight: FontWeight.w600,
      //                     //                         ),
      //                     //                       ),
      //                     //                     ],
      //                     //                   ),
      //                     //                 ),
      //                     //               ],
      //                     //             ),
      //                     //             SizedBox(
      //                     //               height: 10,
      //                     //             ),
      //                     //             Row(
      //                     //               crossAxisAlignment:
      //                     //                   CrossAxisAlignment.start,
      //                     //               children: [
      //                     //                 Expanded(
      //                     //                   child: Text(
      //                     //                     "Deduction Date",
      //                     //                     style: TextStyle(
      //                     //                         fontSize: 14,
      //                     //                         // fontWeight: FontWeight.w600,
      //                     //                         color: app_color),
      //                     //                   ),
      //                     //                 ),
      //                     //                 Expanded(
      //                     //                   flex: 2,
      //                     //                   child: Column(
      //                     //                     crossAxisAlignment:
      //                     //                         CrossAxisAlignment.start,
      //                     //                     children: [
      //                     //                       Text(
      //                     //                         ": ${pcn_data[index]["deductiondate"].toString().split("(").first}",
      //                     //                         style: TextStyle(
      //                     //                             fontSize: 14, color: app_color
      //                     //                             // fontWeight: FontWeight.w600,
      //                     //                             ),
      //                     //                       ),
      //                     //                       Text(
      //                     //                         "  ( ${pcn_data[index]["deductiondate"].toString().split("(").last}",
      //                     //                         style: TextStyle(
      //                     //                             fontSize: 14, color: app_color
      //                     //                             // fontWeight: FontWeight.w600,
      //                     //                             ),
      //                     //                       ),
      //                     //                     ],
      //                     //                   ),
      //                     //                 ),
      //                     //               ],
      //                     //             ),
      //                     //           ],
      //                     //         ),
      //                     //       ),
      //                     //     ),
      //                     //     // Spacer(),
      //                     //     SizedBox(
      //                     //       width: 0,
      //                     //     ),
      //                     //     Container(
      //                     //       alignment: Alignment.center,
      //                     //       height: 160,
      //                     //       width: 45,
      //                     //       decoration: BoxDecoration(
      //                     //         borderRadius: BorderRadius.circular(25),
      //                     //         color: Color(0xFF274C77),
      //                     //       ),
      //                     //       child: IconButton(
      //                     //         onPressed: () {
      //                     //           pcn_data[index]["file"].toString().contains(",")
      //                     //               ? Navigator.push(
      //                     //                   context,
      //                     //                   MaterialPageRoute(
      //                     //                       builder: (context) => ViewDocument(
      //                     //                           name: pcn_data[index]
      //                     //                               ["invoiced"],
      //                     //                           imageUrl: pcn_data[index]
      //                     //                                   ["file"]
      //                     //                               .toString()
      //                     //                               .split(",")
      //                     //                               .first)))
      //                     //               : Navigator.push(
      //                     //                   context,
      //                     //                   MaterialPageRoute(
      //                     //                       builder: (context) => ViewDocument(
      //                     //                           name: pcn_data[index]
      //                     //                               ["invoiced"],
      //                     //                           imageUrl: pcn_data[index]
      //                     //                               ["file"])));
      //                     //         },
      //                     //         icon: Icon(
      //                     //           Icons.navigate_next,
      //                     //           size: 30,
      //                     //         ),
      //                     //         color: Colors.white,
      //                     //       ),
      //                     //     ),
      //                     //   ],
      //                     // ),
      //                   ),
      //                 ),
      //               );
      //             }),
      //         // pcn_data.isEmpty
      //         //     ? const Center(
      //         //         child: CircularProgressIndicator(),
      //         //       )
      //         //     : Container()
      //         //   ],
      //       ),
      //     ],
      //   ),
    );
  }
}
