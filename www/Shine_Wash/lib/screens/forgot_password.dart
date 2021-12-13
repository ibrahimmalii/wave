import 'dart:convert';
import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in.dart';

const darkBlue = Color(0xFF265E9E);
const containerShadow = Color(0xFF91B4D8);
const extraDarkBlue = Color(0xFF91B4D8);

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _phoneController = TextEditingController();
  var showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3.7,
                        child: Image(
                          alignment: Alignment.topCenter,
                          height: 90.0,
                          width: 252.0,
                          image: AssetImage('assets/icons/shinewashicon.png'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(45.0)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        color: darkBlue,
                                        fontSize: 20.0,
                                        fontFamily: 'Nadillas',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        'Please enter your mobile and we will send an OTP number',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: extraDarkBlue,
                                          fontSize: 16.0,
                                          fontFamily: 'FivoSansRegular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: containerShadow,
                                          blurRadius: 2,
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                        )
                                      ]),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    validator: (value) {
                                      Pattern pattern =
                                          r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                      RegExp regex =
                                          new RegExp(pattern as String);
                                      // Null check
                                      if (value!.isEmpty) {
                                        return 'please enter your mobile number';
                                      }
                                      // Valid email formatting check
                                      else if (!regex.hasMatch(value)) {
                                        return 'Enter valid mobile number';
                                      }
                                      // success condition
                                      return null;
                                    },
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 11,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: InputBorder.none,
                                      hintText: 'Mobile',
                                      hintStyle: TextStyle(
                                        color: extraDarkBlue,
                                        fontSize: 16,
                                        fontFamily: 'FivoSansMedium',
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: darkBlue,
                                      fontSize: 16,
                                      fontFamily: 'FivoSansMedium',
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final body = {
                                          "phone_number":"+2${_phoneController.text}",
                                        };
                                        print(body);
                                        _forgotPassword(body);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        elevation: 2.0),
                                    child: Text(
                                      'Send',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'FivoSansRegular',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _forgotPassword(data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      showSpinner = true;
    });
    var res;
    var body;
    var userId;
    try {
      res = await CallApi().postData(data, 'forget');
      body = json.decode(res.body);
      if (_phoneController.text.isNotEmpty) {
        setState(() {
                showSpinner = false;
              });
        localStorage.setString("phone", body["phone_number"]);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTP(userIdOfOtp: localStorage.getString("phone")),
            ));
      }
      // if (_phoneController.text.isNotEmpty) {
      //   if (body['success'] == true) {
      //     setState(() {
      //       showSpinner = false;
      //     });
      //     userId = body['data']['id'];
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => SignIn(),
      //         ));
      //   } else {
      //     showDialog(
      //       builder: (context) => AlertDialog(
      //         title: Text('Error'),
      //         content: Text(body['data'].toString()),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               setState(() {
      //                 showSpinner = false;
      //               });
      //               Navigator.pop(context);
      //             },
      //             child: Text('Try Again'),
      //           )
      //         ],
      //       ),
      //       context: context,
      //     );
      //   }
      // }
      // else {
      //   showDialog(
      //     builder: (context) => AlertDialog(
      //       title: Text('Phone Error'),
      //       content: Text('please enter valid Phone'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             setState(() {
      //               showSpinner = false;
      //             });
      //             Navigator.pop(context);
      //           },
      //           child: Text('Try Again'),
      //         )
      //       ],
      //     ),
      //     context: context,
      //   );
      // }
    } catch (e) {
      showDialog(
        builder: (context) => AlertDialog(
          title: Text('Phone Error'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  showSpinner = false;
                });
                Navigator.pop(context);
              },
              child: Text('Try Again'),
            )
          ],
        ),
        context: context,
      );
    }
  }
}
