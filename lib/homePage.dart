import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'userImage.dart';
import 'upload.dart';
import 'favoritePage.dart';

class HomePage extends StatefulWidget {
  final _name;
  final _token;

  const HomePage(this._name, this._token);

  @override
  State<StatefulWidget> createState() {
    return StateHomePage();
  }
}

// Authorization: Bearer YOUR_ACCESS_TOKEN

class StateHomePage extends State<HomePage> {
  var client = new http.Client();
  var pics = new List();
  var all = new List();
  int nb = 0;
  final search = TextEditingController();
  var onoff = new List();
  var favList = new List();

  @override
  void initState() {
    super.initState();
    listPic(widget._token, cbui);
  }

  @override
  Widget build(BuildContext context) {
    String title =
        widget._name == null ? 'Home Page' : widget._name + '\'s feed';
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: Text(title),
              centerTitle: true,
              bottom: TabBar(tabs: [
                Tab(
                    icon: IconButton(
                  icon: Icon(Icons.filter),
                  onPressed: () {
                    listPic(widget._token, cbui);
                  },
                )),
                Tab(icon: Icon(Icons.search)),
                Tab(
                    icon: IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () async {
                          await getFav(widget._token, cbfav);
                        })),
              ])),
          body: TabBarView(children: [
            userImage(pics),
            Container(
                color: Colors.grey[300],
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: search,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Search",
                            suffixIcon: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  submit(search.text);
                                })),
                      )),
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: all.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Stack(children: [
                                  Image.network(all[index][0]),
                                  Positioned(
                                      child: IconButton(
                                          icon: Icon(
                                              (!onoff[index]
                                                  ? Icons.star_border
                                                  : Icons.star),
                                              size: 50.0),
                                          onPressed: () {
                                            addFav(all[index][1], index);
                                          }))
                                ]));
                          }))
                ])),
            fav(widget._token, favList, cbfav)
          ]),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.file_upload),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadPage(widget._token)));
              }),
        ));
  }

  addFav(String hash, int index) async {
    String url = "https://api.imgur.com/3/image/" + hash + "/favorite";

    print(hash);
    await client.post(url,
        headers: {'Authorization': 'Bearer ' + widget._token}).then((res) {
      var data = jsonDecode(res.body);
      // print(res.body);
      setState(() {
        if (data["success"] && data["data"] == "favorited") {
          onoff[index] = true;
        } else {
          onoff[index] = false;
        }
      });
    });
  }

  submit(String tags) async {
    nb = 0;

    all.clear();
    onoff.clear();
    while (all.length < 50 && nb < 50) {
      String url = 'https://api.imgur.com/3/gallery/search/' +
          nb.toString() +
          '/?q_all=' +
          tags;
      // print(url);
      await client.get(url,
          headers: {'Authorization': 'Bearer ' + widget._token}).then((res) {
        // print(res.body);
        Map<String, dynamic> data = jsonDecode(res.body);
        setState(() {
          for (var p in data["data"]) {
            if (p["type"] != null && p["type"].toString().contains("image")) {
              print(p);
              all.add([
                p["link"],
                p["id"]
              ]);
              onoff.add(p["favorite"]);
              // print(p["tags"][0]["background_hash"]);
            }
          }
        });
      });
      nb++;
    }
  }

  cbui(List newPics) {
    pics.clear();
    setState(() {
      pics = newPics;
    });
  }

  cbfav(List newFavs) {
    favList.clear();
    setState(() {
      favList = newFavs;
    });
  }
}
