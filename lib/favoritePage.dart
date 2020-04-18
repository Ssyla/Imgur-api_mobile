import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homePage.dart';

getFav(String token, Function cb) async {
  String url =
      "https://api.imgur.com/3/account/me/favorites/{{page}}/{{favoritesSort}}";
  var client = http.Client();
  var favList = new List();

  await client
      .get(url, headers: {'Authorization': 'bearer ' + token}).then((res) {
    var data = jsonDecode(res.body);
    for (var d in data["data"]) {
      favList.add('https://i.imgur.com/' +
          d["id"] +
          '.' +
          d["type"].toString().substring(6));
    }
    cb(favList);
  });
}

removeFav(String link, String token, Function cb) async {
  String hash = link.substring(20).split(".")[0];
  // print(hash);
  String url = "https://api.imgur.com/3/image/" + hash + "/favorite";
  var client = http.Client();

    print(hash);
    await client.post(url,
        headers: {'Authorization': 'Bearer ' + token}).then((res) {
      var data = jsonDecode(res.body);
      print(res.body);
      getFav(token, cb);
    });
}

Widget fav(String token, List favList, Function cb) {
  return Container(
      color: Colors.red,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: favList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Stack(children: [
                  Image.network(favList[index]),
                  Positioned(
                      child: IconButton(
                          icon: Icon(Icons.star, size: 50.0),
                          onPressed: () async {
                            removeFav(favList[index], token, cb);
                          }))
                ]));
          }));
}
