import 'dart:convert';

import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/models/user_model.dart';
import 'package:Shinewash/screens/forget_password/cubit/state.dart';
import 'package:Shinewash/screens/otp/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState>{
  ForgetPasswordCubit() : super(ForgetPasswordInitialState());

  static ForgetPasswordCubit get(context)=>BlocProvider.of(context);

  RegisterModel? registerModel;
  getPassword(data,context)async{
    emit(ForgetPasswordLoadingState());
    emit(ForgetPasswordShowSpinner());
    try{
      var res= await CallApi().postData(data, "forget");
      var body=json.decode(res.body);
      registerModel=RegisterModel.fromJson(body);
      emit(ForgetPasswordSuccessState());
      emit(ForgetPasswordStopSpinner());
      Navigator.push(context, (MaterialPageRoute(builder: (context)=>OTP(userIdOfOtp: registerModel!.phoneNumber,))));
    }catch(e){
      emit(ForgetPasswordErrorState(e.toString()));
    }
  }

}