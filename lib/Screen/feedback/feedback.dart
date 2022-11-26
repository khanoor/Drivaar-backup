import 'dart:convert';

import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FeedBackState();
  }
}

class FeedBackState extends State<FeedBack> {
  final formKey = GlobalKey<FormState>();

  TextEditingController feedback = TextEditingController();

  String auth_key = '';

  Future<void> feedbackSend() async {
    var response =
        await http.post(Uri.parse("https://www.drivaar.com/api/feedback.php"),
            body: ({
              'action': 'feedback',
              'auth_key': auth_key,
              'feedback': feedback.text,
            }));
    var d = json.decode(response.body);
    var message = d['data']['success'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      // print(feedback.text);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  key() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auth_key = (prefs.getString("auth_key") ?? "");
    });
  }

  @override
  initState() {
    super.initState();
    key();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: app_color,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                child: Text(
                  "Add Feedback",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: app_color,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 5.0, top: 20.0, right: 5.0),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: feedback,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Feedback';
                      } else {
                        feedbackSend();
                      }
                      return null;
                    },
                    maxLines: 5,
                    maxLength: 200,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    cursorColor: app_color,
                    decoration: InputDecoration(
                      labelText: "Enter Feedback",
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: app_color,
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2, color: app_color),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2, color: app_color),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // feedbackSend();
                        if (formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Sending Feedback')),
                          // );
                        }
                      },
                      child: const Text(
                        "Submit Your Feedback",
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        primary: app_color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Go Back",
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        primary: app_color,
                      ),
                      // style: ButtonStyle(
                      //     padding: MaterialStateProperty.all(
                      //         const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                      //     shape:
                      //         MaterialStateProperty.all<RoundedRectangleBorder>(
                      //             RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //     ))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
