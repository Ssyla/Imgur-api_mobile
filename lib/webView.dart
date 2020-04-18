import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epicture/homePage.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'homePage.dart';

class WebView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateWebView();
  }
}

class StateWebView extends State<WebView> {
  final url =
      "https://api.imgur.com/oauth2/authorize?client_id=811a3557ab496ee&response_type=token";
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String _accessToken = "";
  String _userName = "";

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print('URL: ' + url);
      if (url.contains("access_token=")) {
        print('token get');
        Uri data = Uri.dataFromString(url.replaceFirst('#', '?'));
        setState(() {
          _accessToken = data.queryParameters["access_token"];
          _userName = data.queryParameters["account_username"];
        });
        flutterWebviewPlugin.close();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(_userName, _accessToken)));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: url,
    );
  }
}
