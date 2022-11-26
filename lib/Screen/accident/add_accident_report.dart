import 'dart:convert';

import 'package:drivaar/Screen/accident/uploadFile.dart';
import 'package:drivaar/Screen/documents/view_document.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AddAccidentReport extends StatefulWidget {
  String auth_key = '';
  AddAccidentReport({required this.auth_key, Key? key}) : super(key: key);

  @override
  State<AddAccidentReport> createState() => AddAccidentReportState();
}

class AddAccidentReportState extends State<AddAccidentReport> {
  final formKey = GlobalKey<FormState>();
  final contactKey = GlobalKey<FormState>();
  final formSecondKey = GlobalKey<FormState>();
  final accidentKey = GlobalKey<FormState>();

  TextEditingController emergency = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController injury = TextEditingController();
  TextEditingController reg_no = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController formBController = TextEditingController();
  TextEditingController formFController1 = TextEditingController();
  TextEditingController formFController2 = TextEditingController();
  TextEditingController formFController3 = TextEditingController();
  TextEditingController formGController = TextEditingController();
  TextEditingController formHController = TextEditingController();
  TextEditingController formIController = TextEditingController();
  TextEditingController accidentAddress = TextEditingController();

  String DOBDate = '';
  String Date = '';
  TextEditingController getdate = TextEditingController();
  TextEditingController gettime = TextEditingController();

  var get_data = [];
  var dateFormat = DateFormat("HH:mm:ss");
  TimeOfDay accidentTime = TimeOfDay.now();
  String time = 'Select Start Time';

  int radioSecond = 2;
  int radioFifth = 2;
  int radioBlame = 2;
  int radioSignal = 2;
  int radioE = 2;
  int radioF = 2;

  String? country;

  bool isCheck1 = false;
  bool isCheck2 = false;
  bool isCheck3 = false;
  bool isCheck4 = false;

  bool isRoad1 = false;
  bool isRoad2 = false;
  bool isRoad3 = false;

  bool isWeather1 = false;
  bool isWeather2 = false;
  bool isWeather3 = false;
  bool isWeather4 = false;
  bool isWeather5 = false;

  List country_list = [];
  List get_country = [];

  List passenger_data = [];
  List thirdParty_data = [];

  String report_id = '';

