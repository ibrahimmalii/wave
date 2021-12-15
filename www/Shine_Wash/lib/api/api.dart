import 'dart:convert';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/models/localization.dart';
import 'package:Shinewash/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'http://10.0.2.2:8000/api/';
  // final String _url = 'http://localhost:8000/api/';

  postData(data, apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    print("$fullUrl");
    print(json.encode(data));

    var response = await http.post(fullUrl, body: data);

    print("response ${response.statusCode}");
    print("response ${response.body}");
    print( response);

    return response;
  }

  postDataWithHeader(data, apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.post(fullUrl, body: data, headers: _setHeaders());
  }

  postDataWithToken(data, apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token')!;
    return await http.post(fullUrl, body: json.encode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    });
  }

  getData(apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.get(fullUrl, headers: _setHeader());
  }

  _setHeaders() => {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
      };

  _setHeader() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  getWithToken(apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    // print('token from api $token');
    return await http.get(fullUrl, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
  }
  localizations(apiUrl,lang)async{
print(lang);
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.get(fullUrl, headers:{"X-localization":"$lang"});
  }

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('access_token');
    print("remove ${localStorage.getString("access_token")}");
  }
}
