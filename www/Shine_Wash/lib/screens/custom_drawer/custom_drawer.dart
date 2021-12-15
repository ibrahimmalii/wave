import 'dart:convert';
import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/app/cubit/cubit.dart';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/screens/custom_drawer/cubit/cubit.dart';
import 'package:Shinewash/screens/custom_drawer/cubit/state.dart';
import 'package:Shinewash/screens/otp/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_appointment.dart';
import '../faq.dart';
import '../full_profile.dart';
import '../home/home_page.dart';
import '../map/map.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notification.dart';
import '../privacy_policy.dart';
import '../sign_in/sign_in.dart';

const darkBlue = Color(0xFF265E9E);
const extraDarkBlue = Color(0xFF91B4D8);

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int? tappedIndex;
  String? _userName = '';
  String? _completeImage = '';
  var _isLoggedIn = false;
  var _isLoggedInagain = false;
  var showSpinner = false;

  @override
  void initState() {
    // _getUserInfo();
    // _getLogAgain();
    // tappedIndex = 0;
    super.initState();
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }



  @override
  Widget build(BuildContext context) {

    model;
    List<String> items = [
      '${model!.content!.home}',
      '${model!.content!.map}',
      '${model!.content!.appointments}',
      '${model!.content!.notification}',
      '${model!.content!.privacyPolicies}',
      '${model!.content!.faq}',
      '${model!.content!.logout}',
    ];
    List<String> itemss = [
      '${model!.content!.home}',
      '${model!.content!.map}',
      '${model!.content!.appointments}',
      '${model!.content!.notification}',
      '${model!.content!.privacyPolicies}',
      '${model!.content!.faq}',
      '${model!.content!.login}',
    ];
    return BlocProvider(
      create: (context) => CustomDrawerCubit(),
      child: BlocConsumer<CustomDrawerCubit, CustomDrawerState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: false,
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    showDialog(
                      builder: (context) => AlertDialog(
                        title: Text('Change Language'),
                        content: Container(
                          height: 120,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Arabic'),
                                onTap: () async {
                                  SharedPreferences local =
                                      await SharedPreferences.getInstance();
                                  AppCubit()..getLanguage("ar", context);
                                  setState(() {
                                    // localModel = localizationsModel.fromJson(body);

                                    local.setString("language", 'ar');
                                    print("LLLLL ${local.getString("language")}");
                                  });
                                },
                              ),
                              ListTile(
                                title: Text('English'),
                                onTap: () async {
                                  SharedPreferences local =
                                      await SharedPreferences.getInstance();
                                  AppCubit()..getLanguage("en", context);

                                  setState(() {
                                    // localModel = localizationsModel.fromJson(body);
                                    local.setString("language", 'en');
                                    print("LLLLL ${local.getString("language")}");
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      context: context,
                    );
                  },
                  child: Icon(Icons.wifi_protected_setup),
                ),
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Drawer(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(50.0)),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 10.0,
                                  top: 10.0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 22.0,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3.0,
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            // _getLoginInfo();
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.0),
                                            ),
                                            child: Image(
                                              image: (""
                                                  == null
                                                  ? AssetImage(
                                                      'assets/icons/profile_picture.png')
                                                  : AssetImage(
                                                      'assets/images/no_image.png')),
                                              fit: BoxFit.fill,
                                              width: 100.0,
                                              height: 100.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      ),
                                      Text(
                                        //
                                        // "${info!.data!.user!.name}",
                                        "",
                                        style: TextStyle(
                                          fontFamily: 'FivoSansMedium',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      accessToken == null
                                          ? itemss[index]
                                          : items[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: tappedIndex == index
                                            ? Theme.of(context).primaryColor
                                            : darkBlue,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (items[index] == 'Home' ||
                                      items[index] == 'الصفحة الرئيسية') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomePage()));
                                  }
                                  if (items[index] == 'map' ||
                                      items[index] == 'الخريطة') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MapScreen()));
                                  }
                                  if (items[index] == 'appointment' ||
                                      items[index] == 'المواعيد') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AllAppointment()));
                                  }
                                  if (items[index] == 'notification' ||
                                      items[index] == 'الإشعارات') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Notifications()));
                                  }
                                  if (items[index] == 'privacy policies' ||
                                      items[index] == 'سياسات الخصوصية') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PrivacyPolicy()));
                                  }
                                  if (items[index] == 'FAQ' ||
                                      items[index] == 'التعليمات') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => FAQ()));
                                  }
                                  if (items[index] == 'logout' ||
                                      items[index] == 'تسجيل خروج') {
                                    CallApi().logout();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignIn()));
                                  }
                                  if (items[index] == 'login' ||
                                      items[index] == 'تسجيل الدخول') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignIn()));
                                  }
                                  tappedIndex = index;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
