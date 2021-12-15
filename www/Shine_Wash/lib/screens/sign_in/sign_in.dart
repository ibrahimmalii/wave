// import 'dart:convert';
// import 'package:Shinewash/component/constant.dart';
// import 'package:Shinewash/models/user_model.dart';
// import 'package:Shinewash/test/test.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_locales/flutter_locales.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Shinewash/api/api.dart';
// import 'package:Shinewash/screens/home/home_page.dart';
// import 'package:Shinewash/screens/payment.dart';
// import '../forgot_password.dart';
// import '../otp_screen.dart';
// import '../sign_up.dart';
//
// const darkBlue = Color(0xFF265E9E);
// const containerShadow = Color(0xFF91B4D8);
// const extraDarkBlue = Color(0xFF91B4D8);
//
// class SignIn extends StatefulWidget {
//   @override
//   _SignInState createState() => _SignInState();
// }
//
// class _SignInState extends State<SignIn> {
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   FocusNode phone = FocusNode();
//   FocusNode password = FocusNode();
//   var showSnipper = false;
//   String playerIddd = "";
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//     // getDeviceToken();
//   }
//
//   Future<bool> check() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//   getDeviceToken() async {
//     check().then((internet) async {
//       if (internet != null && internet) {
//         // Internet Present Case
//         // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
//         // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
//
//         await OneSignal.shared
//             .promptUserForPushNotificationPermission(fallbackToSettings: true);
//
//         String status = "";
//         await OneSignal.shared.getDeviceState().then((value) {
//           status = value!.userId!;
//           print('device token is $status');
//         });
//         //TODO:migration checking
//         playerIddd = status;
//         print('device token is $playerIddd');
//         SharedPreferences localStorage = await SharedPreferences.getInstance();
//         localStorage.setString('device_token', status);
//       } else {
//         showDialog(
//           builder: (context) => AlertDialog(
//             title: Text('Internet connection'),
//             content: Text('Check your internet connection'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SignIn(),
//                       ));
//                 },
//                 child: Text('OK'),
//               )
//             ],
//           ),
//           context: context,
//         );
//       }
//     });
//   }
//
//   void _login(data) async {
//     check().then((internet) async {
//       if (internet != null && internet) {
//         setState(() {
//           showSnipper = true;
//         });
//         SharedPreferences localStorage = await SharedPreferences.getInstance();
//
//         var res;
//         var body;
//         var resData;
//         var userId;
//         String msg = "User need to verify his account!";
//         String msg1 = "Invalid password, please check your data and try again";
//         // String msg3 = "33";
//         try {
//           res = await CallApi().postData(data, 'login');
//           body = json.decode(res.body);
//           // body = msg3;
//           if (msg == body['msg']) {
//             showDialog(
//               builder: (context) => AlertDialog(
//                 title: Text('Login Error'),
//                 content: Text('Please verify your account'),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () async {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => OTP(
//                               userIdOfOtp: localStorage.getString("phone"),
//                             ),
//                           ));
//                     },
//                     child: Text('OK'),
//                   )
//                 ],
//               ),
//               context: context,
//             );
//           } else if (msg1==body['msg']) {
//             showDialog(
//               builder: (context) => AlertDialog(
//                 title: Text('Login Error'),
//                 content: Text('please check your data and try again'),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//
//                     },
//                     child: Text('OK'),
//                   )
//                 ],
//               ),
//               context: context,
//             );
//           } else {
//
//             info = UserModel.fromJson(body);
//             print("Info ${info!.data!.user!.name}");
//             print("Info ${info!.data!.accessToken}");
//             if (info!.data!.user!.roleId== 2) {
//               localStorage.setString(
//                   "access_token", "${info!.data!.accessToken}");
//               localStorage.setString("name", "${info!.data!.user!.name}");
//               localStorage.setString("role_id", "${info!.data!.user!.roleId}");
//               localStorage.setString("avatar", "${info!.data!.user!.avatar}");
//               localStorage.setString("phone_number","${info!.data!.user!.phoneNumber}");
//               localStorage.setString("password","${data["password"]}");
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePage(),
//                   ));
//             } else {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePage(),
//                   ));
//             }
//           }
//
// //           resData = body['data'];
// //           if (body['success'] == true) {
// //             if (body['data']['is_verified'] == 1) {
// //               _phoneController.text = '';
// //               _passwordController.text = '';
// //               SharedPreferences localStorage =
// //                   await SharedPreferences.getInstance();
// //               localStorage.setString('token', resData['token']);
// //               localStorage.setString('user', json.encode(resData));
// //               // var abc = localStorage.getString('token');
// //               Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => navigate,
// //                   ));
// //             } else {
// //               showDialog(
// //                 builder: (context) => AlertDialog(
// //                   title: Text('Login Error'),
// //                   content: Text('Please verify your account'),
// //                   actions: <Widget>[
// //                     TextButton(
// //                       onPressed: () async {
// //                         _phoneController.text = '';
// //                         _passwordController.text = '';
// //                         SharedPreferences localStorage =
// //                             await SharedPreferences.getInstance();
// //                         localStorage.setString('token', resData['token']);
// //                         localStorage.setString('user', json.encode(resData));
// //                         // localStorage.getString('token');
// //                         userId = body['data']['id'];
// //                         Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => OTP(
// //                                 // userIdOfOtp: userId,
// //                               ),
// //                             ));
// //                       },
// //                       child: Text('OK'),
// //                     )
// //                   ],
// //                 ),
// //                 context: context,
// //               );
// //             }
// //           } else {
// //             print(body['message']);
// //             showDialog(
// //               builder: (context) => AlertDialog(
// //                 title: Text('Login Error'),
// //                 content: Text(body['message'].toString()),
// //                 actions: <Widget>[
// //                   TextButton(
// //                     onPressed: () {
// // //                Navigator.popAndPushNamed(context, Login.route);
// //                       Navigator.pop(context);
// //                     },
// //                     child: Text('Try Again'),
// //                   )
// //                 ],
// //               ),
// //               context: context,
// //             );
// //           }
//         } catch (e) {
//           showDialog(
//             builder: (context) => AlertDialog(
//               title: Text('Login Error'),
//               content: Text(e.toString()),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Try Again'),
//                 )
//               ],
//             ),
//             context: context,
//           );
//         }
//         setState(() {
//           showSnipper = false;
//         });
//       } else {
//         showDialog(
//           builder: (context) => AlertDialog(
//             title: Text('Internet connection'),
//             content: Text('Check your internet connection'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SignIn(),
//                       ));
//                 },
//                 child: Text('OK'),
//               )
//             ],
//           ),
//           context: context,
//         );
//       }
//     });
//   }
// int x=1;
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Scaffold(
//
//
//         body: ModalProgressHUD(
//           inAsyncCall: showSnipper,
//           child: SingleChildScrollView(
//             child: GestureDetector(
//               onTap: () {
//                 FocusScopeNode currentFocus = FocusScope.of(context);
//                 if (!currentFocus.hasPrimaryFocus) {
//                   currentFocus.unfocus();
//                 }
//               },
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: Theme.of(context).primaryColor,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height / 2.5,
//                       child: Image(
//                         alignment: Alignment.center,
//                         height: 90.0,
//                         width: 252.0,
//                         image: AssetImage('assets/icons/shinewashicon.png'),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         height: double.infinity,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(45.0)),
//                           color: Colors.white,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text(
//                                 '${localModel!.content!.signin}',
//                                 style: TextStyle(
//                                   color: darkBlue,
//                                   fontSize: 20.0,
//                                   fontFamily: 'Nadillas',
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 10.0),
//                                 height:
//                                     MediaQuery.of(context).size.height / 3.5,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(35.0)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: containerShadow,
//                                               blurRadius: 2,
//                                               offset: Offset(0, 0),
//                                               spreadRadius: 1,
//                                             )
//                                           ]),
//                                       child: TextFormField(
//                                         controller: _phoneController,
//                                         focusNode: phone,
//                                         onFieldSubmitted: (a) {
//                                           phone.unfocus();
//                                           FocusScope.of(context)
//                                               .requestFocus(password);
//                                         },
//                                         validator: (value) {
//                                           Pattern pattern =
//                                               r'(^(?:[+0]9)?[0-9]{10,12}$)';
//                                           RegExp regex =
//                                               new RegExp(pattern as String);
//                                           // Null check
//                                           if (value!.isEmpty) {
//                                             return 'please enter your  mobile number';
//                                           }
//                                           // Valid email formatting check
//                                           else if (!regex.hasMatch(value)) {
//                                             return 'Enter valid  mobile number';
//                                           }
//                                           // success condition
//                                           return null;
//                                         },
//                                         enableSuggestions: false,
//                                         keyboardType:
//                                             TextInputType.visiblePassword,
//                                         decoration: InputDecoration(
//                                           contentPadding: EdgeInsets.all(15),
//                                           border: InputBorder.none,
//                                           suffixIcon: Icon(
//                                             Icons.phone,
//                                             color: darkBlue,
//                                             size: 22,
//                                           ),
//                                           // SvgPicture.asset(
//                                           //   'assets/icons/',
//                                           //   fit: BoxFit.scaleDown,
//                                           // ),
//
//                                           hintText: '${localModel!.content!.phoneNumber}',
//                                           hintStyle: TextStyle(
//                                             color: darkBlue,
//                                             fontSize: 16,
//                                             fontFamily: 'FivoSansMedium',
//                                           ),
//                                         ),
//                                         style: TextStyle(
//                                           color: darkBlue,
//                                           fontSize: 16,
//                                           fontFamily: 'FivoSansMedium',
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(35.0)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: containerShadow,
//                                               blurRadius: 2,
//                                               offset: Offset(0, 0),
//                                               spreadRadius: 1,
//                                             )
//                                           ]),
//                                       child: TextFormField(
//                                         controller: _passwordController,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return "Please Enter Password";
//                                           } else if (value.length < 6) {
//                                             return "Password must be atleast 8 characters long";
//                                           } else {
//                                             return null;
//                                           }
//                                         },
//                                         focusNode: password,
//                                         onFieldSubmitted: (a) {
//                                           password.unfocus();
//                                         },
//                                         obscureText: true,
//                                         decoration: InputDecoration(
//                                           contentPadding: EdgeInsets.all(15),
//                                           border: InputBorder.none,
//                                           suffixIcon: SvgPicture.asset(
//                                             'assets/icons/lockicon.svg',
//                                             fit: BoxFit.scaleDown,
//                                           ),
//                                           hintText: '${localModel!.content!.password}',
//                                           hintStyle: TextStyle(
//                                             color: darkBlue,
//                                             fontSize: 16,
//                                             fontFamily: 'FivoSansMedium',
//                                           ),
//                                         ),
//                                         style: TextStyle(
//                                           color: darkBlue,
//                                           fontSize: 16,
//                                           fontFamily: 'FivoSansMedium',
//                                         ),
//                                       ),
//                                     ),
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: TextButton(
//                                         onPressed: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ForgotPassword(),
//                                               ));
//                                         },
//                                         child: Text(
//                                           '${localModel!.content!.forgetPassword}',
//                                           style: TextStyle(
//                                             color: extraDarkBlue,
//                                             fontFamily: 'FivoSansRegular',
//                                             fontSize: 15,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   Container(
//                                     margin: EdgeInsets.all(10.0),
//                                     width: MediaQuery.of(context).size.width,
//                                     height: 50.0,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(35.0)),
//                                     ),
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         if (_formKey.currentState!.validate()) {
//                                           final body = {
//                                             "phone_number":
//                                                 "+2${_phoneController.text}",
//                                             "password":
//                                                 _passwordController.text,
//                                             // "provider": "LOCAL",
//                                           };
//                                           print("BODY$body");
//                                           _login(body);
//                                         }
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         primary: Theme.of(context).primaryColor,
//                                         elevation: 2.0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(35.0),
//                                           ),
//                                         ),
//                                       ),
//                                       child: Text(
//                                         '${localModel!.content!.signin}',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontFamily: 'FivoSansRegular',
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       FittedBox(
//                                         child: Text(
//                                           '${localModel!.content!.newUser}',
//                                           style: TextStyle(
//                                               color: darkBlue,
//                                               fontSize: 18,
//                                               fontFamily: 'FivoSansRegular'),
//                                         ),
//                                       ),
//                                       SizedBox(width: 15.0,),
//                                       TextButton(
//                                         child: Text(
//                                           '${localModel!.content!.signup}',
//                                           style: TextStyle(
//                                             color: Color(0xFF004695),
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             fontFamily: 'FivoSansMedium',
//                                           ),
//                                         ),
//                                         onPressed: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       SignUp()));
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:Shinewash/app/cubit/cubit.dart';
import 'package:Shinewash/component/constant.dart';
import 'package:Shinewash/screens/forget_password/forgot_password.dart';
import 'package:Shinewash/screens/sign_in/cubit/cubit.dart';
import 'package:Shinewash/screens/sign_in/cubit/state.dart';
import 'package:Shinewash/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

const darkBlue = Color(0xFF265E9E);
const containerShadow = Color(0xFF91B4D8);
const extraDarkBlue = Color(0xFF91B4D8);


class SignIn extends StatelessWidget {

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode phone = FocusNode();
  FocusNode password = FocusNode();

  String playerIddd = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context).model;
    var cubit1 = AppCubit.get(context).model;
    return BlocProvider(
      create: (BuildContext context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginState>(
        listener: (context,state){
          if(state is LoginShowSpinner){
            print('show');
            showSnipper=true;
          }
          else{
            showSnipper = false;
          }
        },
        builder:(context,state){
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
                              height: MediaQuery.of(context).size.height / 2.5,
                              child:const Image(
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
                                decoration:const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(45.0)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                       Text(
                                        '${cubit!.content!.signin}',
                                        style: TextStyle(
                                          color: darkBlue,
                                          fontSize: 20.0,
                                          fontFamily: 'Nadillas',
                                        ),
                                      ),
                                      Container(
                                        margin:const EdgeInsets.symmetric(horizontal: 10.0),
                                        height:
                                        MediaQuery.of(context).size.height / 3.5,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              decoration:const BoxDecoration(
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
                                                focusNode: phone,
                                                onFieldSubmitted: (a) {
                                                  phone.unfocus();
                                                  FocusScope.of(context)
                                                      .requestFocus(password);
                                                },
                                                validator: (value) {
                                                  Pattern pattern =
                                                      r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                                  RegExp regex =
                                                  new RegExp(pattern as String);
                                                  // Null check
                                                  if (value!.isEmpty) {
                                                    return 'please enter your  mobile number';
                                                  }
                                                  // Valid email formatting check
                                                  else if (!regex.hasMatch(value)) {
                                                    return 'Enter valid  mobile number';
                                                  }
                                                  // success condition
                                                  return null;
                                                },
                                                enableSuggestions: false,
                                                keyboardType:
                                                TextInputType.visiblePassword,
                                                decoration: const InputDecoration(
                                                  contentPadding: EdgeInsets.all(15),
                                                  border: InputBorder.none,
                                                  suffixIcon: Icon(
                                                    Icons.phone,
                                                    color: darkBlue,
                                                    size: 22,
                                                  ),
                                                  // SvgPicture.asset(
                                                  //   'assets/icons/',
                                                  //   fit: BoxFit.scaleDown,
                                                  // ),

                                                  hintText: "Phone Number",
                                                  hintStyle: TextStyle(
                                                    color: darkBlue,
                                                    fontSize: 16,
                                                    fontFamily: 'FivoSansMedium',
                                                  ),
                                                ),
                                                style:const TextStyle(
                                                  color: darkBlue,
                                                  fontSize: 16,
                                                  fontFamily: 'FivoSansMedium',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration:const BoxDecoration(
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
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please Enter Password";
                                                  } else if (value.length < 6) {
                                                    return "Password must be atleast 8 characters long";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                focusNode: password,
                                                onFieldSubmitted: (a) {
                                                  password.unfocus();
                                                },
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(15),
                                                  border: InputBorder.none,
                                                  suffixIcon: SvgPicture.asset(
                                                    'assets/icons/lockicon.svg',
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                  hintText: 'password',
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
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>ForgotPassword()
                                                        // ForgotPassword(),
                                                      ));
                                                },
                                                child: Text(
                                                  '${cubit.content!.forgetPassword}',
                                                  style: TextStyle(
                                                    color: extraDarkBlue,
                                                    fontFamily: 'FivoSansRegular',
                                                    fontSize: 15,
                                                  ),
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
                                                    "phone_number":
                                                    "+2${_phoneController.text}",
                                                    "password":
                                                    _passwordController.text,
                                                    // "provider": "LOCAL",
                                                  };
                                                  print("BODY$body");
                                                  LoginCubit.get(context).userLogin(body,context);
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
                                                "${cubit.content!.signin}",
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
                                                  '${cubit.content!.newUser}',
                                                  style: TextStyle(
                                                      color: darkBlue,
                                                      fontSize: 18,
                                                      fontFamily: 'FivoSansRegular'),
                                                ),
                                              ),
                                              SizedBox(width: 15.0,),
                                              TextButton(
                                                child: Text(
                                                  '"${cubit.content!.signup}"',
                                                  style: TextStyle(
                                                    color: Color(0xFF004695),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'FivoSansMedium',
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignUp()));
                                                },
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
      ),
    );
  }
}
