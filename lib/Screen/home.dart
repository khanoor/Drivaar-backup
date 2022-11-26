// import 'dart:async';
// import 'dart:convert';
// import 'package:drivaar/Screen/accident/accident_report.dart';
// import 'package:drivaar/Screen/authentication/login_register.dart';
// import 'package:drivaar/Screen/feedback/feedback.dart';
// import 'package:drivaar/Screen/inspection/inspection_question.dart';
// import 'package:drivaar/Screen/invoice/invoice.dart';
// import 'package:drivaar/Screen/offences/offences_list.dart';
// import 'package:drivaar/Screen/profile.dart';
// import 'package:drivaar/Screen/leave/leave_list.dart';
// import 'package:drivaar/global/global.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// String formatTime(int milliseconds) {
//   var secs = milliseconds ~/ 1000;
//   var hours = (secs ~/ 3600).toString().padLeft(2, '0');
//   var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
//   var seconds = (secs % 60).toString().padLeft(2, '0');
//   return "$hours:$minutes:$seconds";
// }

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return HomeState();
//   }
// }

// class HomeState extends State<Home> {
//   final formKey = GlobalKey<FormState>();

//   TextEditingController request = TextEditingController();

//   bool status = true;

//   String auth_key = '';

//   String selectedStartDate = 'Start Date';
//   String selectedEndDate = 'End Date';

//   DateTime currentDate = DateTime.now();

//   Future<void> clockIn() async {
//     var response =
//         await http.post(Uri.parse("https://www.drivaar.com/api/clockIn.php"),
//             body: ({
//               'auth_key': auth_key,
//               'action': 'clockin',
//               'starts': DateFormat("H:mm:s").format(DateTime.now()),
//               'description': ""
//             }));
//     var d = json.decode(response.body);
//     var message = d['data']['error'];
//     if (response.statusCode == 200 && d['status'] == 1) {
//       Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1);
//       Navigator.pop(context);
//       handleStartStop();
//     } else {
//       Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1);
//     }
//   }

//   Future<void> clockOut() async {
//     var response =
//         await http.post(Uri.parse("https://www.drivaar.com/api/clockOut.php"),
//             body: ({
//               'auth_key': auth_key,
//               'action': 'clockout',
//               'end': DateFormat("H:mm:s").format(DateTime.now()),
//               'description': "",
//               "id": ""
//             }));
//     var d = json.decode(response.body);
//     var message = d['data']['error'];
//     if (response.statusCode == 200 && d['status'] == 1) {
//       Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1);
//       Navigator.pop(context);
//       handleStartStop();
//     } else {
//       Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1);
//     }
//   }

//   Future<void> selectStartDate(BuildContext context) async {
//     final DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2050),
//     );
//     if (date != null) {
//       setState(() {
//         selectedStartDate = DateFormat("dd-MM-yyyy").format(date);
//       });
//     }
//   }

//   Future<void> selectEndDate(BuildContext context) async {
//     final DateTime? endDate = await showDatePicker(
//       context: context,
//       initialDate: DateFormat("dd-MM-yyyy").parse(selectedStartDate),
//       firstDate: DateFormat("dd-MM-yyyy").parse(selectedStartDate),
//       lastDate: DateTime(2050),
//     );
//     if (endDate != null) {
//       setState(() {
//         selectedEndDate = DateFormat("dd-MM-yyyy").format(endDate);
//       });
//     }
//   }

//   late Stopwatch stopwatch;
//   late Timer timer;
//   List question = [];

//   Future<String?> getQuestion() async {
//     var response =
//         await http.post(Uri.parse("https://www.drivaar.com/api/inspection.php"),
//             body: ({
//               "action": "inspection",
//               "auth_key": global_auth_key,
//             }));
//     var convert_data_to_json = json.decode(response.body);
//     var message = convert_data_to_json['data']['error'];
//     if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
//       question = convert_data_to_json['data']['inspection_status'];
//       setState(() {
//         print(question);
//         print(question.length);
//       });
//     } else {
//       Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1);
//     }
//   }

