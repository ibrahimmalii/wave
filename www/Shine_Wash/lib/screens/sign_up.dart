import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/screens/onboarding.dart';
import 'package:Shinewash/screens/sign_in.dart';
import 'package:country_picker/country_picker.dart';
// import 'package:country_code_picker/country_code_picker.dart';
import 'otp_screen.dart';
import 'package:http/http.dart' as http;
const darkBlue = Color(0xFF265E9E);
const containerShadow = Color(0xFF91B4D8);

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  FocusNode username = FocusNode();
  FocusNode email = FocusNode();
  FocusNode phone = FocusNode();
  FocusNode password = FocusNode();
  String _countryCode = "+91";
  var showSnipper = false;
  var playerIddd;
  // Country _country;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setDeviceToken();
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

  setDeviceToken() async {
    check().then((internet) async {
      if (internet != null && internet) {
        // Internet Present Case
        // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

        //TODO:migration checking
        await OneSignal.shared
            .promptUserForPushNotificationPermission(fallbackToSettings: true);

        String? status = "";
        await OneSignal.shared.getDeviceState().then((value) {
          status = value!.userId;
          print('device token is $status');
        });

        var playerId = status!;
        playerIddd = playerId;
        print('device token is $playerIddd');
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('device_token', playerId);
      } else {
        showDialog(
          builder: (context) => AlertDialog(
            title: Text('Internet connection'),
            content: Text('Check your internet connection'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ));
                },
                child: Text('OK'),
              )
            ],
          ),
          context: context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.8,
                      child: Image(
                        alignment: Alignment.center,
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
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(45.0)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Signup',
                                style: TextStyle(
                                  color: darkBlue,
                                  fontSize: 20.0,
                                  fontFamily: 'Nadillas',
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                height:
                                    MediaQuery.of(context).size.height / 2.8,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
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
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            "";
                                          }

                                        },

                                        controller: _usernameController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'please enter username';
                                          }
                                          return null;
                                        },

                                        focusNode: username,
                                        onFieldSubmitted: (a) {
                                          username.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(email);
                                        },
                                        enableSuggestions: false,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          border: InputBorder.none,
                                          suffixIcon: SvgPicture.asset(
                                            'assets/icons/usericon.svg',
                                            fit: BoxFit.scaleDown,
                                          ),
                                          hintText: 'User Name',
                                          hintStyle: TextStyle(
                                            color: darkBlue,
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
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.white,
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(35.0)),
                                    //       boxShadow: [
                                    //         BoxShadow(
                                    //           color: containerShadow,
                                    //           blurRadius: 2,
                                    //           offset: Offset(0, 0),
                                    //           spreadRadius: 1,
                                    //         )
                                    //       ]),
                                    //   child: TextFormField(
                                    //     controller: _emailController,
                                    //     validator: (value) {
                                    //       Pattern pattern =
                                    //           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    //       RegExp regex =
                                    //           new RegExp(pattern as String);
                                    //       // Null check
                                    //       if (value!.isEmpty) {
                                    //         return 'please enter your email';
                                    //       }
                                    //       // Valid email formatting check
                                    //       else if (!regex.hasMatch(value)) {
                                    //         return 'Enter valid email address';
                                    //       }
                                    //       // success condition
                                    //       return null;
                                    //     },
                                    //     focusNode: email,
                                    //     onFieldSubmitted: (a) {
                                    //       email.unfocus();
                                    //       FocusScope.of(context)
                                    //           .requestFocus(phone);
                                    //     },
                                    //     enableSuggestions: false,
                                    //     keyboardType:
                                    //         TextInputType.visiblePassword,
                                    //     decoration: InputDecoration(
                                    //       contentPadding: EdgeInsets.all(15),
                                    //       border: InputBorder.none,
                                    //       suffixIcon: SvgPicture.asset(
                                    //         'assets/icons/emailicon.svg',
                                    //         fit: BoxFit.scaleDown,
                                    //       ),
                                    //       hintText: 'E-mail Address',
                                    //       hintStyle: TextStyle(
                                    //         color: darkBlue,
                                    //         fontSize: 16,
                                    //         fontFamily: 'FivoSansMedium',
                                    //       ),
                                    //     ),
                                    //     style: TextStyle(
                                    //       color: darkBlue,
                                    //       fontSize: 16,
                                    //       fontFamily: 'FivoSansMedium',
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Padding(
                                          //   padding: EdgeInsets.only(left: 8.0),
                                          //   child: CountryCodePicker(
                                          //     initialSelection: 'IN',
                                          //     onInit: (country) {
                                          //       _countryCode = country.dialCode;
                                          //     },
                                          //     onChanged: (countrycode) {
                                          //       _countryCode =
                                          //           countrycode.toString();
                                          //     },
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: InkWell(
                                              onTap: () {
                                                showCountryPicker(
                                                  context: context,
                                                  showPhoneCode:
                                                      true, // optional. Shows phone code before the country name.
                                                  onSelect: (Country country) {
                                                    setState(() {
                                                      _countryCode =
                                                          "+${country.phoneCode.toString()}";
                                                    });
                                                    print(
                                                        'Select country: ${country.displayName}');
                                                    print(
                                                        'Select country: ${country.countryCode}');
                                                    print(
                                                        'Select country: ${country.phoneCode}');
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.035,
                                                width: 50,
                                                // color: Colors.black,
                                                child: Center(
                                                  child: Text(
                                                    _countryCode,
                                                    style: TextStyle(
                                                      color: darkBlue,
                                                      fontSize: 16,
                                                      fontFamily:
                                                          'FivoSansMedium',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1.5,
                                            height: 35.0,
                                            color: containerShadow,
                                          ),
                                          Container(
                                            width: 180,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _phoneController,
                                              validator: (String? value) {
                                                String patttern =
                                                    r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                                RegExp regExp =
                                                    new RegExp(patttern);
                                                if (value!.length > 10) {
                                                  return 'Please enter mobile number';
                                                } else if (!regExp
                                                    .hasMatch(value)) {
                                                  return 'Please enter valid mobile number';
                                                }
                                                return null;
                                              },
                                              focusNode: phone,
                                              onFieldSubmitted: (a) {
                                                phone.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(password);
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                border: InputBorder.none,
                                                hintText: 'Mobile Number',
                                                counterText: '',
                                                hintStyle: TextStyle(
                                                  color: darkBlue,
                                                  fontSize: 16,
                                                  fontFamily: 'FivoSansMedium',
                                                ),
                                              ),
                                              maxLength: 10,
                                              style: TextStyle(
                                                color: darkBlue,
                                                fontSize: 16,
                                                fontFamily: 'FivoSansMedium',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 15.0),
                                            child: Icon(
                                              Icons.phone,
                                              color: darkBlue,
                                              size: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
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

                                        controller: _passwordController,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Password";
                                          } else if (value.length < 8) {
                                            return "Password must be atleast 8 characters long";
                                          } else {
                                            return null;
                                          }
                                        },
                                        focusNode: password,
                                        onFieldSubmitted: (a) {
                                          password.unfocus();
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          border: InputBorder.none,
                                          suffixIcon: SvgPicture.asset(
                                            'assets/icons/lockicon.svg',
                                            fit: BoxFit.scaleDown,
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                            color: darkBlue,
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
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(35.0)),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          final body = {
                                            "name": _usernameController.text,

                                            "password":
                                                _passwordController.text,
                                            "phone_number": "${_countryCode+_phoneController.text}",
                                            // "phone_code": _countryCode,
                                          };
                                          // print("${_countryCode+_phoneController.text}");
                                          _registration(body);
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Signup',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'FivoSansRegular',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          'Already have an account?',
                                          style: TextStyle(
                                              color: darkBlue,
                                              fontSize: 18,
                                              fontFamily: 'FivoSansRegular'),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 80,
                                        child: IconButton(
                                          icon: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              'Sign in',
                                              style: TextStyle(
                                                color: Color(0xFF004695),
                                                fontSize: 25,
                                                fontFamily: 'FivoSansMedium',
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SignIn(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
    );
  }


  void _registration(data) async {
    setState(() {
      showSnipper = true;
    });
    var res;
    var body;
    var resData;
    var userId;

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('signUp', '0');
    var deviceToken = playerIddd;
    var checkDeviceToken = localStorage.getBool('deviceToken');
    if (checkDeviceToken == true) {

      data['device_token'] = deviceToken;
    }
    try {
      // res = await CallApi().postData(data,'register');
res={"phone_number":"+201228845512"};
localStorage.setString("phone", res["phone_number"]);
print("Phone ${localStorage.getString("phone")}");
      // print("body ${res.body['phone_number']}");
      // body = json.decode(res.body);
      // if (res.statusCode == 200) {
      //   setState(() {
      //     showSnipper=false;
      //   });


        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTP(userIdOfOtp: localStorage.getString("phone"),),
            ));
        setState(() {
          showSnipper = false;
        });
      // }
      // print('function body is ${res.body}');
      // resData = body['success'];
      // print('resData $resData');
      // userId = body['data']['id'];
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => OTP(userIdOfOtp: 15),
      //     ));
      // if (body['success'] == true) {
      //   if (body['data']['is_verified'] == 1) {
      //     SharedPreferences localstorage =
      //         await SharedPreferences.getInstance();
      //     localstorage.setString('token', body['data']['token']);
      //
      // localStorage.setString('user', json.encode(body['data']));
      //
      //     showDialog(
      //       builder: (context) => AlertDialog(
      //         title: Text('Registration Success'),
      //         content: Text('congratulation'),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               _usernameController.text = '';
      //               _emailController.text = '';
      //               _phoneController.text = '';
      //               _passwordController.text = '';
      //               Navigator.pop(context);
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => OnBoarding(),
      //                   ));
      //             },
      //             child: Text('OK'),
      //           )
      //         ],
      //       ),
      //       context: context,
      //     );
      //   }
      //   else {
      //     showDialog(
      //       builder: (context) => AlertDialog(
      //         title: Text('Verification Required'),
      //         content: Text('Please verify'),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               // print('${body['data']['otp']}');
      //               _usernameController.text = '';
      //               _emailController.text = '';
      //               _phoneController.text = '';
      //               _passwordController.text = '';
      //               Navigator.pop(context);
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => OTP(userIdOfOtp: userId),
      //                   ));
      //             },
      //             child: Text('OK'),
      //           )
      //         ],
      //       ),
      //       context: context,
      //     );
      //   }
      // } else {
      //   showDialog(
      //     builder: (context) => AlertDialog(
      //       title: Text('Registration Error'),
      //       content: Text(body['errors'].toString()),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.pop(context);
      //             setState(() {
      //               showSnipper = false;
      //             });
      //           },
      //           child: Text('Try Again'),
      //         )
      //       ],
      //     ),
      //     context: context,
      //   );
      // }
    } catch (e) {
      print('Error ${e.toString()}');
      setState(() {
                    showSnipper = false;
                  });
      showDialog(
        builder: (context) => AlertDialog(
          title: Text('Registration Error'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showSnipper = false;
                });
              },
              child: Text('Try Again'),
            )
          ],
        ),
        context: context,
      );
    }

    return userId;
  }
}