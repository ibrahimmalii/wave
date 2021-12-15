import 'dart:convert';
import 'package:Shinewash/app/cubit/cubit.dart';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/models/user_model.dart';
import 'package:Shinewash/screens/otp/cubit/cubit.dart';
import 'package:Shinewash/screens/otp/cubit/state.dart';
import 'package:Shinewash/test/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shinewash/api/api.dart';
import '../forget_password/forgot_password.dart';
import '../onboarding.dart';

const darkBlue = Color(0xFF265E9E);
const containerShadow = Color(0xFF91B4D8);
const extraDarkBlue = Color(0xFF91B4D8);

class OTP extends StatefulWidget {
  final String? userIdOfOtp;

  const OTP({Key? key, this.userIdOfOtp}) : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final _otp = TextEditingController();
  var showSnipper = false;
  var _check = '';
  String? userId;
  int? userOtp;

  @override
  void initState() {
    // userId = int.parse(widget.userIdOfOtp.toString());
    // _checkPath();
    super.initState();
  }

  _checkPath() async {
    setState(() {
      showSnipper = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var path = localStorage.getString('signUp');
    if (path == '0') {
      _check = 'Verification';
    } else {
      _check = 'Forgot Password';
    }
    setState(() {
      showSnipper = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context)=>OTPCubit(),
      child: BlocConsumer<OTPCubit,OTPState>(
        listener: (context,state){
          if(state is OTPShowSpinner){
            showSnipper=true;
          }else{
            showSnipper=false;
          }
        },
        builder: (context,state){
          return Scaffold(
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
            body: ModalProgressHUD(
              inAsyncCall: showSnipper,
              child: SingleChildScrollView(
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
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.only(topRight: Radius.circular(45.0)),
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
                                        _check,
                                        style: TextStyle(
                                          color: darkBlue,
                                          fontSize: 20.0,
                                          fontFamily: 'Nadillas',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          'Please enter your Code number',
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
                                  Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: PinCodeTextField(
                                            maxLength: 6,
                                            autofocus: true,
                                            controller: _otp,
                                            keyboardType: TextInputType.number,
                                            highlight: true,
                                            highlightAnimation: true,
                                            pinBoxRadius: 10.0,
                                            onDone: (text) {
                                              userOtp = int.parse(_otp.text);
                                              final body = {
                                                "phone_number":
                                                "${widget.userIdOfOtp.toString()}",
                                                // "user_id": json.encode(194),
                                                "verification_code":
                                                userOtp.toString(),
                                                // "otp": json.encode(2222),
                                              };
                                              OTPCubit.get(context).saveUserData(body, context);
                                            },
                                          )

                                        // child: PinFieldAutoFill(
                                        //   keyboardType: TextInputType.number,
                                        //   controller: _otp,
                                        //   codeLength: 4,
                                        //   autofocus: true,
                                        //   textInputAction: TextInputAction.send,
                                        // ),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 80,
                                        child: IconButton(
                                          icon: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              '${model!.content!.resend}?',
                                              style: TextStyle(
                                                color: Color(0xFF004695),
                                                fontSize: 16,
                                                fontFamily: 'FivoSansMedium',
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPassword()));
                                          },
                                        ),
                                      ),
                                    ],
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
                                      onPressed: () {
                                        userOtp = int.parse(_otp.text);
                                        final body = {
                                          "phone_number":
                                          widget.userIdOfOtp.toString(),
                                          // "user_id": json.encode(194),
                                          "verification_code": userOtp.toString(),
                                          // "otp": json.encode(2222),
                                        };
                                        OTPCubit.get(context).saveUserData(body, context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        elevation: 2.0,
                                      ),
                                      child: Text(
                                        '${model!.content!.submit}',
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
          );
        },
      ),
    );
  }

  void _otpCheck(data) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      showSnipper = true;
    });
    var res;
    var bodyy;
    var resData;
    try {
      // res = userData;
      // // body=json.decode(res);
      // resData = res['data'];
      // print(resData);
      // if(resData!=null){
      //   print("yes");
      //     info=UserModel.fromJson(res);
      //       localStorage.setString( "access_token", "${info!.data!.accessToken}");
      //       print("${localStorage.get("access_token")}");
      //       Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => OnBoarding(),
      //             ));
      //
      // }

      res = await CallApi().postData(data, 'verify');
      bodyy = json.decode(res.body);
      setState(() {
        showSnipper = false;
      });
      if (bodyy != null) {
        print('yes');
        info = UserModel.fromJson(bodyy);
        localStorage.setString("access_token", "${info!.data!.accessToken}");
        localStorage.setString("name", "${info!.data!.user!.name}");
        localStorage.setString("role_id", "${info!.data!.user!.roleId}");
        localStorage.setString("avatar", "${info!.data!.user!.avatar}");
        localStorage.setString("phone_number","${info!.data!.user!.phoneNumber}");
        localStorage.setString("password","${data["password"]}");
        setState(() {
          showSnipper = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OnBoarding(),
            ));
      } else {
        showDialog(
          builder: (context) => AlertDialog(
            title: Text('Value empty'),
            content: Text('Invalid verification code entered!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    showSnipper = false;
                  });
                  Navigator.pop(context);
                  _otp.text = '';
                },
                child: Text('Try Again'),
              )
            ],
          ),
          context: context,
        );
      }

      // if(res.statusCode==200){
      //   resData = body['data'];
      //   // if( localStorage.getString("access_token") != null)
      //   info=UserModel.fromJson(resData);
      //   localStorage.setString( "access_token", "${info!.data!.accessToken}");
      //   print('tarek ${resData}');
      //   setState(() {
      //     showSnipper = false;
      //   });
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => OnBoarding(),
      //       ));
      // }
      // else{
      //   showDialog(
      //     builder: (context) => AlertDialog(
      //       title: Text('Value empty'),
      //       content: Text('Please check your inputs'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             setState(() {
      //               showSnipper = false;
      //             });
      //             Navigator.pop(context);
      //             _otp.text = '';
      //           },
      //           child: Text('Try Again'),
      //         )
      //       ],
      //     ),
      //     context: context,
      //   );
      // }

      // if (body['success'] == true) {
      //   int? checkotpdata = body['data']['otp'];
      //   if (checkotpdata == userOtp) {
      //     SharedPreferences localStorage =
      //         await SharedPreferences.getInstance();
      //     localStorage.setString('token', resData['token']);
      //     localStorage.setString('user', json.encode(resData));
      //     // localStorage.getString('token');
      //     localStorage.remove('signUp');
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => OnBoarding(),
      //         ));
      //   } else {
      //     showDialog(
      //       builder: (context) => AlertDialog(
      //         title: Text('Otp Error'),
      //         content: Text(resData.toString()),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //               _otp.text = '';
      //             },
      //             child: Text('Try Again'),
      //           )
      //         ],
      //       ),
      //       context: context,
      //     );
      //   }
      // } else {
      //   showDialog(
      //     builder: (context) => AlertDialog(
      //       title: Text('Otp Error'),
      //       content: Text(resData.toString()),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.pop(context);
      //             _otp.text = '';
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
          title: Text('Value empty'),
          content: Text('Something Wrong'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  showSnipper = false;
                });
                Navigator.pop(context);
                _otp.text = '';
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
