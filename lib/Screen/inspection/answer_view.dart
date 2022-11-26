import 'dart:convert';

import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnswerView extends StatefulWidget {
  List question = [];
  List answer = [];
  AnswerView({Key? key, required this.question, required this.answer})
      : super(key: key);

  @override
  State<AnswerView> createState() => _AnswerViewState();
}

class _AnswerViewState extends State<AnswerView> {
  // final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  // Future<String?> getAnswer(id) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  //   // setState(() {
  //   //   answer = (prefs.getString("Question $id") ?? "");
  //   //   print(answer);
  //   // });
  //   String? answer = prefs.getString("Question $id"); // ?? "");
  //   print(answer);
  //   return answer;
  // }

  Future<String?> Submit() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/inspection_data.php"),
            body: ({
              "action": "inspection_data",
              "auth_key": global_auth_key,
            }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['message'];
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      Navigator.of(context)
        ..pop()
        ..pop();
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  String getAnswer(int id) {
    return widget.answer[id];
  }

  // @override
  // void initState() {
  //   // getQuestion();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // print(widget.answer);
    return Scaffold(
      appBar: AppBar(
        title: Text(" Answer Review"),
        
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: widget.question.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, right: 15, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: app_color),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(
                                    2.0,
                                    2.0,
                                  ),
                                  blurRadius: 10.0,
                                  // spreadRadius: 2.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white,
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 5, right: 20, bottom: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      widget.question[index]['question'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      // prefs.toString(),// getString(
                                      // "Question ${widget.question[index]['id']}") ??
                                      //"",
                                      getAnswer(index),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }),
              ),
              ElevatedButton(
                onPressed: () {
                  Submit();
                },
                child: const Text("SUBMIT"),
              ),
            ],
          ),
          widget.question.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }
}
