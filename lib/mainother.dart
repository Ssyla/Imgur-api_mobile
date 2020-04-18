import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'Post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epicture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Epicture Homepage'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _onConnect = false;
  String _accessTocken = "";
  String _userName = "";
  String _id = "";
  List _listImage= ["https://picsum.photos/250?image=9"];
  String _clientId = "811a3557ab496ee";

  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print(url);
      url = url.replaceFirst('#', '?');
      Uri data = Uri.dataFromString(url);
      setState(() {
        _accessTocken = data.queryParameters["access_token"];
        _userName = data.queryParameters["account_username"];
        _id = data.queryParameters["account_id"];
      });
    });
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged viewListen) {});
    flutterWebviewPlugin.close();
  }

  void _connectionimgur() {
    setState(() {
      _onConnect = true;
    });
  }

  Future<Post> fetchPost() async {
    final res = await http.get('https://api.imgur.com/3/gallery/hot/top/day/0', headers: {"Authorization": "Client-ID $_clientId"});
    print(res.body);
    return Post.fromJson(json.decode(res.body));
  }

  void _run() {
    setState(() {
      _listImage[0] = "https://i.imgur.com/l439l2k.jpg";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_onConnect == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _connectionimgur,
          tooltip: 'Connection',
          child: Icon(Icons.accessibility),
        ),
      );
    } else if (_accessTocken == "" || _accessTocken == null) {
      return WebviewScaffold(
        url: "https://api.imgur.com/oauth2/authorize?client_id=811a3557ab496ee&response_type=token"
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_userName),
        ),
        body: Column(
          children: <Widget> [
            Text(
              "bonjour utilisateur $_userName\nVoici les derniers post\n",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child:
                FutureBuilder<Post>(
                  future: fetchPost(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(itemCount: 1/*snapshot.data.links.length*/, itemBuilder: (context, index) {
                        print(snapshot.data.links[0]['link']);
                        return (
                            Image.network(
                              snapshot.data.links[0]['link'],
                            )
                        );
                      });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _run,
          tooltip: 'Refresh',
          child: Icon(Icons.arrow_downward),
        ),
      );
    }
  }
}