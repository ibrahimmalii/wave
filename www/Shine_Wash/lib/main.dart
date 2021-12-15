import 'dart:convert';

import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/app/app.dart';
import 'package:Shinewash/app/cubit/cubit.dart';
import 'package:Shinewash/app/cubit/state.dart';
import 'package:Shinewash/bloc_observer.dart';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/models/localization.dart';
import 'package:Shinewash/screens/home/cubit/cubit.dart';
import 'package:Shinewash/screens/home/home_page.dart';
import 'package:Shinewash/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';

// fun() async {
// SharedPreferences local=await SharedPreferences.getInstance();
// var lang=local.getString('language');
// print(lang);
// var res=await CallApi().localizations('content',lang);
// var body=json.decode(res.body);
// localModel=localizationsModel.fromJson(body);
//   // getData();
// }

// getData() async {
//   print('data123');
//   SharedPreferences localStorage = await SharedPreferences.getInstance();
//   accessToken = localStorage.getString("access_token");
//   print(accessToken);
// }


void main() async {
  print("omnia");
  Widget startWidget;
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();


  SharedPreferences local = await SharedPreferences.getInstance();
  language=local.getString("language");
  accessToken = local.getString("accessToken");

  if (accessToken != null) {
    print('tokken $accessToken');
    language=local.getString("language");
    phone = local.getString("phone");
    password = local.getString("password");

    var body = {
      "phone_number":"$phone",
      "password":"$password",};

    await HomeCubit()..getUserDate(body);
    startWidget = SplashScreen();
  } else {
    language=local.getString("language");
    startWidget = SplashScreen1();
  }

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
  runApp(MyApp(
    start: startWidget,
    lang: language,
  ));
}

class MyApp extends StatelessWidget {
  Widget? start;
final String? lang;
  MyApp({this.start,this.lang});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..getLanguage(lang!,context),
        child: BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {
            // if (state is! AppLoadingState) {
            //   print('tarekkkk');
            //   start=SplashScreen();
            // }
            // AppCubit()..getLanguage(lang!,context);
            // start=SplashScreen1();
          },
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: start,

              // ),
            );
          },
        ));
  }
}
