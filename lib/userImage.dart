import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

listPic(String token, Function cb) async {
  const url = 'https://api.imgur.com/3/account/me/images';
  var client = new http.Client();
  var pics = new List();

  await client
      .get(url, headers: {'Authorization': 'Bearer ' + token}).then((res) {
    print(res.body);
    Map<String, dynamic> data = jsonDecode(res.body);
    for (var p in data["data"]) {
      pics.add(p["link"]);
      print(p["link"]);
    }
    cb(pics);
  });
}

Widget userImage(List pics) {
  return Container(
      color: Colors.blue,
      child: ListView.builder(
          itemCount: pics.length,
          itemBuilder: (BuildContext context, int index) {
            return new Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Image.network(pics[index]));
          }));
}
