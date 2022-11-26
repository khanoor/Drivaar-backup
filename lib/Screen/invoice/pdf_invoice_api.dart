import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class PdfInvoiceApi {
  static Future<File> generate(String invoice_no, String view_id) async {
    final pdf = pw.Document();

    List invoice_view = [];
    List invoice_standard = [];
    var invoice_bonus = [];
    var invoice_deduction = [];
    var details;
    var image;
    bool s = true;
    bool b = true;
    bool d = true;
    String week = '';
    String period = '';
    String totalAttendance = '';
    String associate = '';
    String net = '';
    String gross = '';
    String total = '';
    String vat = '';
    String b_name = '';
    String a_no = '';
    String s_code = '';
    String due_date = '';

    //Form Data
    String address = '';
    String utr = '';
    String phone = '';
    String email = '';

    //To Data
    String toname = '';
    String t_vat = '';
    String reg_no = '';
    String Street = '';
    String postcode = '';
    String city = '';

    //Standard Table Data
    String service = '';
    String qty = '';
    String unit = '';
    String t_net = '';
    String t_gross = '';

    // Bonus Table Data

    // Deduction Table Data

    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/view_invoice.php"),
        body: ({
          "action": "view_invoice",
          "invoiceno": invoice_no, //"1C00NAW42", //invoice_no,
          "viewid":
              view_id //"NDIjMSM0OSMyMDIxI05ESWpNU00wT1NNeU1ESXg=" //view_id,
        }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      invoice_view = convert_data_to_json['data']['data'];
      print(invoice_view);
      for (int i = 0; i < invoice_view.length; i++) {
        // invoice_standard = invoice_view[i]["detail"]["type"][0]["subdetail"];
        // invoice_bonus = invoice_view[i]["detail"]["type2"][0]["subdetail"];
        // invoice_deduction = invoice_view[i]["detail"]["type3"][0]["subdetail"];
        image = invoice_view[i]["image_logo"];
        week = invoice_view[i]["week_no"];
        period = invoice_view[i]["period"];
        associate = invoice_view[i]["associate"];
        net = invoice_view[i]["net"].toStringAsFixed(2);
        gross = invoice_view[i]["gross"].toStringAsFixed(2);
        total = invoice_view[i]["total"].toStringAsFixed(2);
        vat = invoice_view[i]["vat"].toStringAsFixed(2);
        totalAttendance = invoice_view[i]["totalAttendance"].toString();
        a_no = invoice_view[i]["account_number"];
        b_name = invoice_view[i]["bank_name"];
        s_code = invoice_view[i]["sort_code"];
        due_date = invoice_view[i]["duedate"];
        address = invoice_view[i]["form"][i]["address"];
        utr = invoice_view[i]["form"][i]["utr"];
        phone = invoice_view[i]["form"][i]["phone"];
        email = invoice_view[i]["form"][i]["email"];
        toname = invoice_view[i]["to"][i]["name"];
        postcode = invoice_view[i]["to"][i]["postcode"];
        t_vat = invoice_view[i]["to"][i]["vat"];
        Street = invoice_view[i]["to"][i]["street"];
        city = invoice_view[i]["to"][i]["city"];
        reg_no = invoice_view[i]["to"][i]["registration_no"];
        details = invoice_view[i]['detail'];

        // details.length == 0
        //     ? invoice_standard
        //     : invoice_standard =
        //         invoice_view[i]['detail']["type"][i]["subdetail"];

        details.toString().contains("type1")
            ? invoice_standard =
                invoice_view[i]["detail"]["type1"][0]["subdetail"]
            : s = false;

        details.toString().contains("type3")
            ? invoice_deduction =
                invoice_view[i]["detail"]["type3"][0]["subdetail"]
            : d = false;

        details.toString().contains("type2")
            ? invoice_bonus = invoice_view[i]["detail"]["type2"][0]["subdetail"]
            : b = false;

        print(invoice_standard);
        print(invoice_standard.length);
        print(invoice_bonus);
        print(invoice_deduction);
      }
    }

    final iconImage =
        (await rootBundle.load('images/logo.jpeg')).buffer.asUint8List();

    // STANDARD Table

    final s_tableHeaders = [
      'STANDARD SERVICES',
      'QUANTITY',
      'UNIT COST',
      'NET',
      'GROSS',
    ];

    final s_tableData = [[]];

    List.generate(invoice_standard.length, (index) {
      service = invoice_standard[index]["name"];
      qty = invoice_standard[index]["value"].toString();
      unit = invoice_standard[index]["amount"];
      t_net = invoice_standard[index]["net"];
      t_gross = invoice_standard[index]["total"];

      List d = [service, qty, unit, t_net, t_gross];
      s_tableData.add(d);
    });

    // Bouns Table

    final b_tableHeaders = [
      'BONUS',
      'QUANTITY',
      'UNIT COST',
      'NET',
      'GROSS',
    ];

    final b_tableData = [[]];

    List.generate(invoice_bonus.length, (index) {
      service = invoice_bonus[index]["name"];
      qty = invoice_bonus[index]["value"].toString();
      unit = invoice_bonus[index]["amount"];
      t_net = invoice_bonus[index]["net"];
      t_gross = invoice_bonus[index]["total"];

      List d = [service, qty, unit, t_net, t_gross];
      //  d.add(service);
      b_tableData.add(d);
    });

    // Deduction Table

    final d_tableHeaders = [
      'DEDUCTION',
      'QUANTITY',
      'UNIT COST',
      'NET',
      'GROSS',
    ];

    final d_tableData = [[]];

    List.generate(invoice_deduction.length, (index) {
      service = invoice_deduction[index]["name"];
      qty = invoice_deduction[index]["value"].toString();
      unit = invoice_deduction[index]["amount"];
      t_net = invoice_deduction[index]["net"];
      t_gross = invoice_deduction[index]["total"];

      List d = [service, qty, unit, t_net, t_gross];
      //  d.add(service);
      d_tableData.add(d);
    });

    pdf.addPage(
      pw.MultiPage(
        // header: (context) {
        //   return pw.Text(
        //     'Flutter Approach',
        //     style: pw.TextStyle(
        //       fontWeight: pw.FontWeight.bold,
        //       fontSize: 15.0,
        //     ),
        //   );
        // },
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Image(
                  pw.MemoryImage(iconImage),
                  height: 72,
                  width: 72,
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INVOICE: $invoice_no',
                      style: pw.TextStyle(
                        fontSize: 18.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Payment Date: ',
                      style: const pw.TextStyle(
                        fontSize: 14.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Week : $week",
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Period: $period",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Associate: $associate",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Total Attendance: $totalAttendance",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.only(top: 1),
                        child: pw.Text(
                          "FORM",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 16
                              // backgroundColor: Color(0xff274C77),
                              // background: Paint()
                              //   ..color = app_color
                              //   ..strokeWidth = 17
                              //   ..style = PaintingStyle.stroke
                              //   ..strokeJoin = StrokeJoin.round
                              ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 12),
                        child: pw.Text(
                          associate,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        address,
                        style: const pw.TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        "UTR: $utr",
                        style: const pw.TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        "Phone: $phone",
                        style: const pw.TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        "Email: $email",
                        style: const pw.TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10),
                  child: pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.only(top: 5),
                          child: pw.Text(
                            "TO",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 16
                                // backgroundColor: Color(0xff274C77),
                                // background: Paint()
                                //   ..color = app_color
                                //   ..strokeWidth = 18
                                //   ..style = PaintingStyle.stroke
                                //   ..strokeJoin = StrokeJoin.round
                                ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 12),
                          child: pw.Text(
                            toname,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Text(
                          Street,
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          "$postcode, $city",
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          "Register Number: $reg_no",
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          "VAT: $t_vat",
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// Standard Table Create
            ///
            s == true
                ? pw.Table.fromTextArray(
                    headers: s_tableHeaders,
                    data: s_tableData,
                    border: null,
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    cellHeight: 10.0,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                    },
                    columnWidths: {
                      0: const pw.FlexColumnWidth(240),
                      1: const pw.FlexColumnWidth(100),
                      2: const pw.FlexColumnWidth(100),
                      3: const pw.FlexColumnWidth(100),
                      4: const pw.FlexColumnWidth(100),
                    },
                  )
                : pw.Container(),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),

            // Bouns Table Create

            b == true
                ? pw.Table.fromTextArray(
                    headers: b_tableHeaders,
                    data: b_tableData,
                    border: null,
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    cellHeight: 10.0,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                    },
                    columnWidths: {
                      0: const pw.FlexColumnWidth(240),
                      1: const pw.FlexColumnWidth(100),
                      2: const pw.FlexColumnWidth(100),
                      3: const pw.FlexColumnWidth(100),
                      4: const pw.FlexColumnWidth(100),
                    },
                  )
                : pw.Container(),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),

            // Deduction Table Create

            d == true
                ? pw.Table.fromTextArray(
                    headers: d_tableHeaders,
                    data: d_tableData,
                    border: null,
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    cellHeight: 10.0,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                    },
                    columnWidths: {
                      0: const pw.FlexColumnWidth(240),
                      1: const pw.FlexColumnWidth(100),
                      2: const pw.FlexColumnWidth(100),
                      3: const pw.FlexColumnWidth(100),
                      4: const pw.FlexColumnWidth(100),
                    },
                  )
                : pw.Container(),

            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            pw.Container(height: 1, color: PdfColors.grey400),
            pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
            pw.Container(height: 1, color: PdfColors.grey400),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            // pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(children: [
                      pw.Text(
                          "I agree and give consent to deduct fees and van charges from my invoices as shown above and approved by myself, to take advantage of combined purchase discounts via Bryanston Logistics Limited, and to repay any driver penalties enforced by law, and/or van repairs on rented vehicles I drive and have total responsibility for.",
                          textAlign: pw.TextAlign.justify),
                    ]),
                  ),
                  pw.Spacer(),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 15),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  'NET : ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Text(
                                net,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  'VAT : ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Text(
                                vat,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.Divider(),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  'Total : ',
                                  style: pw.TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Text(
                                total,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 2 * PdfPageFormat.mm),
                          pw.Container(height: 1, color: PdfColors.grey400),
                          pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                          pw.Container(height: 1, color: PdfColors.grey400),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Bank Name: $b_name",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "Sort Code: $s_code",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "Account Number: $a_no",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ]),
              ),
              pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "The VAT shown is your output tax due to HM Revenue & Customs",
                        style: const pw.TextStyle(
                          fontSize: 12,
                          // fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "GROSS: $gross",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "Due Date: $due_date",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ]),
              ),
            ]),
          ];
        },
        // footer: (context) {
        //   return pw.Column(
        //     mainAxisSize: pw.MainAxisSize.min,
        //     children: [
        //       pw.Divider(),
        //       pw.SizedBox(height: 2 * PdfPageFormat.mm),
        //       pw.Text(
        //         'Flutter Approach',
        //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //       ),
        //       pw.SizedBox(height: 1 * PdfPageFormat.mm),
        //       pw.Row(
        //         mainAxisAlignment: pw.MainAxisAlignment.center,
        //         children: [
        //           pw.Text(
        //             'Address: ',
        //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //           ),
        //           pw.Text(
        //             'Merul Badda, Anandanagor, Dhaka 1212',
        //           ),
        //         ],
        //       ),
        //       pw.SizedBox(height: 1 * PdfPageFormat.mm),
        //       pw.Row(
        //         mainAxisAlignment: pw.MainAxisAlignment.center,
        //         children: [
        //           pw.Text(
        //             'Email: ',
        //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //           ),
        //           pw.Text(
        //             'flutterapproach@gmail.com',
        //           ),
        //         ],
        //       ),
        //     ],
        //   );
        // },
      ),
    );

    return FileHandleApi.saveDocument(name: '$associate.pdf', pdf: pdf);
  }
}