  List imageA = [];
  List imageG = [];
  List imageH = [];
  List imageI = [];

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
        print(DOBDate);
        dob.text = DOBDate;
      });
    }
  }

  Future<void> getDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        Date = DateFormat("dd-MM-yyyy").format(date);
        print(Date);
        getdate.text = Date;
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    var fetchTime =
        (await showTimePicker(context: context, initialTime: accidentTime))!;
    if (fetchTime != null) {
      setState(() {
        accidentTime = fetchTime;
        time = '${accidentTime.hour} : ${accidentTime.minute} ';
        timeformat(accidentTime);
      });
    }
  }

  String timeformat(TimeOfDay time) {
    DateTime tempDate = DateFormat("HH:mm")
        .parse(time.hour.toString() + ":" + time.minute.toString());
    return gettime.text = dateFormat.format(tempDate);
  }

  Future<void> getReportData() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/get_reportdata.php"),
        body: ({
          'action': 'get_reportdata',
          'auth_key': widget.auth_key,
        }));
    var d = json.decode(response.body);
    // get_data = d['data']['data'];
    // for (int i = 0; i < get_data.length; i++) {
    setState(() {
      get_data = d['data']['data'];
      report_id = get_data[0]['Id'];
      print(report_id);
    });
    // }
  }

  Future<void> getCountry() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/country_list.php"),
        body: ({
          'action': 'country_list',
        }));
    var d = json.decode(response.body);
    get_country = d['data']['data'];
    for (int i = 0; i < get_country.length; i++) {
      setState(() {
        country_list
            .add("${get_country[i]['name']} (${get_country[i]['code']})");
      });
    }
  }

  Future<void> getPassenger() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/report_passenger_data_list.php"),
        body: ({
          'action': 'report_passenger_data_list',
          'auth_key': widget.auth_key,
          'typeid': '',
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    setState(() {
      passenger_data = d['data']['data'];
      print(passenger_data);
    });
  }

  Future<void> getThirdParty() async {
    var response = await http.post(
        Uri.parse(
            "https://www.drivaar.com/api/report_thirdparty_data_list.php"),
        body: ({
          'action': 'report_thirdparty_data_list',
          'auth_key': widget.auth_key,
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    setState(() {
      thirdParty_data = d['data']['data'];
      print(thirdParty_data);
    });
  }

  Future<void> getImage() async {
    var response = await http.post(
        Uri.parse(
            "https://www.drivaar.com/api/report_thirdparty_data_list.php"),
        body: ({
          'action': 'report_thirdparty_data_list',
          'auth_key': widget.auth_key,
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    setState(() {
      thirdParty_data = d['data']['data'];
      print(thirdParty_data);
    });
  }

  Future<void> fetchImageA() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/incident_imginsert_list.php"),
        body: ({
          'action': 'incident_imginsert_list',
          'auth_key': widget.auth_key,
          'typeid': "1",
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    setState(() {
      imageA = d['data']['data'];
      print(imageA);
    });
  }

  Future<void> fetchImageG() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/incident_imginsert_list.php"),
        body: ({
          'action': 'incident_imginsert_list',
          'auth_key': widget.auth_key,
          'typeid': "2",
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    setState(() {
      imageG = d['data']['data'];
      print(imageG);
    });
  }

  Future<void> fetchImageH() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/incident_imginsert_list.php"),
        body: ({
          'action': 'incident_imginsert_list',
          'auth_key': widget.auth_key,
          'typeid': "3",
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    setState(() {
      imageH = d['data']['data'];
      print(imageH);
    });
  }

  Future<void> fetchImageI() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/incident_imginsert_list.php"),
        body: ({
          'action': 'incident_imginsert_list',
          'auth_key': widget.auth_key,
          'typeid': "4",
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    setState(() {
      imageI = d['data']['data'];
      print(imageI);
    });
  }

  @override
  void initState() {
    super.initState();
    getReportData();
    getCountry();
  }

  Future<void> passengerForm() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/report_passenger_data.php"),
        body: ({
          'action': 'report_passenger_data',
          'auth_key': widget.auth_key,
          "name": name.text,
          'dob': dob.text,
          'contact': contact.text,
          'address': address.text,
          'injury': injury.text,
          'typeid': '1',
          'report_id': report_id
        }));
    var d = json.decode(response.body);
    var message = d['data']['message'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      // Navigator.pop(context, "report");
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<void> thirdPartyForm() async {
    print('yes');
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/report_thirdparty_data.php"),
        body: ({
          'action': 'report_thirdparty_data',
          'auth_key': widget.auth_key,
          "name": name.text,
          'dob': dob.text,
          'contact': contact.text,
          'address': address.text,
          'injury': injury.text,
          'reg_no': reg_no.text,
          'report_id': report_id,
        }));
    var d = json.decode(response.body);
    var message = d['data']['message'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      // Navigator.pop(context, "report");
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<void> submitForm() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/accident_report.php"),
        body: ({
          'action': 'accident_report',
          'auth_key': widget.auth_key,
          'report_id': report_id,
          'title': '',
          'age': '',
          'home_contact': emergency.text,
          'month': '',
          'numberof_driving': '',
          'no_driving': '',
          'ismedical': radioSecond == 1 ? "1" : "0",
          'medical_detail': secondController.text,
          'vehicle_make': "", //get_data[0]['Vehicle Make'],
          'model': '', //get_data[0]['Vehicle Model'],
          'reg_number': '', // get_data[0]['vehicle registration number'],
          'year': '', // get_data[0]['Vehicle Year'],
          'date': getdate.text,
          'time': gettime.text,
          'address': accidentAddress.text,
          'country': country,
          'city': cityController.text,
          'postcode': pinController.text,
          'ispassenger': radioFifth == 1 ? "1" : "0",
          'vehicle_collision': '',
          'property_damage': '',
          'fleet_vehicle': '',
          'vehicle_damage': '',
          'incident_occur': '',
          'isblame': radioBlame == 1 ? "1" : "0",
          'issignal': radioSignal == 1 ? "1" : "0",
          'iscondition': isRoad1 == true && isRoad2 == true && isRoad3 == true
              ? "1,2,3"
              : isRoad1 == true && isRoad2 == true
                  ? "1,2"
                  : isRoad2 == true && isRoad3 == true
                      ? "2,3"
                      : isRoad1 == true && isRoad3 == true
                          ? "1,3"
                          : isRoad1 == true
                              ? "1"
                              : isRoad2 == true
                                  ? "2"
                                  : isRoad3 == true
                                      ? "3"
                                      : "",
          'isweather': isWeather1 == true &&
                  isWeather2 == true &&
                  isWeather3 == true &&
                  isWeather4 == true &&
                  isWeather5 == true
              ? "1,2,3,4,5"
              : isWeather1 == true &&
                      isWeather2 == true &&
                      isWeather3 == true &&
                      isWeather4 == true
                  ? "1,2,3,4"
                  : isWeather2 == true &&
                          isWeather3 == true &&
                          isWeather4 == true &&
                          isWeather1 == true
                      ? "2,3,4,5"
                      : isWeather3 == true &&
                              isWeather4 == true &&
                              isWeather5 == true &&
                              isWeather1 == true
                          ? "3,4,5,1"
                          : isWeather1 == true
                              ? "1"
                              : isWeather2 == true
                                  ? "2"
                                  : isWeather3 == true
                                      ? "3"
                                      : isWeather4 == true
                                          ? "4"
                                          : isWeather5 == true
                                              ? "5"
                                              : "",
          'ispassengerthird_party':
              "", //thirdParty_data == []?"0":thirdParty_data.length,
          'iswitness': '', // passenger_data == []?"0":passenger_data.length,
          'isincident': '',
          'incident_number': '',
          'regional_const': '',
          'further_detail': formFController3.text,
          'Gdescription': formGController.text,
          'Hdescription': formHController.text,
          'Idescription': formIController.text,
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

  bool first = false;
  bool second = false;
  bool third = false;
  bool fourth = false;
  bool fifth = false;
  bool sixth = false;

  String posision = 'Accident Details';

  int currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  ItemScrollController itemScrollController = ItemScrollController();

  List Details = [
    'Accident Details',
    'Passenger Details',
    'Third Party Details',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_color,
        title: const Text("Add Accident Details"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            height: 60,
            child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: Details.length,
                initialScrollIndex: currentStep,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.check_circle,
                          color: Details[index] == posision
                              ? app_color
                              : Colors.black,
                        ),
                      ),
                      Text(
                        Details[index],
                        style: Details[index] == posision
                            ? TextStyle(
                                color: app_color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)
                            : TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                      ),
                    ],
                  );
                }),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: currentStep == 0
                    ? accidentDetails()
                    // Container(
                    //     child: Center(
                    //         child: InkWell(
                    //       onTap: () {
                    // itemScrollController.scrollTo(
                    //     index: 1,
                    //     duration: Duration(milliseconds: 500),
                    //     curve: Curves.easeInOutCubic);

                    // setState(() {
                    //   currentStep = 1;
                    //   posision = "Passenger Details";
                    // });
                    //       },
                    //       child: Text("Next"),
                    //     )),
                    //   )
                    : currentStep == 1
                        ? passengerDetails()
                        : currentStep == 2
                            ? thirdPartyDetails()
                            : Container()),
          ),
        ],
      ),
    );
  }

  Widget accidentDetails() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              first = !first;
            });
          },
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              color: app_color,
              padding: EdgeInsets.only(left: 20),
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "Driver At The Time of The Accident",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        first == true
            ? Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Name",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['name']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Date of Birth",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['dob']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Age",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['age']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Contact No",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['contact']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Email",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['email']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Emergency Contact Number *",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Form(
                      key: contactKey,
                      child: TextFormField(
                        controller: emergency,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              first = true;
                            });
                            return 'Please Enter Emergency Contact';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Emergency Contact",
                            isDense: true,
                            counterText: "",
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 20, 25, 0),
                            hintStyle: TextStyle(color: app_color),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: app_color)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: app_color))),
                      ),
                    ),
                  ],
                ))
            : Container(),
        GestureDetector(
          onTap: () {
            setState(() {
              second = !second;
            });
          },
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              color: app_color,
              padding: EdgeInsets.only(left: 20),
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "Address",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        second == true
            ? Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Address",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['address']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "City / Town",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['town/city']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Country",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['county/district']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Postcode",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['postcode']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Does the driver have any medical conditions? if yes, Provide Details:",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: radioSecond,
                          activeColor: app_color,
                          onChanged: (value) {
                            setState(() {
                              radioSecond = 1;
                            });
                          },
                        ),
                        Text('Yes'),
                        SizedBox(
                          width: 16,
                        ),
                        Radio(
                          value: 2,
                          groupValue: radioSecond,
                          activeColor: app_color,
                          onChanged: (value) {
                            setState(() {
                              radioSecond = 2;
                            });
                          },
                        ),
                        Text('No'),
                      ],
                    ),
                    radioSecond == 1
                        ? Form(
                            key: formSecondKey,
                            child: TextFormField(
                              controller: secondController,
                              cursorColor: app_color,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Details';
                                }
                                return null;
                              },
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: "Enter Details",
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: app_color,
                                ),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: app_color),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: app_color),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ))
            : Container(),
        GestureDetector(
          onTap: () {
            setState(() {
              third = !third;
            });
          },
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              color: app_color,
              padding: EdgeInsets.only(left: 20),
              margin: EdgeInsets.only(
                top: 8,
              ),
              child: Text(
                "Fleet Vehicle Details",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        third == true
            ? Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Register No",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['vehicle registration number']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Vehicle Model",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['Vehicle Model']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Vehicle Make",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['Vehicle Make']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Vehicle Year",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ": ${get_data[0]['Vehicle Year']}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ))
            : Container(),
        GestureDetector(
          onTap: () {
            setState(() {
              fourth = !fourth;
            });
          },
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              color: app_color,
              padding: EdgeInsets.only(left: 20),
              margin: EdgeInsets.only(
                top: 8,
              ),
              child: Text(
                "Accident Occur ?",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        fourth == true
            ? Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(top: 8),
                child: Form(
                  key: accidentKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              child: const Text(
                                'Date',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Time',
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
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              child: TextFormField(
                                controller: getdate,
                                enabled: false,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Date';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    color: Theme.of(context)
                                        .errorColor, // or any other color
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_month_sharp,
                                    color: app_color,
                                    size: 20,
                                  ),
                                  hintText: "dd-mm-yyyy",
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                  hintStyle: TextStyle(color: app_color),
                                  border: const OutlineInputBorder(),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: app_color)),
                                ),
                              ),
                              onTap: () {
                                getDate(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: InkWell(
                                child: TextFormField(
                                  controller: gettime,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Time';
                                    }
                                    return null;
                                  },
                                  cursorColor: app_color,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.watch_later_sharp,
                                      color: app_color,
                                      size: 20,
                                    ),
                                    errorStyle: TextStyle(
                                      color: Theme.of(context)
                                          .errorColor, // or any other color
                                    ),
                                    hintText: "Time",
                                    enabled: false,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        15, 10, 0, 10),
                                    hintStyle: TextStyle(color: app_color),
                                    border: const OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1, color: app_color)),
                                  ),
                                ),
                                onTap: () {
                                  selectTime(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Address',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        maxLines: 3,
                        cursorColor: app_color,
                        controller: accidentAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Adddress';
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1, color: app_color)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1, color: app_color)),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Country',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: app_color,
                              width: 1,
                            )),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            menuMaxHeight: 300,
                            // dropdownColor: Colors.brown[400],
                            // isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: app_color,
                            ),
                            hint: Text(
                              "Select Country",
                              style: TextStyle(
                                color: app_color,
                              ),
                            ),
                            value: country,
                            onChanged: (newValue) {
                              setState(() {
                                country = newValue as String;
                              });
                            },
                            items: country_list.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem,
                                    style: TextStyle(color: app_color)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: const Text(
                                'City / Town',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'PostCode',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: cityController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter City / Town';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter City / Town",
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 25, 25, 0),
                                  hintStyle: TextStyle(color: app_color),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: app_color)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: app_color))),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: pinController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter PostCode';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: "Enter PostCode",
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 25, 25, 0),
                                  hintStyle: TextStyle(color: app_color),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: app_color)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: app_color)),
                                ),
                              ),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        GestureDetector(
          onTap: () {
            setState(() {
              fifth = !fifth;
            });
          },
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              color: app_color,
              padding: EdgeInsets.only(left: 20),
              margin: EdgeInsets.only(
                top: 8,
              ),
              child: Text(
                "Passenger in Fleet Vehicle",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        fifth == true
            ? Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Text(
                      "Passengers in own Vehicle? if yes, please provide their details.",
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: radioFifth,
                          activeColor: app_color,
                          onChanged: (value) {
                            setState(() {
                              radioFifth = 1;
                              // getPassenger();
                            });
                          },
                        ),
                        Text('Yes'),
                        SizedBox(
                          width: 16,
                        ),
                        Radio(
                          value: 2,
                          groupValue: radioFifth,
                          activeColor: app_color,
                          onChanged: (value) {
                            setState(() {
                              radioFifth = 2;
                            });
                          },
                        ),
                        Text('No'),
                        Spacer(),
                        radioFifth == 1
                            ? ElevatedButton(
                                onPressed: () {
                                  itemScrollController.scrollTo(
                                      index: 1,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOutCubic);

                                  setState(() {
                                    currentStep = 1;
                                    posision = "Passenger Details";
                                  });
                                },
                                child: Text("Add"),
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff274C77)))
                            : Container()
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    radioFifth == 1
                        ? FittedBox(
                            child: DataTable(
                              border: TableBorder.all(color: app_color),
                              dataRowHeight: 50,
                              headingRowHeight: 60,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Contact',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Injury',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ))
                              ],
                              rows:
                                  List.generate(passenger_data.length, (index) {
                                final name = passenger_data[index]["name"];
                                final dob = passenger_data[index]["dob"];
                                final address =
                                    passenger_data[index]["address"];
                                final contact =
                                    passenger_data[index]["contact"];
                                final injury = passenger_data[index]["injury"];

                                return DataRow(cells: [
                                  DataCell(Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        name,
                                        // textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ))),
                                  DataCell(Container(
                                      child: Text(
                                    dob,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ))),
                                  DataCell(Container(
                                      child: Text(
                                    address,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ))),
                                  DataCell(Container(
                                      child: Text(
                                    contact,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ))),
                                  DataCell(Container(
                                      child: Text(
                                    injury,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ))),
                                ]);
                              }),
                            ),
                          )
                        : Container()
                  ],
                ))
            : Container(),
        GestureDetector(
          onTap: () {
            setState(() {
              sixth = !sixth;
            });
          },
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              color: app_color,
              padding: EdgeInsets.only(left: 20, top: 2, bottom: 2),
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "First Page Must be Completed in Full / Accident You Was Involved in",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        sixth == true
            ? Container(
                padding: EdgeInsets.only(left: 0, right: 0),
                margin: EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: this.isCheck1,
                          onChanged: (bool? value) {
                            setState(() {
                              this.isCheck1 = value!;
                            });
                          },
                        ),
                        Text("Third Party Vehicle Collision: Complete section")
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: this.isCheck2,
                          onChanged: (bool? value) {
                            setState(() {
                              this.isCheck2 = value!;
                            });
                          },
                        ),
                        Text("Third Party Property Damage: Complete section")
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: this.isCheck3,
                          onChanged: (bool? value) {
                            setState(() {
                              this.isCheck3 = value!;
                            });
                          },
                        ),
                        Text("Theft to Fleet Vehicle: Complete Section")
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: this.isCheck4,
                          onChanged: (bool? value) {
                            setState(() {
                              this.isCheck4 = value!;
                            });
                          },
                        ),
                        Text("Fleet Vehicle Damage: Complete section")
                      ],
                    )
                  ],
                ),
              )
            : Container(),
        SizedBox(
          height: 10,
        ),
        // Column(
        //   children: [
        isCheck1 == true && sixth == true ||
                isCheck2 == true && sixth == true ||
                isCheck3 == true && sixth == true ||
                isCheck4 == true && sixth == true
            ? FormA()
            : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck1 == true && sixth == true ||
                isCheck2 == true && sixth == true ||
                isCheck3 == true && sixth == true ||
                isCheck4 == true && sixth == true
            ? FormB()
            : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck1 == true && sixth == true ||
                isCheck2 == true && sixth == true ||
                isCheck4 == true && sixth == true
            ? FormC()
            : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck1 == true && sixth == true || isCheck2 == true && sixth == true
            ? FormD()
            : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck1 == true && sixth == true ||
                isCheck2 == true && sixth == true ||
                isCheck3 == true && sixth == true
            ? FormE()
            : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck1 == true && sixth == true ||
                isCheck2 == true && sixth == true ||
                isCheck3 == true && sixth == true
            ? FormF()
            : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck1 == true && sixth == true ||
                isCheck2 == true && sixth == true ||
                isCheck3 == true && sixth == true ||
                isCheck4 == true && sixth == true
            ? FormG()
            : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck1 == true && sixth == true ? FormH() : Container(),
        SizedBox(
          height: 5,
        ),
        isCheck2 == true && sixth == true ? FormI() : Container(),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: app_color,
          height: 1,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 4),
          child: Text(
            "STATEMENT OF TRUTH: Proceedings for contempt of court may be brought against anyone who makes or causes to be made a false statement in a witness statement verified by a statement of truth. I believe that the facts stated in this form are true to the best of my knowledge with the information that was provided. I have read and understood the declarations above.",
            textAlign: TextAlign.justify,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {
              // setState(() {
              // if (contactKey.currentState!.validate()) {
              //  ||
              //     (formSecondKey.currentState!.validate() &&
              //         radioSecond == 1) ||
              //     accidentKey.currentState!.validate()) {
              // submitForm();
              //   print('submit');
              // } else
              if (emergency.text == "") {
                setState(() {
                  first = true;
                });
              }
              if (radioSecond == 1 && secondController.text == "") {
                setState(() {
                  second = true;
                });
              }

              if (getdate.text == '' ||
                  gettime.text == '' ||
                  accidentAddress.text == '' ||
                  country == null ||
                  cityController.text == '' ||
                  pinController.text == '') {
                setState(() {
                  fourth = true;
                });
              }

              // if (
              // accidentKey.currentState!.validate() ||
              // (formSecondKey.currentState!.validate() &&
              //     radioSecond == 1) ||
              // contactKey.currentState!.validate()) {
              print("gggg");
              submitForm();
              // }
              // });
            },
            child: Text(
              "Submit",
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
              primary: Color(0xff274C77),
              // primary: Colors.red,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget passengerDetails() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
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
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Passenger Name';
                          }
                          return null;
                        },
                        cursorColor: app_color,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Enter Passenger Name",
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 25, 25, 0),
                          hintStyle: TextStyle(color: app_color),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
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
                                  suffixIcon: Icon(
                                    Icons.calendar_month_sharp,
                                    color: app_color,
                                    size: 20,
                                  ),
                                  hintText: "mm/dd/yyyy",
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 25, 0, 0),
                                  hintStyle: TextStyle(color: app_color),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 2, color: app_color)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 2, color: app_color)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 2, color: app_color)),
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
                                      borderSide: BorderSide(
                                          width: 2, color: app_color)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 2, color: app_color)),
                                ),
                              ),
                            ),
                            flex: 2,
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
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
                                'Nature of Injury',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
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
                              // Navigator.pop(context);
                              itemScrollController.scrollTo(
                                  index: 0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic);

                              setState(() {
                                currentStep = 0;
                                posision = "Accident Details";
                                name.text = '';
                                dob.text = '';
                                contact.text = '';
                                address.text = '';
                                injury.text = '';
                                reg_no.text = '';
                                // getPassenger();
                              });
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
                                passengerForm();
                                itemScrollController.scrollTo(
                                    index: 0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOutCubic);

                                setState(() {
                                  currentStep = 0;
                                  posision = "Accident Details";
                                  name.text = '';
                                  dob.text = '';
                                  contact.text = '';
                                  address.text = '';
                                  injury.text = '';
                                  getPassenger();
                                });
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
      ],
    );
  }

  Widget thirdPartyDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
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
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    contentPadding: const EdgeInsets.fromLTRB(15, 25, 25, 0),
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
                                fontSize: 16.0, fontWeight: FontWeight.bold),
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
                            suffixIcon: Icon(
                              Icons.calendar_month_sharp,
                              color: app_color,
                              size: 20,
                            ),
                            hintText: "mm/dd/yyyy",
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 25, 0, 0),
                            hintStyle: TextStyle(color: app_color),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 2, color: app_color)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 2, color: app_color)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 2, color: app_color)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
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
                        // Navigator.pop(context);
                        itemScrollController.scrollTo(
                            index: 0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic);

                        setState(() {
                          currentStep = 0;
                          posision = "Accident Details";
                          name.text = '';
                          dob.text = '';
                          contact.text = '';
                          address.text = '';
                          injury.text = '';
                          reg_no.text = '';
                          // getThirdParty();
                        });
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
                          thirdPartyForm();
                          itemScrollController.scrollTo(
                              index: 0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic);

                          setState(() {
                            currentStep = 0;
                            posision = "Accident Details";
                            name.text = '';
                            dob.text = '';
                            contact.text = '';
                            address.text = '';
                            injury.text = '';
                            getThirdParty();
                          });
                        }
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
    );
  }

  Widget FormA() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 14, right: 14),
            color: app_color_full.shade600,
            height: 40,
            child: Row(children: [
              Text(
                "A",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  String uploadA = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadFile(
                                report_id: report_id,
                                type: "1",
                              )));
                  if (uploadA == "A") {
                    print("A");
                    fetchImageA();
                  }
                },
                child: const Text(
                  "Upload Files",
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 34),
                  primary: app_color,
                ),
              ),
            ]),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: app_color_full.shade200,
            ),
            height: 40,
            child: Text(
                'Sketch how the incident / accident occurred. (Pictures required)'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: FittedBox(
              child: DataTable(
                border: TableBorder.all(color: app_color),
                dataRowHeight: 30,
                headingRowHeight: 30,
                columns: const [
                  DataColumn(
                      label: Text(
                    'Id',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'View',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                ],
                rows: List.generate(imageA.length, (index) {
                  final id = imageA[index]["report_id"];
                  final dob = imageA[index]["date"];
                  return DataRow(cells: [
                    DataCell(Container(
                        alignment: Alignment.center,
                        child: Text(
                          id,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ))),
                    DataCell(Container(
                        child: Text(
                      dob,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ))),
                    DataCell(Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          padding: const EdgeInsets.only(bottom: 0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewDocument(
                                          name: imageA[index]["report_id"],
                                          imageUrl: imageA[index]["file"],
                                        )));
                          },
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 35,
                          )),
                    ))
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FormB() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 14, right: 14),
            color: app_color_full.shade600,
            height: 40,
            child: Text(
              "B",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: app_color_full.shade200,
            ),
            height: 40,
            child: Text('How did the incident / accident occur?'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              maxLines: 3,
              cursorColor: app_color,
              controller: formBController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Details';
                }
                return null;
              },
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: "Enter Details",
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(15, 25, 25, 0),
                hintStyle: TextStyle(color: app_color),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 2, color: app_color)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 2, color: app_color)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FormC() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 14, right: 14),
            color: app_color_full.shade600,
            height: 40,
            child: Text(
              "C",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("Do you consider yourself to blame ?"),
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: radioBlame,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioBlame = 1;
                  });
                },
              ),
              Text('Yes'),
              SizedBox(
                width: 16,
              ),
              Radio(
                value: 2,
                groupValue: radioBlame,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioBlame = 2;
                  });
                },
              ),
              Text('No'),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("Was signal / warning given by"),
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: radioSignal,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioSignal = 1;
                  });
                },
              ),
              Text('You'),
              SizedBox(
                width: 16,
              ),
              Radio(
                value: 2,
                groupValue: radioSignal,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioSignal = 2;
                  });
                },
              ),
              Text('Third Party'),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("Condition of the road"),
          ),
          Row(
            children: [
              Checkbox(
                value: this.isRoad1,
                onChanged: (bool? value) {
                  setState(() {
                    this.isRoad1 = value!;
                  });
                },
              ),
              Text("Good"),
              Checkbox(
                value: this.isRoad2,
                onChanged: (bool? value) {
                  setState(() {
                    this.isRoad2 = value!;
                  });
                },
              ),
              Text("Average"),
              Checkbox(
                value: this.isRoad3,
                onChanged: (bool? value) {
                  setState(() {
                    this.isRoad3 = value!;
                  });
                },
              ),
              Text("Poor")
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("Weather Conditions"),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: FittedBox(
              child: Row(
                children: [
                  Checkbox(
                    value: this.isWeather1,
                    onChanged: (bool? value) {
                      setState(() {
                        this.isWeather1 = value!;
                      });
                    },
                  ),
                  Text("Dry"),
                  Checkbox(
                    value: this.isWeather2,
                    onChanged: (bool? value) {
                      setState(() {
                        this.isWeather2 = value!;
                      });
                    },
                  ),
                  Text("Raining"),
                  Checkbox(
                    value: this.isWeather3,
                    onChanged: (bool? value) {
                      setState(() {
                        this.isWeather3 = value!;
                      });
                    },
                  ),
                  Text("Snow / Ice"),
                  Checkbox(
                    value: this.isWeather4,
                    onChanged: (bool? value) {
                      setState(() {
                        this.isWeather4 = value!;
                      });
                    },
                  ),
                  Text("Fog"),
                  Checkbox(
                    value: this.isWeather5,
                    onChanged: (bool? value) {
                      setState(() {
                        this.isWeather5 = value!;
                      });
                    },
                  ),
                  Text("Other"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FormD() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 14, right: 14),
            color: app_color_full.shade600,
            height: 40,
            child: Row(children: [
              Text(
                "D",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  itemScrollController.scrollTo(
                      index: 2,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic);

                  setState(() {
                    currentStep = 2;
                    posision = "Third Party Details";
                  });
                },
                child: const Text(
                  "Add Details",
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 34),
                  primary: app_color,
                ),
              ),
            ]),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: app_color_full.shade200,
            ),
            height: 40,
            child: Text('Third Party Details'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: FittedBox(
              child: DataTable(
                border: TableBorder.all(color: app_color),
                dataRowHeight: 30,
                headingRowHeight: 30,
                columns: const [
                  DataColumn(
                      label: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'DOB',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Vehicle Registration Number',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Nature of injury',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                ],
                rows: List.generate(thirdParty_data.length, (index) {
                  final name = thirdParty_data[index]["name"];
                  final dob = thirdParty_data[index]["dob"];
                  final address = thirdParty_data[index]["address"];
                  final contact = thirdParty_data[index]["contact"];
                  final reg_no = thirdParty_data[index]["reg_no"];
                  final injury = thirdParty_data[index]["injury"];
                  return DataRow(cells: [
                    DataCell(Container(
                        alignment: Alignment.center,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ))),
                    DataCell(Container(
                        child: Text(
                      dob,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ))),
                    DataCell(Container(
                        child: Text(
                      address,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ))),
                    DataCell(Container(
                        child: Text(
                      contact,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ))),
                    DataCell(Container(
                        child: Text(
                      reg_no,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ))),
                    DataCell(Container(
                        child: Text(
                      injury,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ))),
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FormE() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 14, right: 14),
            color: app_color_full.shade600,
            height: 40,
            child: Text(
              "E",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: app_color_full.shade200,
            ),
            height: 40,
            child: Text('Witnesses'),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 10),
            margin: EdgeInsets.only(top: 8),
            child: Text(
              "Witnesses see the incident / accident? If yes, please provide their details",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: radioE,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioE = 1;
                  });
                },
              ),
              Text('Yes'),
              SizedBox(
                width: 16,
              ),
              Radio(
                value: 2,
                groupValue: radioE,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioE = 2;
                  });
                },
              ),
              Text('No'),
              Spacer(),
              radioE == 1
                  ? ElevatedButton(
                      onPressed: () {
                        itemScrollController.scrollTo(
                            index: 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic);

                        setState(() {
                          currentStep = 1;
                          posision = "Passenger Details";
                        });
                      },
                      child: Text("Add Details"))
                  : Container()
            ],
          ),
          SizedBox(
            height: 8,
          ),
          radioE == 1
              ? FittedBox(
                  child: DataTable(
                    border: TableBorder.all(color: app_color),
                    dataRowHeight: 50,
                    headingRowHeight: 60,
                    columns: const [
                      DataColumn(
                          label: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Injury',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ))
                    ],
                    rows: List.generate(passenger_data.length, (index) {
                      final name = passenger_data[index]["name"];
                      final dob = passenger_data[index]["dob"];
                      final address = passenger_data[index]["address"];
                      final contact = passenger_data[index]["contact"];
                      final injury = passenger_data[index]["injury"];

                      return DataRow(cells: [
                        DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(
                              name,
                              // textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ))),
                        DataCell(Container(
                            child: Text(
                          dob,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ))),
                        DataCell(Container(
                            child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ))),
                        DataCell(Container(
                            child: Text(
                          contact,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ))),
                        DataCell(Container(
                            child: Text(
                          injury,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ))),
                      ]);
                    }),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget FormF() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 14, right: 14),
            color: app_color_full.shade600,
            height: 40,
            child: Text(
              "F",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: app_color_full.shade200,
            ),
            height: 40,
            child: Text('Police Involvement'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16, right: 10),
            margin: EdgeInsets.only(top: 8),
            child: Text(
              "Was the police notified or involved in this incident?",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: radioF,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioF = 1;
                  });
                },
              ),
              Text('Yes'),
              SizedBox(
                width: 16,
              ),
              Radio(
                value: 2,
                groupValue: radioF,
                activeColor: app_color,
                onChanged: (value) {
                  setState(() {
                    radioF = 2;
                  });
                },
              ),
              Text('No'),
            ],
          ),
          radioF == 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 10, top: 0),
                      child: Text(
                        'Incident Number:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                      child: TextFormField(
                        cursorColor: app_color,
                        controller: formFController1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Incident Number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          hintText: "Enter Incident Number",
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 25, 25, 0),
                          hintStyle: TextStyle(color: app_color),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 10, top: 4),
                      child: Text(
                        'Regional Constabulary:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                      child: TextFormField(
                        cursorColor: app_color,
                        controller: formFController2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Regional Constabulary';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          hintText: "Regional Constabulary",
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 25, 25, 0),
                          hintStyle: TextStyle(color: app_color),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 2, color: app_color)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 10, top: 4),
            child: Text(
              'Further Details',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 6),
            child: TextFormField(
              maxLines: 3,
              cursorColor: app_color,
              controller: formFController3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Details';
                }
                return null;
              },
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: "Enter Details",
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(15, 25, 25, 0),
                hintStyle: TextStyle(color: app_color),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 2, color: app_color)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 2, color: app_color)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FormG() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 14, right: 14),
          color: app_color_full.shade600,
          height: 40,
          child: Row(children: [
            Text(
              "G",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                String uploadG = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadFile(
                              report_id: report_id,
                              type: "2",
                            )));
                if (uploadG == "A") {
                  print("A");
                  fetchImageG();
                }
              },
              child: const Text(
                "Upload Files",
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 34),
                primary: app_color,
              ),
            ),
          ]),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: app_color_full.shade200,
          ),
          height: 40,
          child: Text('Fleet Vehicle Damage'),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16, right: 10),
          margin: EdgeInsets.only(top: 8),
          child: Text(
            "Give details below and tick damaged areas on the diagram opposite (Pictures Required)",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 10, top: 8),
          child: Text(
            'Description',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 10),
          child: TextFormField(
            maxLines: 3,
            cursorColor: app_color,
            controller: formGController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Description';
              }
              return null;
            },
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: "Enter Description",
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(15, 25, 25, 0),
              hintStyle: TextStyle(color: app_color),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2, color: app_color)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2, color: app_color)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: FittedBox(
            child: DataTable(
              border: TableBorder.all(color: app_color),
              dataRowHeight: 30,
              headingRowHeight: 30,
              columns: const [
                DataColumn(
                    label: Text(
                  'Id',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'Type',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'View',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ],
              rows: List.generate(imageG.length, (index) {
                final name = imageG[index]["report_id"];
                final dob = imageG[index]["date"];
                return DataRow(cells: [
                  DataCell(Container(
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ))),
                  DataCell(Container(
                      child: Text(
                    dob,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ))),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewDocument(
                                        name: imageG[index]["report_id"],
                                        imageUrl: imageG[index]["file"],
                                      )));
                        },
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 35,
                        )),
                  ))
                ]);
              }),
            ),
          ),
        ),
      ]),
    );
  }

  Widget FormH() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 14, right: 14),
          color: app_color_full.shade600,
          height: 40,
          child: Row(children: [
            Text(
              "H",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                String uploadH = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadFile(
                              report_id: report_id,
                              type: "3",
                            )));
                if (uploadH == "A") {
                  print("A");
                  fetchImageH();
                }
              },
              child: const Text(
                "Upload Files",
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 34),
                primary: app_color,
              ),
            ),
          ]),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: app_color_full.shade200,
          ),
          height: 40,
          child: Text('Third Party Vehicle Damage'),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16, right: 10),
          margin: EdgeInsets.only(top: 8),
          child: Text(
            "Provide details below and tick damaged areas on the diagram opposite. (Pictures required)",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 10, top: 8),
          child: Text(
            'Description',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 10),
          child: TextFormField(
            maxLines: 3,
            cursorColor: app_color,
            controller: formHController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Description';
              }
              return null;
            },
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: "Enter Description",
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(15, 25, 25, 0),
              hintStyle: TextStyle(color: app_color),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2, color: app_color)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2, color: app_color)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: FittedBox(
            child: DataTable(
              border: TableBorder.all(color: app_color),
              dataRowHeight: 30,
              headingRowHeight: 30,
              columns: const [
                DataColumn(
                    label: Text(
                  'Id',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'Type',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'View',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ],
              rows: List.generate(imageH.length, (index) {
                final name = imageH[index]["report_id"];
                final dob = imageH[index]["date"];
                return DataRow(cells: [
                  DataCell(Container(
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ))),
                  DataCell(Container(
                      child: Text(
                    dob,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ))),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: IconButton(
                        padding: const EdgeInsets.only(bottom: 0),
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ViewInvoice(
                          //               invoice_no: invoice_data[index]
                          //                   ["invoice_no"],
                          //               viewId: invoice_data[index]
                          //                   ["View_id"],
                          //             )));
                        },
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 35,
                        )),
                  ))
                ]);
              }),
            ),
          ),
        ),
      ]),
    );
  }

  Widget FormI() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 14, right: 14),
          color: app_color_full.shade600,
          height: 40,
          child: Row(children: [
            Text(
              "I",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                String uploadI = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadFile(
                              report_id: report_id,
                              type: "4",
                            )));
                if (uploadI == "A") {
                  print("A");
                  fetchImageI();
                }
              },
              child: const Text(
                "Upload Files",
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 34),
                primary: app_color,
              ),
            ),
          ]),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: app_color_full.shade200,
          ),
          height: 40,
          child: Text('Third Party Property Damage'),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16, right: 10),
          margin: EdgeInsets.only(top: 8),
          child: Text(
            "Sketch how the incident / accident occurred. (Pictures required)",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 10, top: 8),
          child: Text(
            'Description',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 10),
          child: TextFormField(
            maxLines: 3,
            cursorColor: app_color,
            controller: formIController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Description';
              }
              return null;
            },
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: "Enter Description",
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(15, 25, 25, 0),
              hintStyle: TextStyle(color: app_color),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2, color: app_color)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2, color: app_color)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: FittedBox(
            child: DataTable(
              border: TableBorder.all(color: app_color),
              dataRowHeight: 30,
              headingRowHeight: 30,
              columns: const [
                DataColumn(
                    label: Text(
                  'Id',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'Type',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'View',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ],
              rows: List.generate(imageI.length, (index) {
                final name = imageI[index]["report_id"];
                final dob = imageI[index]["date"];

                return DataRow(cells: [
                  DataCell(Container(
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ))),
                  DataCell(Container(
                      child: Text(
                    dob,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ))),
                  DataCell(Container(
                    alignment: Alignment.center,
                    child: IconButton(
                        padding: const EdgeInsets.only(bottom: 0),
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ViewInvoice(
                          //               invoice_no: invoice_data[index]
                          //                   ["invoice_no"],
                          //               viewId: invoice_data[index]
                          //                   ["View_id"],
                          //             )));
                        },
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 35,
                        )),
                  ))
                ]);
              }),
            ),
          ),
        ),
      ]),
    );
  }

  // showAlartDailog(
  //   BuildContext context,
  // ) {
  //   return AlertDialog(
  //     title: Container(
  //       child: Column(
  //         children: [
  //           Padding(padding: EdgeInsets.only(bottom: 20), child: Text("sa")),
  //           // Padding(
  //           //   padding: const EdgeInsets.all(8.0),
  //           //   child: GridView.builder(
  //           //       itemCount: imageFileList!.length,
  //           //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           //           crossAxisCount: 3),
  //           //       itemBuilder: (BuildContext context, int index) {
  //           //         return Image.file(
  //           //           File(imageFileList![index].path),
  //           //           fit: BoxFit.cover,
  //           //         );
  //           //       }),
  //           // ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
