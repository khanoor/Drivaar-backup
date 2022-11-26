import 'dart:convert';
import 'dart:io';

import 'package:drivaar/global/global.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UploadFile extends StatefulWidget {
  String report_id;
  String type;
  UploadFile({required this.report_id, required this.type, Key? key})
      : super(key: key);

  @override
  State<UploadFile> createState() => UploadFileState();
}

class UploadFileState extends State<UploadFile> {
  final ImagePicker imagePicker = ImagePicker();
  List imageFileList = [];
  var position;

  bool visible = false;
  bool upload = false;

  void selectImages() async {
    var selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    // print("Image List Length:" + imageFileList.length.toString());
    setState(() {});
  }

  uploadImage(List image, context) async {
    // var stream =
    //     new http.ByteStream(DelegatingStream.typed(imageFileList.openRead()));
    // var length = await imageFileList.length();
    var uri = Uri.parse("https://www.drivaar.com/api/incident_imgupload.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields["action"] = "incident_imgupload";
    request.fields['auth'] = global_auth_key;
    request.fields['typeid'] = widget.type;
    request.fields['report_id'] = widget.report_id;
    // var multipartFile = new http.MultipartFile('sendimage', stream, length,
    //     filename: basename(imageFileList.path));

    List<MultipartFile> newList = <MultipartFile>[];
    for (int i = 0; i < image.length; i++) {
      File imageFile = File(image[i].path.toString());
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile("sendimage", stream, length,
          filename: basename(imageFile.path));
      newList.add(multipartFile);
    }

    request.files.addAll(newList);
    var response = await request.send();
    // print(response.statusCode);
    var body = await http.Response.fromStream(response);
    var convert_data_to_json = json.decode(body.body);
    // print(convert_data_to_json);

    if (body.statusCode == 200 && convert_data_to_json['status'] == 1) {
      setState(() {
        // Fluttertoast.showToast(
        //     msg: convert_data_to_json['data']['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1);
        // upload = false;
        // Navigator.pop(context, "A");
        InsertImage(context, convert_data_to_json['filename']);
      });
    } else {
      Fluttertoast.showToast(
          msg: convert_data_to_json['data']['title'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red);
      setState(() {
        upload = false;
      });
    }
  }

  Future<void> InsertImage(context,file) async {
    var response = await http.post(
        Uri.parse("https://drivaar.com/api/incident_imginsert.php"),
        body: ({
          'action': 'incident_imginsert',
          'auth_key': global_auth_key,
          'typeid': widget.type,
          'report_id': widget.report_id,
          'attachments': file,
        }));
    var d = json.decode(response.body);
    var message = d['data']['message'];
    if (response.statusCode == 200 && d['status'] == 1) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      Navigator.pop(context, "A");
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
    // print(widget.report_id);
    // print(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Image"),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () {
                if (imageFileList.length == 0) {
                  Fluttertoast.showToast(msg: "Select Image");
                } else {
                  setState(() {
                    // print("click");
                    upload = true;
                    uploadImage(imageFileList, context);
                  });
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(color: app_color),
              ),
            ),
          ),
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              itemCount: imageFileList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      // print("click");
                    },
                    onLongPress: () {
                      // print("click long");
                      setState(() {
                        visible = true;
                        position = index;
                      });
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(imageFileList[index].path),
                          fit: BoxFit.cover,
                        ),
                        position == index
                            ? Center(
                                child: Visibility(
                                  visible: visible,
                                  child: IconButton(
                                    onPressed: () {
                                      // print("delete");
                                      setState(() {
                                        visible = !visible;
                                        imageFileList.removeAt(index);
                                        // print(imageFileList.length);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ));
              }),
        ),
        Center(
          child: InkWell(
            onTap: () {
              selectImages();
            },
            child: Text(
              "Click to Upload Image",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        upload == true
            ? Center(
                child: Visibility(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(),
      ]),
    );
  }
}
