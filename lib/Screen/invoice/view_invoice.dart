// ignore_for_file: no_logic_in_create_state

import 'dart:async';
import 'dart:convert';

import 'package:drivaar/Screen/invoice/file_handle_api.dart';
import 'package:drivaar/Screen/invoice/pdf_invoice_api.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ViewInvoice extends StatefulWidget {
  String viewId = "";
  String invoice_no = '';
  ViewInvoice({Key? key, required this.invoice_no, required this.viewId})
      : super(key: key);

  @override
  State<ViewInvoice> createState() =>
      ViewInvoiceState(invoice_no: invoice_no, viewId: viewId);
}

class ViewInvoiceState extends State<ViewInvoice> {
  String viewId = "";
  String invoice_no = '';
  ViewInvoiceState({required this.invoice_no, required this.viewId});

  List invoice_view = [];
  var details;
  var standard = [];
  var bonus = [];
  var deduction = [];
  var image;
  bool s = true;
  bool b = true;
  bool d = true;
  String week = '';
  String period = '';
  String totalAttendance = '';
  String associate = '';
  //Form Data
  String address = '';
  String utr = '';
  String phone = '';
  String email = '';

// To Data
  String net = '';
  String gross = '';
  String total = '';
  String vat = '';
  String b_name = '';
  String a_no = '';
  String s_code = '';
  String due_date = '';

  //To user Data
  String toname = '';
  String u_vat = '';
  String reg_no = '';
  String Street = '';
  String postcode = '';
  String city = '';

  bool status = false;

