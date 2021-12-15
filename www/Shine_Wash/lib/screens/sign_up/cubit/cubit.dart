import 'dart:convert';

import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/models/user_model.dart';
import 'package:Shinewash/screens/otp/otp_screen.dart';
import 'package:Shinewash/screens/sign_up/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  RegisterModel? registerModel;

  userRegister(data, context) async {
    emit(SignUpLoadingState());
    emit(SignUpShowSpinner());

    try{
      var res =await CallApi().postData(data, "register");

      var body = json.decode(res.body);
      registerModel = RegisterModel.fromJson(body);
      emit(SignUpSuccessState());
      emit(SignUpStopSpinner());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>OTP(userIdOfOtp: registerModel!.phoneNumber,)));
    }
    catch(e){
      emit(SignUpErrorState(e.toString()));
    }
  }
}
