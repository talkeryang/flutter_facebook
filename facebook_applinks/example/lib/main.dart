import 'dart:convert';

import 'package:facebook_applinks/facebook_applinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          title: const Text('Facebook AppLinks'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('fetchDeferredAppLink'),
              onTap: () async {
                try {
                  final DeferredAppLink link = await FacebookApplinks.instance.fetchDeferredAppLink();
                  print('link: ${json.encode(link)}');
                } on PlatformException catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
