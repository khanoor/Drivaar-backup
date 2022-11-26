import 'dart:convert';

import 'package:drivaar/Screen/documents/view_document.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Document extends StatefulWidget {
  const Document({Key? key}) : super(key: key);

  @override
  State<Document> createState() => DocumentState();
}

class DocumentState extends State<Document> {
  var size;
  double itemWidth = 0;
  double itemHeight = 0;

  List document = [];

  Future<String?> fetch_document() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/document_list.php"),
        body: ({
          "action": "document_list",
          "auth_key": global_auth_key,
        }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        document = convert_data_to_json['data']['data'];
        // print(document);
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
    fetch_document();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Documents"),
        backgroundColor: Color(0xff274C77),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: GridView.count(
            // physics: NeverScrollableScrollPhysics(),
            primary: true,
            childAspectRatio: (itemWidth / itemHeight) * 1.3,
            crossAxisSpacing: 10,
            // mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(document.length, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            document[index]['typename'],
                            // textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xff373737),
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewDocument(
                                    name: document[index]['typename'],
                                    imageUrl: document[index]['file'],
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(
                              2.0,
                              2.0,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image(
                              image: NetworkImage(document[index]['file']),
                              height: 180,
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          )),
    );
  }
}
