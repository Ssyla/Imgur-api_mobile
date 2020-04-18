import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadPage extends StatefulWidget {
  final String _token;

  const UploadPage(this._token);

  @override
  State<StatefulWidget> createState() {
    return StateUploadPage();
  }
}

class StateUploadPage extends State<UploadPage> {
  File image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Image upload"), centerTitle: true),
        body: Container(
            alignment: Alignment.center,
            color: Colors.grey[300],
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                      child: Text("Choose an image to upload"),
                      onPressed: () async {
                        image = await FilePicker.getFile();
                        setState(() {});
                      }),
                  image == null
                      ? SizedBox.shrink()
                      : Container(
                          constraints:
                              BoxConstraints(maxHeight: 300, maxWidth: 300),
                          child: Image.file(image)),
                        image == null ? SizedBox.shrink() :
                          RaisedButton(color: Colors.blue,
                          child: Text("Upload"),
                          onPressed: () {
                            send(image, context);
                          })
                ])));
  }

  send(File image, BuildContext context) async {
    String url = "https://api.imgur.com/3/upload";
    var client = new http.Client();
    var b = base64Encode(image.readAsBytesSync());
      var body = {'image': b, 'type': 'file'};
    client.post(url, headers: {'Authorization': 'Bearer ' + widget._token},
    body: body).then((res) {
      Map<String, dynamic> data = jsonDecode(res.body);
      print(res.body);
    });
    Navigator.pop(context);
  }
}
