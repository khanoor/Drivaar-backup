import 'package:drivaar/Screen/documents/view_document.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';

class PcnView extends StatefulWidget {
  String id;
  List pcn_data;
  PcnView({required this.pcn_data, Key? key, required this.id})
      : super(key: key);

  @override
  State<PcnView> createState() => PcnViewState();
}

class PcnViewState extends State<PcnView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Loan ID ${widget.id}"),
      ),
      body: ListView.builder(
          itemCount: widget.pcn_data.length,
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
                  padding:
                      EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
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
                                      "Loan ID",
                                      style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w600,
                                          color: app_color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      ": ${widget.pcn_data[index]["loanid"]}",
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
                                      "Amount",
                                      style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w600,
                                          color: app_color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      ": ${widget.pcn_data[index]["amount"]}",
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
                                      "Category",
                                      style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w600,
                                          color: app_color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      ": ${widget.pcn_data[index]["category"]}",
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
                                      "Invoiced",
                                      style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w600,
                                          color: app_color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      ": ${widget.pcn_data[index]["invoiced"]}",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Paid",
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
                                          ": ${widget.pcn_data[index]["paid"]}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: widget.pcn_data[index]
                                                        ["paid"] ==
                                                    "paid"
                                                ? Colors.lightGreen
                                                : Colors.redAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Deduction Date",
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
                                          ": ${widget.pcn_data[index]["deductiondate"].toString().split("(").first}",
                                          style: TextStyle(
                                              fontSize: 14, color: app_color
                                              // fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          "  ( ${widget.pcn_data[index]["deductiondate"].toString().split("(").last}",
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
                        height: 160,
                        width: 45,
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
                                    builder: (context) => ViewDocument(
                                        name: widget.pcn_data[index]
                                            ["invoiced"],
                                        imageUrl: widget.pcn_data[index]
                                            ["file"])));
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
            );
          }),
    );
  }
}
