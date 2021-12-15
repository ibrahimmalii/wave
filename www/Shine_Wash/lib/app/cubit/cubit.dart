import 'dart:convert';

import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/app/app.dart';
import 'package:Shinewash/app/cubit/state.dart';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/models/localization.dart';
import 'package:Shinewash/models/user_model.dart';
import 'package:Shinewash/screens/home/home_page.dart';
import 'package:Shinewash/screens/otp/otp_screen.dart';
import 'package:Shinewash/screens/sign_in/sign_in.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);




  getLanguage(String lang,[context])async {
    emit(AppLoadingState());
    try {

      var res =await CallApi().localizations('content', lang);
      print("res $res");
      var body=json.decode(res.body);
      model=LocalizationsModel.fromJson(body);
print("Hoda ${model!.content!.password}");
      emit(AppSuccessState());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
    } catch (e) {
      emit(AppErrorState(e.toString()));
    }
  }
  userLogin(data, context) async {


    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var res = await CallApi().postData(data, "login");
      var body = json.decode(res.body);
      if (body['msg'] == "User need to verify his account!") {
        showDialog(
            builder: (context) => AlertDialog(
              title: Text('login Error'),
              content: Text('Please verify his account'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTP(userIdOfOtp: data['phone_number'],),
                        ));
                  },
                  child: Text('Verify'),
                )
              ],
            ),
            context: context);
      } else {
        info = UserModel.fromJson(body);


        localStorage.setString(
            "accessToken", " ${info!.data!.accessToken}");
        accessToken = info!.data!.accessToken;
        localStorage.setString(
            "phone", " ${info!.data!.user!.phoneNumber}");
        localStorage.setString(
            "password", " ${data['password']}");
        print(info!.data!.accessToken);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {

    }
  }
}
