import 'dart:convert';
import 'dart:io';

import 'package:drivaar/Screen/inspection/answer_view.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:im_stepper/stepper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionQuestion extends StatefulWidget {
  List question = [];
  InspectionQuestion({Key? key, required this.question}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<InspectionQuestion> createState() =>
      InspectionQuestionState(question: question);
}

// int selectedRadio;
int radioSelected = -1;

class InspectionQuestionState extends State<InspectionQuestion> {
  List question = [];
  InspectionQuestionState({required this.question});
  // int radioSelected = 0;
  String radioVal = "0";
  int q_no = 0;
  // int select_1 = 0;
  // int select_2 = 101;

  bool isVisible = false;

  var path;
  var imageFile;
  var image_name;
  String OdometerInserdate = '';

  List answer_list = [];

  int activeStap = 0;

  TextEditingController odometer = TextEditingController();
  TextEditingController remarkControl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Future<String?> Submit() async {
  //   var response =
  //       await http.post(Uri.parse("https://www.drivaar.com/api/inspection_data.php"),
  //           body: ({
  //             "action": "inspection_data",
  //             "auth_key": global_auth_key,
  //           }));
  //   var convert_data_to_json = json.decode(response.body);
  //   var message = convert_data_to_json['data']['message'];
  //   if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
  //     Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1);
  //     Navigator.pop(this.context);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1);
  //   }
  // }

  Future<String?> Submit_Odometer(odometer, no) async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/inspectionanswers.php"),
        body: ({
          "action": "submit",
          "auth_key": global_auth_key,
          'odometer': odometer,
          'question_id': no.toString(),
          'answer_type': '1',
        }));
    var convert_data_to_json = json.decode(response.body);
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        answer_list.insert(q_no, odometer);
        q_no++;
        activeStap++;
        isVisible = false;

