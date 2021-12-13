import 'dart:async';
import 'dart:convert';
import 'package:Shinewash/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api.dart';
import 'component/constant.dart';
import 'screens/all_appointment.dart';
import 'screens/home/home_page.dart';
import 'package:Shinewash/models/localization.dart';
class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  bool deviceToken = false;
  var appId;
Widget? widgetScreen;

  @override
  void initState() {
    fun();
    // getToken();
    super.initState();
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    // getOneSignalRequest();
  }


//   Future<void> getOneSignalRequest() async {
//     //one signal mate
//     await OneSignal.shared.setRequiresUserPrivacyConsent(true);
//     var settingApi = await CallApi().getData('setting');
//     var bodyy = json.decode(settingApi.body);
//     Map theDataa = bodyy['data'];
//     appId = theDataa['onesignal_app_id'];
//     OneSignal.shared.consentGranted(true);
//     OneSignal.shared.setAppId("$appId");
//
//     OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
//     //TODO:migration onesignal
//     OneSignal.shared.setAppId("$appId");
//     // OneSignal.shared.
//     // .setInFocusDisplayType(OSNotificationDisplayType.notification);
//
// // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//     await OneSignal.shared
//         .promptUserForPushNotificationPermission(fallbackToSettings: true);
//
//     // var status = await OneSignal.shared.getPermissionSubscriptionState();
//
//     Timer(Duration(seconds: 2), () async {
//       var playerId;
//       await OneSignal.shared.getDeviceState().then((value) {
//         playerId = value!.userId;
//         print('the player id is ${value.userId}');
//       });
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       if (playerId != null) {
//         localStorage.setBool('deviceToken', true);
//         deviceToken = true;
//       } else {
//         deviceToken = false;
//       }
//     });
//   }
//   getToken()async{
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//
//     accessToken=localStorage.getString("access_token");
//     if(accessToken!=null){
//       widgetScreen=HomePage();
//     }
//     else{
//       widgetScreen=SignIn();
//     }
//
//   }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(

      title: 'Shinewash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF6B48FF),
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Colors.transparent,
      ),
      home: SignIn(),
      // home: deviceToken == true
      //     ? HomePage()
      //     : showDialog(
      //         builder: (context) => AlertDialog(
      //           title: Text('Device Token'),
      //           content: Text(
      //               'Please turn on device token and Re-Run the application'),
      //           actions: <Widget>[
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.pop(context);
      //               },
      //               child: Text('Ok'),
      //             )
      //           ],
      //         ),
      //         context: context,
      //       ),
      // routes: <String, WidgetBuilder>{
      //   '/HomePage': (BuildContext context) => HomePage(),
      //   '/AllAppointment': (BuildContext context) => AllAppointment(),
      // },
    );
  }
}

void fun()async{
  var res=await CallApi().localizations('content');
  var body=json.decode(res.body);
  localModel=localizationsModel.fromJson(body);
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fun();
    startTime();
  }

  startTime() async {
    fun();
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Center(
          child: new Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
