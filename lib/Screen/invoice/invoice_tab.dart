import 'package:drivaar/Screen/invoice/invoice.dart';
import 'package:drivaar/Screen/invoice/pcn.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';

class InvoiceTab extends StatefulWidget {
  InvoiceTab({Key? key}) : super(key: key);

  @override
  State<InvoiceTab> createState() => InvoiceTabState();
}

class InvoiceTabState extends State<InvoiceTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Invoice"),
          backgroundColor: Color(0xff274C77),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Invoices",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  "PCN",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          Invoice(auth_key: global_auth_key),
          PCN()
        ]),
      ),
    );
  }
}
