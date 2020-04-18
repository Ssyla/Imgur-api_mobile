import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'webView.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "login page",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  final _clientId = "811a3557ab496ee";

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        alignment: Alignment.center,
        child: RaisedButton(
            child: Text("login"),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => WebView()));
            }),
      ),
    );
  }

  var client = new http.Client();

  Future<String> getToken() async {
    final url = "https://api.imgur.com/oauth2/authorize?client_id=" +
        widget._clientId +
        "&response_type=token";
  }
}