        // add(odometer);
        OdometerInserdate = convert_data_to_json['data']['odometer_date'];
        // print(OdometerInserdate);
        // print(q_no);
        // print(answer_list);
      });

      // Fluttertoast.showToast(
      //     msg: convert_data_to_json['message'],
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1);
      // q_no++;
      // isVisible = false;
    } else {
      Fluttertoast.showToast(
          msg: convert_data_to_json['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red);
    }
  }

  Future<String?> Submit_Yes(no) async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/inspectionanswers.php"),
        body: ({
          "action": "submit",
          "auth_key": global_auth_key,
          'question_id': no.toString(),
          'answer_type': '1',
          'odometer_inserdate': OdometerInserdate,
          // 'remark': ,
          // 'odometer_inserdate': ,
        }));
    var convert_data_to_json = json.decode(response.body);
    if (response.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        answer_list.insert(q_no, "Yes");
        q_no++;
        activeStap++;
        isVisible = false;
        radioSelected = -1;
        // answer_list.add("Yes");
        // print(q_no);
        // print(answer_list);
      });

      // Fluttertoast.showToast(
      //     msg: convert_data_to_json['data']['message'],
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1);
      // Navigator.pop(this.context);
      // q_no++;
      // isVisible = false;
      // radioSelected = -1;
    } else {
      Fluttertoast.showToast(
          msg: convert_data_to_json['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red);
    }
  }

  Submit_No(File imageFile, no, remark) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://www.drivaar.com/api/inspectionanswers.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields["action"] = "submit";
    request.fields['auth_key'] = global_auth_key;
    request.fields['question_id'] = no.toString();
    request.fields['answer_type'] = "0";
    request.fields['odometer_inserdate'] = OdometerInserdate;
    request.fields['remark'] = remark;

    var multipartFile = new http.MultipartFile('sendimage', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    // print(response.statusCode);
    var body = await http.Response.fromStream(response);
    var convert_data_to_json = json.decode(body.body);
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });

    if (body.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        answer_list.insert(q_no, "No");
        q_no++;
        activeStap++;
        isVisible = false;
        radioSelected = -1;
        remarkControl.text = '';
        // answer_list.add("No");
        // print(q_no);
        // print(answer_list);
        // Fluttertoast.showToast(
        //     msg: convert_data_to_json['data']['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1);
        // q_no++;
        // isVisible = false;
        // radioSelected = -1;
      });
    } else {
      Fluttertoast.showToast(
          msg: convert_data_to_json['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red);
    }
  }

  getImage() async {
    var pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.camera,
    ));
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        path = pickedFile.path;
        image_name = pickedFile.path.split('/').last;
        // print("$path");
        cropImage(path);
      });
    }
  }

  /// Crop Image
  Future<Null> cropImage(imagePath) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        maxHeight: 512,
        maxWidth: 512,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: app_color,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  add(id, answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Question $id", answer);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inspection Question"),
        backgroundColor: Color(0xff274C77),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: NumberStepper(
                        numbers: List.generate(
                            question.length, (index) => index + 1),
                        activeStep: activeStap,
                        // onStepReached: (index) {

                        // },
                        enableStepTapping: false,
                        stepRadius: 16,
                        lineLength: 20,
                        enableNextPreviousButtons: false,
                        activeStepBorderWidth: 0,
                        activeStepBorderPadding: 0,
                        numberStyle: const TextStyle(color: Colors.white),
                        activeStepColor: app_color,
                        activeStepBorderColor: app_color),
                  ),
                  Text(
                    question[q_no]['question'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  // ),
                  question[q_no]['type'] == "text"
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 10.0, bottom: 20),
                          child: Form(
                            key: formKey,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: odometer,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Details';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter Odometer",
                                      isDense: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          15, 25, 25, 0),
                                      hintStyle: TextStyle(color: app_color),
                                      border: const OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 2, color: app_color)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 1, // select_1,
                                    groupValue: radioSelected,
                                    activeColor: app_color,
                                    onChanged: (value) {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        radioSelected = 1; //value as int;
                                        radioVal = "Yes";
                                        isVisible = false;
                                      });
                                    },
                                  ),
                                  const Text('Yes'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 0, // select_2,
                                    groupValue: radioSelected,
                                    activeColor: app_color,
                                    onChanged: (value) {
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        radioSelected = 0; //value as int;
                                        radioVal = "No";
                                        isVisible = !isVisible;
                                        getImage();
                                      });
                                    },
                                  ),
                                  const Text('No'),
                                ],
                              ),
                              imageFile != null
                                  ? Visibility(
                                      visible: isVisible,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 0, right: 0, top: 15.0),
                                            child: Text(
                                              'Remark',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 8.0,
                                            ),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              controller: remarkControl,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                hintText: "Enter Remark",
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 25, 25, 0),
                                                hintStyle:
                                                    TextStyle(color: app_color),
                                                border:
                                                    const OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    4)),
                                                        borderSide: BorderSide(
                                                            color: app_color)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    4)),
                                                        borderSide: BorderSide(
                                                            color: app_color)),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 15, bottom: 5),
                                            child: Text(
                                              'Capture Photo',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: app_color,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: FittedBox(
                                                child: Row(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          getImage();
                                                        },
                                                        child: Text(imageFile !=
                                                                null
                                                            ? "Change Photo"
                                                            : "Capture Photo")),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 10),
                                                      child: Text(imageFile !=
                                                              null
                                                          ? image_name
                                                          : "No Photo Added"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: imageFile != null
                                                  ? Container(
                                                      width: double.infinity,
                                                      height: 300.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: app_color),
                                                          // shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: FileImage(
                                                                  imageFile))))
                                                  : Container()),
                                        ],
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),

                  q_no < question.length - 1 && q_no == 0
                      ? Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  // q_no++;
                                  // select_1++;
                                  // select_2++;
                                  // isVisible = false;
                                  // answer_list.add(odometer.text);
                                  Submit_Odometer(odometer.text, q_no);
                                  // q_no++;
                                  // radioSelected = -1;
                                });
                              }
                            },
                            child: const Text(
                              "CONTINUE",
                              textScaleFactor: 1,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff274C77),
                            ),
                          ),
                        )
                      : q_no < question.length - 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      q_no--;
                                      activeStap--;

                                      // print("$q_no, $radioVal");
                                      // print(answer_list[q_no]);
                                      answer_list[q_no] == "Yes"
                                          ? setState(
                                              () {
                                                radioSelected = 1;
                                                isVisible = false;
                                              },
                                            )
                                          : setState(
                                              () {
                                                radioSelected = 0;
                                                isVisible = true;
                                              },
                                            );
                                    });
                                  },
                                  child: const Text("BACK"),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (radioSelected == -1) {
                                      Fluttertoast.showToast(
                                          msg: "Please Select Any 1 Oprion");
                                    } else if (radioSelected == 1) {
                                      setState(() {
                                        // q_no++;
                                        // select_1++;
                                        // select_2++;
                                        // print("$q_no, $radioVal");
                                        // isVisible = false;
                                        // answer_list.add(radioVal);
                                        Submit_Yes(q_no);
                                        // q_no++;
                                        // radioSelected = -1;
                                      });
                                    } else if (radioSelected == 0 &&
                                        remarkControl.text != "") {
                                      Submit_No(
                                          imageFile, q_no, remarkControl.text);
                                      // q_no++;
                                      // radioSelected = -1;
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Remark");
                                    }
                                  },
                                  child: const Text("CONTINUE"),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      q_no--;
                                      // select_1--;
                                      // select_2--;
                                      // print("$q_no, $radioVal");
                                      // print(answer_list[q_no]);
                                      answer_list[q_no] == "Yes"
                                          ? setState(
                                              () {
                                                radioSelected = 1;
                                                isVisible = false;
                                              },
                                            )
                                          : setState(
                                              () {
                                                radioSelected = 0;
                                                isVisible = true;
                                              },
                                            );
                                    });
                                  },
                                  child: const Text("BACK"),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     Submit();
                                //   },
                                //   child: const Text("SUBMIT"),
                                // ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Submit();
                                    answer_list.add(radioVal);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AnswerView(
                                                  question: question,
                                                  answer: answer_list,
                                                )));
                                    // Navigator.pop(context);
                                  },
                                  child: const Text("View"),
                                ),
                              ],
                            )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