//   Future<String?> dayRequest() async {
//     var response =
//         await http.post(Uri.parse("https://www.drivaar.com/api/request_dayoff.php"),
//             body: ({
//               "action": "request_dayoff",
//               "auth_key": global_auth_key,
//               'notes': request.text,
//               'start_date': selectedStartDate,
//               'end_date': selectedEndDate,
//             }));
//     var convert_data_to_json = json.decode(response.body);
//     if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
//       setState(() {
//         request.text = "";
//         selectedStartDate = "Start Date";
//         selectedEndDate = "End Date";
//       });

//       Fluttertoast.showToast(
//           msg: convert_data_to_json['data']['success'],
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1);
//     } else {
//       Fluttertoast.showToast(
//           msg: convert_data_to_json['data']['error'],
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     stopwatch = Stopwatch();
//     key();
//   }

//   void handleStartStop() {
//     if (stopwatch.isRunning) {
//       stopwatch.stop();
//     } else {
//       stopwatch.start();
//     }
//     timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
//       setState(() {}); // re-render the page
//     });
//   }

//   key() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       auth_key = (prefs.getString("auth_key") ?? "");
//       global_auth_key = auth_key;
//       getQuestion();
//     });
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text("Home"),
//         backgroundColor: app_color,
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 prefs.remove("email");
//                 prefs.remove("password");
//                 prefs.remove("name");
//                 prefs.remove("contact");
//                 prefs.remove("address");
//                 prefs.remove("postcode");
//                 prefs.remove("state");
//                 prefs.remove("city");
//                 prefs.remove("country");
//                 prefs.remove("depot");
//                 prefs.remove("type");
//                 prefs.remove("auth_key");

