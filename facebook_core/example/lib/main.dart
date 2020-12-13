import 'package:facebook_core/facebook_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Core'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('App ID'),
              onTap: () async {
                String appID = await FacebookSdk.instance.getApplicationId();
                print('App ID: $appID');
              },
            ),
          ],
        ),
      ),
    );
  }
}
