// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:drivaar/Screen/authentication/reset_password.dart';
import 'package:drivaar/Screen/home_page.dart';
import 'package:drivaar/Screen/inspection/inspection_question.dart';
import 'package:drivaar/Screen/invoice/invoice_tab.dart';
import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return ProfileState();
  }
}

class ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  var path;
  var imageFile;

  getImage() async {
    var pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
    ));
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        path = pickedFile.path;
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

  bool status = true;
  final FocusNode myFocusNode = FocusNode();

  String name = '';
  String address = '';
  String email = '';
  String pin = '';
  String mobile = '';
  String state = '';
  String city = '';
  String depot = '';
  String type = '';
  String country = '';
  var profile_data;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = (prefs.getString("name") ?? "");
      email = (prefs.getString("email") ?? "");
      //     address = (prefs.getString("address") ?? "");
      //     city = (prefs.getString("city") ?? "");
      //     pin = (prefs.getString("postcode") ?? "");
      //     state = (prefs.getString("state") ?? "");
      //     mobile = (prefs.getString("contact") ?? "");
      //     country = (prefs.getString("country") ?? "");
      //     type = (prefs.getString("type") ?? "");
      //     depot = (prefs.getString("depot") ?? "");
    });
  }

  Future<String?> getProfile() async {
    var response = await http.post(
        Uri.parse("https://www.drivaar.com/api/list_profile.php"),
        body: ({
          "action": "list_profile",
          "auth_key": global_auth_key,
        }));
    var convert_data_to_json = json.decode(response.body);
    var message = convert_data_to_json['data']['success'];
    // print(message);
    if (response.statusCode == 200) {
      setState(() {
        global_profile_data = convert_data_to_json['data']['data'];
        global_profile_image = global_profile_data[0]['profile'];
        // print(global_profile_data);
      });
    }
  }

  Update_Profile(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://www.drivaar.com/api/profile_edit.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields["action"] = "profile_edit";
    request.fields['auth_key'] = global_auth_key;
    var multipartFile = new http.MultipartFile('sendimage', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    // print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      // print(value);
      getProfile();
    });
  }

  @override
  void initState() {
    // getProfile();
    getData();
    setState(() {
      profile_data = global_profile_data[0];
    });
    // print(profile_data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerName = TextEditingController(text: name);
    TextEditingController controllerEmail = TextEditingController(text: email);
    TextEditingController controllerAddress =
        TextEditingController(text: profile_data['address']);
    TextEditingController controllerAddress2 =
        TextEditingController(text: profile_data['address_2']);
    TextEditingController controllerCity =
        TextEditingController(text: profile_data['town/city']);
    TextEditingController controllerPin =
        TextEditingController(text: profile_data['postcode']);
    // TextEditingController controllerState = TextEditingController(text: profile_data['contact']);
    TextEditingController controllerMobile =
        TextEditingController(text: profile_data['contact']);
    TextEditingController controllerCountry =
        TextEditingController(text: profile_data['county/district']);
    // TextEditingController controllerDepot = TextEditingController(text: depot);
    // TextEditingController controllerType = TextEditingController(text: type);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: app_color,
          title: const Text("Profile"),
        ),
        bottomNavigationBar: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Color(0xff274C77),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                  auth_key: global_auth_key,
                                  name: global_name)));
                    },
                    icon: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "HOME",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InspectionQuestion(
                                  question: global_question)));
                    },
                    icon: const Icon(
                      Icons.assessment_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "INSPECTION",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvoiceTab()));
                    },
                    icon: const Icon(
                      Icons.insert_drive_file_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "INVOICE",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Profile()));
                },
                child: global_profile_image == ""
                    ? Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: app_color),
                        ),
                        child: Image.asset("images/profile.png"),
                      )
                    :
                    // Container(
                    //     width: 50.0,
                    //     height: 50.0,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(50),
                    //       // border: Border.all(color: Colors.white),
                    //       boxShadow:[
                    //         BoxShadow(
                    //           color: Colors.white,
                    //           blurRadius: 10
                    //         )

                    //       ]
                    //     ),
                    //     child:
                    CircleAvatar(
                        radius: 22.0,
                        backgroundImage: NetworkImage(global_profile_image),
                      ),
              ),
              // ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text('PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: app_color)),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ResetPassword()));
                                    },
                                    child: Text('Reset Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            color: app_color)),
                                  ),
                                )
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                imageFile != null
                                    ? Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border:
                                                Border.all(color: app_color),
                                            // shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: FileImage(imageFile))))
                                    : CircleAvatar(
                                        radius: 45.0,
                                        backgroundImage: NetworkImage(
                                            "${profile_data['profile']}"),
                                        // AssetImage("images/profile.png"),
                                      ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 60.0, right: 70.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      getImage();
                                    },
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(10),
                                        primary: app_color),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xffFFFFFF),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Personal Information',
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            color: app_color),
                                      ),
                                    ],
                                  ),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   children: <Widget>[
                                  //     status ? getEditIcon() : Container(),
                                  //   ],
                                  // )
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: controllerName,
                                      decoration: InputDecoration(
                                        hintText: "Enter Your Name",
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 25, 25, 0),
                                        hintStyle: TextStyle(color: app_color),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2, color: app_color)),
                                      ),
                                      enabled: !status,
                                      autofocus: !status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: controllerEmail,
                                      decoration: InputDecoration(
                                        hintText: "Enter Email ID",
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 25, 25, 0),
                                        hintStyle: TextStyle(color: app_color),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2, color: app_color)),
                                      ),
                                      enabled: !status,
                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Address 1',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: controllerAddress,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Enter Address",
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 25, 25, 0),
                                        hintStyle: TextStyle(color: app_color),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2, color: app_color)),
                                      ),
                                      enabled: !status,
                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Address 2',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: controllerAddress2,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Enter Address",
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 25, 25, 0),
                                        hintStyle: TextStyle(color: app_color),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2, color: app_color)),
                                      ),
                                      enabled: !status,
                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 10,
                                      controller: controllerMobile,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Enter Mobile",
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 25, 25, 0),
                                        hintStyle: TextStyle(color: app_color),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2, color: app_color)),
                                      ),
                                      enabled: !status,
                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: const Text(
                                        'City',
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
                                          'Pin Code',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: controllerCity,
                                      decoration: InputDecoration(
                                        hintText: "Enter City",
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 25, 25, 0),
                                        hintStyle: TextStyle(color: app_color),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2, color: app_color)),
                                      ),
                                      enabled: !status,
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: controllerPin,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        decoration: InputDecoration(
                                          hintText: "Enter Pin Code",
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  15, 25, 25, 0),
                                          hintStyle:
                                              TextStyle(color: app_color),
                                          border: const OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 2, color: app_color)),
                                        ),
                                        enabled: !status,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: const Text(
                                        'State',
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
                                          'Country',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    // controller: controllerState,
                                    decoration: InputDecoration(
                                      hintText: "Enter State",
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
                                    enabled: !status,
                                  ),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextFormField(
                                      // initialValue: mob,
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.digitsOnly
                                      // ],
                                      keyboardType: TextInputType.text,
                                      // maxLength: 10,
                                      controller: controllerCountry,
                                      decoration: InputDecoration(
                                        hintText: "Country",
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 25, 25, 0),
                                        hintStyle: TextStyle(color: app_color),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2, color: app_color)),
                                      ),
                                      enabled: !status,
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            ),
                          ),
                          imageFile != null
                              ? Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Update_Profile(imageFile);
                                      },
                                      child: Text("Update"),
                                      style: ElevatedButton.styleFrom(primary: Color(0xff274C77),)
                                    ),
                                  ),
                                )
                              : Container()

                          // Padding(
                          //     padding: const EdgeInsets.only(
                          //         left: 25.0, right: 25.0, top: 15.0),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.max,
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: <Widget>[
                          //         Expanded(
                          //           child: Container(
                          //             child: const Text(
                          //               'Depot',
                          //               style: TextStyle(
                          //                   fontSize: 16.0,
                          //                   fontWeight: FontWeight.bold),
                          //             ),
                          //           ),
                          //           flex: 2,
                          //         ),
                          //         Expanded(
                          //           child: Container(
                          //             child: const Padding(
                          //               padding: EdgeInsets.only(left: 10.0),
                          //               child: Text(
                          //                 'Type',
                          //                 style: TextStyle(
                          //                     fontSize: 16.0,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ),
                          //           ),
                          //           flex: 2,
                          //         ),
                          //       ],
                          //     )),
                          // Padding(
                          //     padding: const EdgeInsets.only(
                          //         left: 25.0, right: 25.0, top: 2.0),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.max,
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: <Widget>[
                          //         Flexible(
                          //           child: TextFormField(
                          //             controller: controllerDepot,
                          //             decoration: InputDecoration(
                          //               hintText: "Depot",
                          //               isDense: true,
                          //               contentPadding:
                          //                   const EdgeInsets.fromLTRB(
                          //                       15, 25, 25, 0),
                          //               hintStyle: TextStyle(color: app_color),
                          //               border: const OutlineInputBorder(),
                          //               enabledBorder: OutlineInputBorder(
                          //                   borderRadius:
                          //                       const BorderRadius.all(
                          //                           Radius.circular(4)),
                          //                   borderSide: BorderSide(
                          //                       width: 2, color: app_color)),
                          //             ),
                          //             // enabled: !status,
                          //             enabled: false,
                          //           ),
                          //           flex: 2,
                          //         ),
                          //         Flexible(
                          //           child: Padding(
                          //             padding:
                          //                 const EdgeInsets.only(left: 10.0),
                          //             child: TextFormField(
                          //               inputFormatters: <TextInputFormatter>[
                          //                 FilteringTextInputFormatter.digitsOnly
                          //               ],
                          //               controller: controllerType,
                          //               keyboardType: TextInputType.number,
                          //               maxLength: 6,
                          //               decoration: InputDecoration(
                          //                 hintText: "Type",
                          //                 isDense: true,
                          //                 contentPadding:
                          //                     const EdgeInsets.fromLTRB(
                          //                         15, 25, 25, 0),
                          //                 hintStyle:
                          //                     TextStyle(color: app_color),
                          //                 border: const OutlineInputBorder(),
                          //                 enabledBorder: OutlineInputBorder(
                          //                     borderRadius:
                          //                         const BorderRadius.all(
                          //                             Radius.circular(4)),
                          //                     borderSide: BorderSide(
                          //                         width: 2, color: app_color)),
                          //               ),
                          //               // enabled: !status,
                          //               enabled: false,
                          //             ),
                          //           ),
                          //           flex: 2,
                          //         ),
                          //       ],
                          //     )),

                          // !status ? getActionButtons() : Container(),
                          // Padding(
                          //     padding: EdgeInsets.only(
                          //         left: 25.0, right: 25.0, top: 25.0),
                          //     child: new Row(
                          //       mainAxisSize: MainAxisSize.max,
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: <Widget>[
                          //         Expanded(
                          //           child: Container(
                          //             child: Padding(
                          //               padding: EdgeInsets.only(right: 10.0),
                          //               child: ElevatedButton(
                          //                 onPressed: () {},
                          //                 child: Text(
                          //                   "Update",
                          //                 ),
                          //                 style: ButtonStyle(
                          //                     shape: MaterialStateProperty.all<
                          //                             RoundedRectangleBorder>(
                          //                         RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.circular(20),
                          //                 ))),
                          //               ),
                          //             ),
                          //           ),
                          //           flex: 1,
                          //         ),
                          //         Expanded(
                          //           child: Container(
                          //             child: ElevatedButton(
                          //               onPressed: () {},
                          //               child: Text(
                          //                 "Save",
                          //               ),
                          //               style: ButtonStyle(
                          //                   shape: MaterialStateProperty.all<
                          //                           RoundedRectangleBorder>(
                          //                       RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(20),
                          //               ))),
                          //             ),
                          //           ),
                          //           flex: 1,
                          //         ),
                          //       ],
                          //     )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  // Widget getActionButtons() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 10.0),
  //             child: Container(
  //                 child: RaisedButton(
  //               child: const Text("Save"),
  //               textColor: Colors.white,
  //               color: app_color,
  //               onPressed: () {
  //                 setState(() {
  //                   status = true;
  //                   FocusScope.of(context).requestFocus(FocusNode());
  //                 });
  //               },
  //               // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20.0)),
  //             )),
  //           ),
  //           flex: 2,
  //         ),
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 10.0),
  //             child: Container(
  //                 child: RaisedButton(
  //               child: const Text("Cancel"),
  //               textColor: Colors.white,
  //               color: Colors.red,
  //               onPressed: () {
  //                 setState(() {
  //                   status = true;
  //                   FocusScope.of(context).requestFocus(FocusNode());
  //                 });
  //               },
  //               // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20.0)),
  //             )),
  //           ),
  //           flex: 2,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: app_color,
        radius: 20.0,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          status = false;
        });
      },
    );
  }
}
