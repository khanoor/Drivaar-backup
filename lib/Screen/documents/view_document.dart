import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewDocument extends StatefulWidget {
  String imageUrl = '';
  String name = '';
  ViewDocument({Key? key, required this.name, required this.imageUrl})
      : super(key: key);

  @override
  State<ViewDocument> createState() => ViewDocumentState();
}

class ViewDocumentState extends State<ViewDocument> {
  @override
  Widget build(BuildContext context) {
    // print(widget.imageUrl);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0xff274C77),
        title: Text(widget.name),
      ),
      body: Center(
          child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.white),
        imageProvider: NetworkImage(widget.imageUrl),
      ) //Image.network(widget.imageUrl),
          ),
    );
  }
}