  Future<String?> view_invoice() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/view_invoice.php"),
        body: ({
          "action": "view_invoice",
          "invoiceno": invoice_no, //"1C00NAW42",
          "viewid": viewId //"NDIjMSM0OSMyMDIxI05ESWpNU00wT1NNeU1ESXg=",
        }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      // invoice_view = convert_data_to_json['data']['data'];
      setState(() {
        invoice_view = convert_data_to_json['data']['data'];
        print(invoice_view);
        for (int i = 0; i < invoice_view.length; i++) {
          setState(() {
            image = invoice_view[i]["image_logo"];
            week = invoice_view[i]["week_no"];
            period = invoice_view[i]["period"];
            associate = invoice_view[i]["associate"];
            net = invoice_view[i]["net"].toStringAsFixed(2);
            gross = invoice_view[i]["gross"].toStringAsFixed(2);
            total = invoice_view[i]["total"].toStringAsFixed(2);
            vat = invoice_view[i]["vat"].toStringAsFixed(2);
            a_no = invoice_view[i]["account_number"];
            b_name = invoice_view[i]["bank_name"];
            s_code = invoice_view[i]["sort_code"];
            due_date = invoice_view[i]["duedate"];
            totalAttendance = invoice_view[i]["totalAttendance"].toString();
            address = invoice_view[i]["form"][i]["address"];
            utr = invoice_view[i]["form"][i]["utr"];
            phone = invoice_view[i]["form"][i]["phone"];
            email = invoice_view[i]["form"][i]["email"];
            toname = invoice_view[i]["to"][i]["name"];
            postcode = invoice_view[i]["to"][i]["postcode"];
            u_vat = invoice_view[i]["to"][i]["vat"];
            Street = invoice_view[i]["to"][i]["street"];
            city = invoice_view[i]["to"][i]["city"];
            reg_no = invoice_view[i]["to"][i]["registration_no"];

            details = invoice_view[i]["detail"];

            //  standard = invoice_view[i]["detail"]["type"][0]["subdetail"];
            //  bonus = invoice_view[i]["detail"]["type2"][0]["subdetail"];
            //  deduction = invoice_view[i]["detail"]["type3"][0]["subdetail"];

            // details.length == 0
            // ? standard
            // : standard = invoice_view[i]["detail"]["type"][i]["subdetail"];

            details.toString().contains("type1")
                ? standard = invoice_view[i]["detail"]["type1"][0]["subdetail"]
                : s = false;

            details.toString().contains("type3")
                ? deduction = invoice_view[i]["detail"]["type3"][0]['subdetail']
                : d = false;

            details.toString().contains("type2")
                ? bonus = invoice_view[i]["detail"]["type2"][0]["subdetail"]
                : b = false;
          });
        }
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
    view_invoice();
    print(invoice_no);
    print(viewId);
    startTime();
  }

  startTime() async {
    var _duration = const Duration(seconds: 1);
    return Timer(_duration, changeStatus);
  }

  changeStatus() {
    setState(() {
      status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(("Invoice Details")),
        backgroundColor: app_color,
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile =
                    await PdfInvoiceApi.generate(invoice_no, viewId);

                // opening the pdf file
                FileHandleApi.openFile(pdfFile);
              },
              icon: const Icon(Icons.picture_as_pdf_outlined))
        ],
      ),
      body: status == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                margin: const EdgeInsets.only(top: 4, left: 2, right: 2),
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Image.network(
                            "$image",
                            width: double.infinity,
                            height: 70,
                            fit: BoxFit.fill,
                          ),
                          // SizedBox(
                          //   height: 4,
                          // ),
                          Divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Invoice : $invoice_no",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Payment Date: ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Week : $week",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Period: $period",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Associate: $associate",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Total Attendance: $totalAttendance",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
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
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 0, top: 5),
                            child: Text(
                              "FORM",
                              style: TextStyle(
                                  color: app_color,
                                  fontWeight: FontWeight.w700,
                                  // backgroundColor: Color(0xff274C77),
                                  background: Paint()
                                    ..color = Colors.transparent
                                    ..strokeWidth = 17
                                    ..style = PaintingStyle.stroke
                                    ..strokeJoin = StrokeJoin.round),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              associate,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            address,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          // Text(
                          //   "UTR: $utr",
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //   ),
                          // ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text(
                                "UTR: ",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$utr",
                                style: const TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text(
                                "Phone: ",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$phone",
                                style: const TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   "Phone: $phone",
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //   ),
                          // ),
                          // Text(
                          //   "Email: $email",
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //   ),
                          // ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text(
                                "Email: ",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$email",
                                style: const TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 0, top: 5),
                            child: Text(
                              "TO",
                              style: TextStyle(
                                  color: app_color,
                                  fontWeight: FontWeight.w700,
                                  // backgroundColor: Color(0xff274C77),
                                  background: Paint()
                                    ..color = Colors.transparent
                                    ..strokeWidth = 18
                                    ..style = PaintingStyle.stroke
                                    ..strokeJoin = StrokeJoin.round),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              toname,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "$Street, $postcode, $city",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text(
                                "Register Number: ",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$reg_no",
                                style: const TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text(
                                "VAT: ",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$u_vat",
                                style: const TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ],
                    // ),
                    // ),
                    s == false && b == false && d == false
                        ? Container()
                        : Container(
                            height: 1,
                            color: Colors.black,
                          ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 4),
                    //   child:

                    s == true
                        ? FittedBox(
                            child: DataTable(
                              dataRowHeight: 70,
                              headingRowHeight: 50,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'STANDARD SERVICES',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataColumn(
                                    label: Text(
                                  'QTY',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Unit Cost',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Net',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Gross',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ))
                              ],
                              rows: List.generate(standard.length, (index) {
                                final y = standard[index]["name"];
                                final x = standard[index]["value"].toString();
                                final w = standard[index]["amount"];
                                final z = standard[index]["net"];
                                final a = standard[index]["total"];

                                return DataRow(cells: [
                                  DataCell(Container(
                                      width: 200,
                                      child: Text(
                                        y,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ))),
                                  DataCell(Text(
                                    x,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    w,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    z,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    a,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                ]);
                              }),
                            ),
                          )
                        : Container(),

                    b == true
                        ? FittedBox(
                            child: DataTable(
                              dataRowHeight: 70,
                              headingRowHeight: 50,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'BONUS',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataColumn(
                                    label: Text(
                                  'QTY',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'UNIT COST',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                // DataColumn(label: Text('invoice_no')),
                                DataColumn(
                                    label: Text(
                                  'Net',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Gross',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ))
                              ],
                              rows: List.generate(bonus.length, (index) {
                                final y = bonus[index]["name"];
                                final x = bonus[index]["value"].toString();
                                final w = bonus[index]["amount"];
                                final z = bonus[index]["net"];
                                final a = bonus[index]["total"];

                                return DataRow(cells: [
                                  DataCell(Container(
                                      width: 200,
                                      child: Text(
                                        y,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ))),
                                  DataCell(Text(
                                    x,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    w,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    z,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    a,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                ]);
                              }),
                            ),
                          )
                        : Container(),

                    d == true
                        ? FittedBox(
                            child: DataTable(
                              dataRowHeight: 70,
                              headingRowHeight: 50,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'DEDUCTION',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )),
                                DataColumn(
                                    label: Text(
                                  'QTY',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'UNIT COST',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                // DataColumn(label: Text('invoice_no')),
                                DataColumn(
                                    label: Text(
                                  'Net',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Gross',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ))
                              ],
                              rows: List.generate(deduction.length, (index) {
                                final y = deduction[index]["name"];
                                final x = deduction[index]["value"].toString();
                                final w = deduction[index]["amount"];
                                final z = deduction[index]["net"];
                                final a = deduction[index]["total"];

                                return DataRow(cells: [
                                  DataCell(Container(
                                      width: 200,
                                      child: Text(
                                        y,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ))),
                                  DataCell(Text(
                                    x,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    w,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    z,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                  DataCell(Text(
                                    a,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                                ]);
                              }),
                            ),
                          )
                        : Container(),

                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin:
                          const EdgeInsets.only(left: 10, top: 5, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Spacer(flex: 6),
                          Expanded(
                            flex: 4,
                            child: Column(children: const [
                              Text(
                                "I agree and give consent to deduct fees and van charges from my invoices as shown above and approved by myself, to take advantage of combined purchase discounts via Bryanston Logistics Limited, and to repay any driver penalties enforced by law, and/or van repairs on rented vehicles I drive and have total responsibility for.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 12),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'NET : ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        net,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'VAT : ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        vat,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Total : ',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        total,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                      height: 1, color: Colors.grey.shade400),
                                  const SizedBox(
                                    height: 0.5,
                                  ),
                                  Container(
                                      height: 1, color: Colors.grey.shade400),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 5, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bank Name: $b_name",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Sort Code: $s_code",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Account Number: $a_no",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "The VAT shown is your output tax due to HM Revenue & Customs",
                                    style: TextStyle(
                                      fontSize: 12,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "GROSS: $gross",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Due Date: $due_date",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
