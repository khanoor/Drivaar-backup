import 'dart:convert';

import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddThirdPartyReport extends StatefulWidget {
  const AddThirdPartyReport({Key? key}) : super(key: key);

  @override
  State<AddThirdPartyReport> createState() => AddThirdPartyReportState();
}

class AddThirdPartyReportState extends State<AddThirdPartyReport> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController injury = TextEditingController();
  TextEditingController reg_no = TextEditingController();
  String DOBDate = '';

  Future<void> getDOB(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // firstDate: DateTime.now().subtract(const Duration(days: 0)),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        DOBDate = DateFormat("MM/dd/yyyy").format(date);
        // print(DOBDate);
        dob.text = DOBDate;
      });
    }
  }

  Future<void> submitForm() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/report_thirdparty_data.php"),
        body: ({
          'action': 'report_thirdparty_data',
          'auth_key': global_auth_key,
          "name": name.text,
          'dob': dob.text,
          'contact': contact.text,
          'address': address.text,
          'injury': injury.text,
          'reg_no': '',
          'report_id': 'report_id',
        }));
    var d = json.decode(response.body);
    var message = d['data']['message'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      Navigator.pop(context, "report");
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Third Party Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      cursorColor: app_color,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 25, 25, 0),
                        hintStyle: TextStyle(color: app_color),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 2, color: app_color)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 2, color: app_color)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: const Text(
                              'Date of Birth',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Container(
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Contact No',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: InkWell(
                            child: TextFormField(
                              controller: dob,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter DOB';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "mm/dd/yyyy",
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 25, 25, 0),
                                hintStyle: TextStyle(color: app_color),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide:
                                        BorderSide(width: 2, color: app_color)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide:
                                        BorderSide(width: 2, color: app_color)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide:
                                        BorderSide(width: 2, color: app_color)),
                              ),
                            ),
                            onTap: () {
                              getDOB(context);
                            },
                          ),
                          flex: 2,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              // inputFormatters: <TextInputFormatter>[
                              //   FilteringTextInputFormatter.digitsOnly
                              // ],
                              controller: contact,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Contact No';
                                }
                                return null;
                              },
                              cursorColor: app_color,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                hintText: "Enter Contact No",
                                counterText: "",
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 25, 25, 0),
                                hintStyle: TextStyle(color: app_color),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide:
                                        BorderSide(width: 2, color: app_color)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    borderSide:
                                        BorderSide(width: 2, color: app_color)),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Text(
                              'Register No',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: TextFormField(
                            cursorColor: app_color,
                            controller: reg_no,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Register No';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Enter Register No",
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 25, 25, 0),
                              hintStyle: TextStyle(color: app_color),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 2, color: app_color)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 2, color: app_color)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Text(
                              'Address',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: TextFormField(
                            maxLines: 3,
                            cursorColor: app_color,
                            controller: address,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Address';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              hintText: "Enter Address",
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 25, 25, 0),
                              hintStyle: TextStyle(color: app_color),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 2, color: app_color)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 2, color: app_color)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Text(
                              'Injury',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: TextFormField(
                            cursorColor: app_color,
                            controller: injury,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Injury Details';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Enter Injury Details",
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 25, 25, 0),
                              hintStyle: TextStyle(color: app_color),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 2, color: app_color)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 2, color: app_color)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 40),
                            primary: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //       content: Text('Sending Feedback')),
                              // );
                              // submitForm();
                            }
                            // print(DateFormat("H:mm:s").format(DateTime.now()));
                          },
                          child: const Text(
                            "Submit",
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 40),
                            primary: app_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
