import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'Enter_your_base_url/api/';

  postData(data, apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.post(fullUrl, body: data);
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

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
  }
}
