import 'dart:convert';

import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/models/service_model.dart';
import 'package:Shinewash/models/user_model.dart';
import 'package:Shinewash/screens/home/cubit/state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  getUserDate(data, [context]) async {
    print(data);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    phone = localStorage.getString("phone");
    password = localStorage.getString("password");
    var res = await CallApi().postData(data, "login");
    var body = json.decode(res.body);
    info = UserModel.fromJson(body);
    print("Info $info");
  }

  List<serviceModel>? servicemodel;

  getService()async {
    SharedPreferences local=await SharedPreferences.getInstance();
    var lang =local.getString("language");
    var res=await CallApi().get('services',"$lang");
    var body=json.decode(res.body);
    body.forEach((element){
      servicemodel!.add(serviceModel.fromJson(element));
    });
  }

}