//                 Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const LoginRegister()));
//               },
//               icon: const Icon(Icons.lock_outlined))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: GestureDetector(
//             onTap: () {
//               FocusScope.of(context).requestFocus(FocusNode());
//             },
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Padding(
//                 padding: EdgeInsets.only(left: 20.0, top: 20.0),
//                 child: Text(
//                   "Dashboard",
//                   style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Container(
//                   height: 140.0,
//                   padding: const EdgeInsets.only(left: 15.0, top: 15.0),
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: <Widget>[
//                       Container(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => AccidentReport(
//                                             auth_key: auth_key,
//                                           )));
//                             },
//                             child: const Icon(
//                               Icons.directions_car,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Report"),
//                           ),
//                           const Text("Accident")
//                         ]),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => InspectionQuestion(
//                                             question: question,
//                                           )));
//                             },
//                             child: const Icon(
//                               Icons.list,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Start"),
//                           ),
//                           const Text("Inspection"),
//                         ]),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => Documents()));
//                               // Fluttertoast.showToast(
//                               // msg: "Documents",
//                               // toastLength: Toast.LENGTH_SHORT,
//                               // gravity: ToastGravity.BOTTOM,
//                               // timeInSecForIosWeb: 1);
//                             },
//                             child: const Icon(
//                               Icons.document_scanner_outlined,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Documents"),
//                           ),
//                         ]),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 12.0, right: 8.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => RequestList()));
//                               // Fluttertoast.showToast(
//                               //     msg: "Under Construction",
//                               //     toastLength: Toast.LENGTH_SHORT,
//                               //     gravity: ToastGravity.BOTTOM,
//                               //     timeInSecForIosWeb: 1);
//                             },
//                             child: const Icon(
//                               Icons.list_alt_outlined,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Request"),
//                           ),
//                           const Text("List"),
//                         ]),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => OffencesList(
//                                             auth_key: auth_key,
//                                           )));
//                             },
//                             child: const Icon(
//                               Icons.list_alt_outlined,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Offences"),
//                           ),
//                         ]),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Invoice(
//                                             auth_key: auth_key,
//                                           )));
//                             },
//                             child: Image.asset(
//                               "images/Invoice.png",
//                               height: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Invoice"),
//                           ),
//                         ]),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => Profile()));
//                             },
//                             child: const Icon(
//                               Icons.person,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Profile"),
//                           ),
//                         ]),
//                       ),
//                       // Container(
//                       //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                       //   child: Column(children: [
//                       //     ElevatedButton(
//                       //       onPressed: () {
//                       //         // Navigator.push(
//                       //         //     context,
//                       //         //     MaterialPageRoute(
//                       //         //         builder: (context) => Issues()));
//                       //         Fluttertoast.showToast(
//                       //             msg: "Under Construction",
//                       //             toastLength: Toast.LENGTH_SHORT,
//                       //             gravity: ToastGravity.BOTTOM,
//                       //             timeInSecForIosWeb: 1);
//                       //       },
//                       //       child: const Icon(
//                       //         Icons.comment,
//                       //         color: Colors.white,
//                       //         size: 25,
//                       //       ),
//                       //       style: ElevatedButton.styleFrom(
//                       //           shape: const CircleBorder(),
//                       //           padding: const EdgeInsets.all(20),
//                       //           primary: app_color),
//                       //     ),
//                       //     const Padding(
//                       //       padding: EdgeInsets.only(top: 5),
//                       //       child: Text("Issue"),
//                       //     ),
//                       //   ]),
//                       // ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 8.0, right: 15.0),
//                         child: Column(children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => FeedBack()));
//                             },
//                             child: const Icon(
//                               Icons.feedback,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(20),
//                                 primary: app_color),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: Text("Feedback"),
//                           ),
//                         ]),
//                       ),
//                     ],
//                   )),
//               Column(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(
//                       top: 0.0,
//                       left: 20.0,
//                     ),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Start My Day',
//                         style: TextStyle(
//                             fontSize: 24.0, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   // ButtonBar(alignment: MainAxisAlignment.center, children: [
//                   //   OutlinedButton(
//                   //     onPressed: () {
//                   //       // selectEndDate(context);
//                   //       setState(() {
//                   //         status = false;
//                   //       });
//                   //     },
//                   //     child: Text("Start Inspection"),
//                   //     style: OutlinedButton.styleFrom(
//                   //       padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
//                   //       side: BorderSide(width: 2, color: app_color),
//                   //     ),
//                   //   )
//                   // ]),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 20.0, top: 0.0, bottom: 0),
//                     child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               child: const Padding(
//                                 padding:
//                                     EdgeInsets.only(top: 0.0, bottom: 10.0),
//                                 child: Text(
//                                   'Attendance',
//                                   style: TextStyle(
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 10.0, bottom: 10.0, left: 20),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   if (stopwatch.isRunning) {
//                                     showAlertDialog(context, "Clock Out");
//                                   } else {
//                                     showAlertDialog(context, "Clock In");
//                                   }
//                                 },
//                                 child: Icon(
//                                   stopwatch.isRunning
//                                       ? Icons.timer_off
//                                       : Icons.timer,
//                                   color: Colors.white,
//                                   size: 25,
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                     shape: const CircleBorder(),
//                                     padding: const EdgeInsets.all(20),
//                                     primary: app_color),
//                               ),
//                             ),
//                           ),
//                         ]),
//                   ),
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Card(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
//                             child: Text(
//                                 formatTime(stopwatch.elapsedMilliseconds),
//                                 style: const TextStyle(fontSize: 48.0)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin:
//                         const EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
//                     child: Card(
//                       child: Column(children: [
//                         const Padding(
//                           padding: EdgeInsets.only(
//                               top: 10.0, bottom: 0, left: 10, right: 10),
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Text(
//                               "Request Day off",
//                               style: TextStyle(
//                                   fontSize: 20.0, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10.0, bottom: 0),
//                           child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 Expanded(
//                                   flex: 1,
//                                   // child: TextFormField(
//                                   //   decoration: const InputDecoration(
//                                   //     hintText: "Start Date",
//                                   //     prefixIcon: Icon(Icons.calendar_today),
//                                   //     border: const OutlineInputBorder(),
//                                   //     enabledBorder: OutlineInputBorder(
//                                   //         borderRadius:
//                                   //             BorderRadius.all(Radius.circular(4)),
//                                   //         borderSide: BorderSide(
//                                   //             width: 2, color: app_color)),
//                                   //   ),
//                                   //   onTap: () {
//                                   //     selectStartDate(context);
//                                   //   },
//                                   // ),

//                                   child: ButtonBar(
//                                       alignment: MainAxisAlignment.start,
//                                       children: [
//                                         OutlinedButton.icon(
//                                           onPressed: () {
//                                             selectStartDate(context);
//                                           },
//                                           label: Text(
//                                             selectedStartDate,
//                                             style: TextStyle(color: app_color),
//                                           ),
//                                           icon: Icon(
//                                             Icons.calendar_today,
//                                             color: app_color,
//                                           ),
//                                           style: OutlinedButton.styleFrom(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 15, vertical: 8),
//                                             side: BorderSide(
//                                                 width: 2, color: app_color),
//                                           ),
//                                         )
//                                       ]),
//                                 ),
//                                 // ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: ButtonBar(
//                                       alignment: MainAxisAlignment.end,
//                                       children: [
//                                         OutlinedButton.icon(
//                                           onPressed: () {
//                                             selectEndDate(context);
//                                           },
//                                           label: Text(
//                                             selectedEndDate,
//                                             style: TextStyle(color: app_color),
//                                           ),
//                                           icon: Icon(
//                                             Icons.calendar_today,
//                                             color: app_color,
//                                           ),
//                                           style: OutlinedButton.styleFrom(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 15, vertical: 8),
//                                             side: BorderSide(
//                                                 width: 2, color: app_color),
//                                           ),
//                                         )
//                                       ]),
//                                 ),
//                                 // ),
//                               ]),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 10.0, bottom: 10, left: 10, right: 10),
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Form(
//                               key: formKey,
//                               child: TextFormField(
//                                 controller: request,
//                                 cursorColor: app_color,
//                                 keyboardType: TextInputType.text,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please Enter Note';
//                                   }
//                                   return null;
//                                 },
//                                 maxLines: 3,
//                                 // maxLength: 200,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                 ),
//                                 decoration: InputDecoration(
//                                   labelText: "Enter Notes",
//                                   labelStyle: TextStyle(
//                                     fontSize: 18,
//                                     color: app_color,
//                                   ),
//                                   border: const OutlineInputBorder(),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(4)),
//                                     borderSide:
//                                         BorderSide(width: 2, color: app_color),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(4)),
//                                     borderSide:
//                                         BorderSide(width: 2, color: app_color),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 10.0, bottom: 10, left: 10, right: 10),
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // if (formKey.currentState!.validate()) {
//                                 //   if (selectedStartDate != "Start Date" &&
//                                 //       selectedEndDate != "End Date") {
//                                 //     print(global_auth_key);
//                                 //     print(request.text);
//                                 //     print(selectedStartDate);
//                                 //     print(selectedEndDate);
//                                 //     dayRequest();
//                                 //   } else {
//                                 //     Fluttertoast.showToast(
//                                 //         msg: "Select Start or End Date",
//                                 //         toastLength: Toast.LENGTH_SHORT,
//                                 //         gravity: ToastGravity.BOTTOM,
//                                 //         timeInSecForIosWeb: 1);
//                                 //   }
//                                 // }
//                               },
//                               child: const Text(
//                                 "Send Request",
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: const Size(100, 40),
//                                 primary: app_color,
//                               ),

//                               // Navigator.pop(context, "update");
//                               // Navigator.pushReplacement(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => super.widget));
//                             ),
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ),
//                 ],
//               )
//             ])),
//       ),
//     );
//   }

//   void showAlertDialog(BuildContext context, String Status) {
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: Text(
//         "Cancel",
//         style: TextStyle(color: app_color),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//     Widget inButton = TextButton(
//       child: Text(Status, style: TextStyle(color: app_color)),
//       onPressed: () {
//         if (Status == "Clock In") {
//           // handleStartStop();
//           clockIn();
//         } else {
//           // handleStartStop();
//           clockOut();
//         }
//         Navigator.pop(context);
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("$Status"),
//       content: Text("Are you sure you want to $Status"),
//       actions: [
//         cancelButton,
//         inButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
