import 'dart:convert';

import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/models/user_model.dart';
import 'package:Shinewash/screens/onboarding.dart';
import 'package:Shinewash/screens/otp/cubit/state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit() : super(OTPInitialState());

  static OTPCubit get(context) => BlocProvider.of(context);



  saveUserData(data, context) async {
    emit(OTPLoadingState());
    emit(OTPShowSpinner());
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var res = await CallApi().postData(data, "verify");
      var body = json.decode(res.body);
      if (body['msg'] == 'Phone number not found') {
        showDialog(
            builder: (context) => AlertDialog(
                  title: Text('Verify Error'),
                  content: Text('Something Error'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        emit(OTPStopSpinner());
                      },
                      child: Text('ok'),
                    )
                  ],
                ),
            context: context);
      } else {
        info = UserModel.fromJson(body);
        emit(OTPSuccessState());
        emit(OTPStopSpinner());
        localStorage.setString(
            "accessToken", " ${info!.data!.accessToken}");
        localStorage.setString(
            "phone", " ${info!.data!.user!.phoneNumber}");
        localStorage.setString(
            "password", " ${data['password']}");
        accessToken = info!.data!.accessToken;
        print(info!.data!.accessToken);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OnBoarding()));
      }
    } catch (e) {
      emit(OTPErrorState(e.toString()));
    }
  }
}
