import 'dart:convert';

import 'package:Shinewash/api/api.dart';

import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/models/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app.dart';

fun() async {
  var res = await CallApi().localizations('content');
  var body = json.decode(res.body);
  localModel = localizationsModel.fromJson(body);
  print("Suiiii");
}

void main() async {
  print("omnia");
  await fun();
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en','ar']);
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());

    // In debug mode, use the normal error widget which shows
    // the error message:
    if (inDebug) return ErrorWidget(details.exception);
    // In release builds, show a yellow-on-blue message instead:
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error!',
        style: TextStyle(color: Colors.yellow),
        textDirection: TextDirection.ltr,
      ),
    );
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      // LocaleBuilder(
      // builder:(locale)=>
          MaterialApp(
        // debugShowCheckedModeBanner: false,
        // localizationsDelegates: Locales.delegates,
        // supportedLocales: Locales.supportedLocales,
        // locale: locale,
        home: Application(),


      // ),
    );
  }
}
