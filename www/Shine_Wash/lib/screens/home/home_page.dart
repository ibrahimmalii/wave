import 'dart:async';
import 'package:Shinewash/app/cubit/cubit.dart';
import 'package:Shinewash/component/constant.dart';
import 'dart:convert';
import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/models/service_model.dart';
import 'package:Shinewash/screens/home/cubit/cubit.dart';
import 'package:Shinewash/screens/home/cubit/state.dart';
import 'package:Shinewash/screens/otp/cubit/cubit.dart';
import 'package:Shinewash/screens/sign_in/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shinewash/models/coworkerM.dart';
import 'package:Shinewash/models/employee_profile_skills.dart';
import 'package:Shinewash/models/home_category.dart';
import 'package:Shinewash/models/home_offer.dart';
import 'package:Shinewash/screens/custom_drawer/custom_drawer.dart';
import '../employee_profile.dart';
import '../services.dart';
import '../specialist_full_page.dart';
import 'package:connectivity/connectivity.dart';

const containerBackground = Color(0xFFE9F0F7);
const darkBlue = Color(0xFF265E9E);
const ratingStar = Color(0xFFFECD03);

class HomePage extends StatefulWidget {
  final String homepage = '/HomePage';
  final appId;

  const HomePage({Key? key, this.appId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var showSpinner = false;
  // bool _folded = true;
  // String? _userImage = "";
  // String? _theImage;
  // String? _userName = '';
  var _isLoggedIn = false;
  // var appId;
  // bool? checkConnectivity;
  DateTime? currentBackPressTime;
  // late double _currentLatitude;
  // late double _currentLongitude;
  // late double _shopLatitude;
  // late double _shopLongitude;

  @override
  void initState() {
    super.initState();
    geData();
    AppCubit()..getAllService();
    // getService();
  //   appId = widget.appId;
  //   _getImage();
  //   paymentSettingData();
  //   getLatlong();
  //   //category
  //   _getDataCategories();
  //   _getDataSpecialist();
  //   //specialist
  //   _getDataSpecial();
  //   //offer
  //   _getDataOffer();
  }
  var Data;
 geData()async{
    SharedPreferences localStorage=await SharedPreferences.getInstance();
    phone = localStorage.getString("phone");
    password = localStorage.getString("password");

    var body = {
      "phone_number":"$phone",
      "password":"$password",};

    HomeCubit()..getUserDate(body,context);
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
// List<serviceModel>? serModel=[];
//
//   Future<void>getService()async {
//
//     var res=await CallApi().get('services');
//     var body=json.decode(res.body);
//     print("ser ${body['data'][0]}");
//    body['data'].forEach((ele){
//      print("kkk");
//      serModel!.add(serviceModel.fromJson(ele));
//
//    });
//    //    print('BoDY $serModel');
//
//
//   }

  // Future<void> _getImage() async {
  //   // print('get image calling');
  //   check().then((internet) async {
  //     if (internet != null && internet) {
  //       // Internet Present Case
  //       SharedPreferences localStorage = await SharedPreferences.getInstance();
  //       var user = localStorage.getString('user');
  //       if (user != null) {
  //         setState(() {
  //           _isLoggedIn = true;
  //         });
  //       } else {
  //         _isLoggedIn = false;
  //       }
  //       setState(() {
  //         showSpinner = true;
  //       });
  //       var res = await CallApi().getWithToken('user');
  //       var body = json.decode(res.body);
  //       // print('the body response from homepage $body');
  //       var theData = body;
  //       if (theData != null) {
  //         _userName = theData['name'];
  //         _userImage = theData['completeImage'];
  //         // _theImage = _userImagePath + _userImage;
  //       }
  //       setState(() {
  //         showSpinner = false;
  //       });
  //     }
  //     // No-Internet Case
  //     else {
  //       showDialog(
  //         builder: (context) => AlertDialog(
  //           title: Text('Internet connection'),
  //           content: Text('Check your internet connection'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => HomePage(),
  //                     ));
  //               },
  //               child: Text('OK'),
  //             )
  //           ],
  //         ),
  //         context: context,
  //       );
  //     }
  //   });
  // }

  // Future<void> paymentSettingData() async {
  //   check().then((internet) async {
  //     if (internet != null && internet) {
  //       // Internet Present Case
  //       var res = await CallApi().getWithToken('payment_setting');
  //       var body = json.decode(res.body);
  //       var theData = body['data'];
  //       var stripePublishKey = theData['stripe_publish_key'];
  //       // print('stripe key$stripePublishKey');
  //       var stripeSecretKey = theData['stripe_secret_key'];
  //       SharedPreferences localStorage = await SharedPreferences.getInstance();
  //       localStorage.setString('stripePublishKey', stripePublishKey);
  //       localStorage.setString('stripeSecretKey', stripeSecretKey);
  //     } else {
  //       showDialog(
  //         builder: (context) => AlertDialog(
  //           title: Text('Internet connection'),
  //           content: Text('Check your internet connection'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => HomePage(),
  //                     ));
  //               },
  //               child: Text('OK'),
  //             )
  //           ],
  //         ),
  //         context: context,
  //       );
  //     }
  //     // No-Internet Case
  //   });
  // }

  Future<void> _getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    print("$user Baba");
    if (user != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    // _getImage();
  }

  // Future<void> getLatlong() async {
  //   setState(() {
  //     showSpinner = true;
  //   });
  //   var res = await CallApi().getWithToken('setting');
  //   var body = json.decode(res.body);
  //   var theData = body['data'];
  //   var apiLat = theData['latitude'];
  //   var apiLong = theData['longitude'];
  //   _shopLatitude = double.parse(apiLat.toString());
  //   _shopLongitude = double.parse(apiLong.toString());
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   var lat = position.latitude;
  //   var long = position.longitude;
  //   _currentLatitude = double.parse(lat.toString());
  //   _currentLongitude = double.parse(long.toString());
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   localStorage.setDouble('currentLatitude', _currentLatitude);
  //   localStorage.setDouble('currentLongitude', _currentLongitude);
  //   localStorage.setDouble('shopLatitude', _shopLatitude);
  //   localStorage.setDouble('shopLongitude', _shopLongitude);
  //   setState(() {
  //     showSpinner = false;
  //   });
  // }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit');
      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context)=>HomeCubit(),
    child: BlocConsumer<HomeCubit,HomeState>(
      listener: (context,state){},
      builder: (context,state){
        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: Row(
                children: [
                  SizedBox(
                    width: 13.0,
                  ),
                  Container(
                    margin: EdgeInsets.all(5.5),
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 1,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image(
                        image:  AssetImage(
                          'assets/icons/profile_picture.png'),

                        height: 30.0,
                        width: 30.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                "${info!.data!.user!.name}",
                // 'Justin Hayes',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FivoSansMedium',
                  fontSize: 18.0,
                ),
              ),
              actionsIconTheme: IconThemeData(color: Colors.white),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomDrawer(),
                          ));
                    },
                    icon: Icon(
                      FontAwesomeIcons.bars,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(

              // backgroundColor: Colors.green,
              color: Theme.of(context).primaryColor,
              onRefresh: _getData,
              child: SafeArea(
                top: true,
                bottom: true,
                left: false,
                right: false,
                child: ModalProgressHUD(
                  //handle it to true
                  inAsyncCall: false,
                  child: Stack(
                    children: [
                      ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          //welcome
                          GestureDetector(
                            onTap: () {
                              print('Mama');
                              FocusScopeNode currentFocus = FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                // Theme.of(context).primaryColor,
                                borderRadius: BorderRadiusDirectional.vertical(
                                  bottom: Radius.circular(40.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 18.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        '${model!.content!.welcomeMessage}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'FivoSansMedium',
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        'Shine Wash',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Nadillas',
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          theCategory(),
                          SizedBox(height: 20.0),
                          //specialist
                          specialist(),
                          SizedBox(height: 20.0),
                          //offer
                          offer(),
                          SizedBox(height: 10.0),
                          //category
                          // Category(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onWillPop: onWillPop,
        );
      },
    ),);
  }

  //category no data
  var passTheData;
  int? previousSpeId = 3;
  int? previousCatId = 1;
  var selectedSkills;
  var passId;
  List<CoworkerM> cw = <CoworkerM>[];

  List<Categories> ct = <Categories>[];
  Categories c = Categories();

  Future<void> _getDataSpecialist() async {
    var res = await CallApi().getWithToken('all_coworker');
    var body = json.decode(res.body);
    var theData = body['data'];
    cw = [];
    for (int i = 0; i < theData.length; i++) {
      Map<String, dynamic> map = theData[i];
      cw.add(CoworkerM.fromJson(map));
    }
    // specialistName = cw[0].name;
    passId = cw.first.id;
  }

  Future<Categories?> _getDataCategories() async {
    // print('hello');
    check().then((internet) async {
      if (internet != null && internet) {
        setState(() {
          showSpinner = true;
        });
        var res = await CallApi().getWithToken('category');
        var body = json.decode(res.body);
        var theData = body['data'];
        // print(theData);
        for (int i = 0; i < theData.length; i++) {
          Map<String, dynamic> map = theData[i];
          ct.add(Categories.fromJson(map));
        }
        setState(() {
          showSpinner = false;
        });
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
                        builder: (context) => HomePage(),
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

  // Future<void> getData(passTheData, index, categories) async {
  //   setState(() {
  //     showSpinner = true;
  //   });
  //   var res =
  //       await CallApi().postData(passTheData, 'category_wise_service_coworker');
  //   var body = json.decode(res.body);
  //   var theData = body['data'];
  //   selectedSkills = theData.length;
  //   if (selectedSkills != null) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => Services(
  //             index: index,
  //             categoryId: categories,
  //             selecetedSkill: selectedSkills,
  //             previuosSpeId: passId,
  //           ),
  //         ));
  //   }
  //   setState(() {
  //     showSpinner = false;
  //   });
  // }


  Widget  theCategory() {
var x=AppCubit.get(context).serModel;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      height: MediaQuery.of(context).size.height / 4.95,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${model!.content!.category}',
                style: TextStyle(
                  color: darkBlue,
                  fontFamily: 'FivoSansMedium',
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 6.2, //115.0
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:x!.length,
              itemBuilder: (context, index) {

                return GestureDetector(
                  onTap: () {
                    // previousCatId = ser.id;
                    // previousSpeId = passId;
                    // passTheData = {
                    //   "coworker_id": '$previousSpeId',
                    //   "category_id": '$previousCatId'
                    // };
                    // getData(passTheData, index, categories.id);
                    AppCubit.get(context).getOnlyService("${x[index].id}");

                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        height: MediaQuery.of(context).size.height / 11,
                        width: MediaQuery.of(context).size.width / 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.white,
                        ),
                        child: Image(
                          fit: BoxFit.scaleDown,
                          height: 28,
                          width: 27,
                          image:  NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiPOhjw8yIS79wuiRyDuCQ9_YSCMo2GbIUR8exBkgE-wpRGUzOnQzkDu8rIKDPsoAsNRs&usqp=CAU"),
                          // NetworkImage('${categories.image}'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        color: Colors.white,
                        child: Text(
                          "${x[index].title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkBlue,
                            fontSize: 16,
                            fontFamily: 'FivoSansRegular',
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  //specialist no data
  Future<void> _getDataSpecial() async {
    check().then((internet) async {
      if (internet != null && internet) {
        setState(() {
          showSpinner = true;
        });
        var res = await CallApi().getWithToken('all_coworker');
        var body = json.decode(res.body);
        var theData = body['data'];
        for (int i = 0; i < theData.length; i++) {
          Map<String, dynamic> map = theData[i];
          sp.add(CoworkerM.fromJson(map));
        }
        var servicename = {"service_name": ""};
        for (int j = 0; j < theData.length; j++) {
          if (theData[j]['service'].length > 0) {
            Map<String, dynamic> map = theData[j]['service'][0];
            sk.add(Skill.fromJson(map));
          } else {
            Map<String, dynamic> map = servicename;
            sk.add(Skill.fromJson(map));
          }
        }
        setState(() {
          showSpinner = false;
        });
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
                        builder: (context) => HomePage(),
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

  var passIdSpecialist;
  List<CoworkerM> sp = <CoworkerM>[];
  CoworkerM s = new CoworkerM();
  List<Skill> sk = <Skill>[];

  Widget  specialist(){
    return Container(
      height: MediaQuery.of(context).size.height / 3.1,
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${model!.content!.specialist}',
                  style: TextStyle(
                    color: darkBlue,
                    fontFamily: 'FivoSansMedium',
                    fontSize: 18,
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${model!.content!.viewAll}',
                      style: TextStyle(
                        color: darkBlue,
                        fontFamily: 'FivoSansMedium',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpecialistFull(),
                        ));
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.5),
            height: MediaQuery.of(context).size.height / 3.7, //185.0
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sp.length,
              itemBuilder: (context, index) {
                CoworkerM specialists = sp[index];
                Skill skill = sk[index];
                return GestureDetector(
                  onTap: () {
                    check().then((internet) {
                      if (internet != null && internet) {
                        // Internet Present Case
                        passIdSpecialist = sp[index].id;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeProfile(
                                      specialistId: passIdSpecialist,
                                    )));
                      }
                      // No-Internet Case
                      else {
                        showDialog(
                          builder: (context) => AlertDialog(
                            title: Text('Internet connection'),
                            content: Text('Check your internet connection'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
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
                  },
                  child: Container(
                    width: 112,
                    margin: EdgeInsets.all(10.0),
                    // color: Colors.yellow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            height: 100.0,
                            width: 100.0,
                            fit: BoxFit.cover,
                            image: NetworkImage('${specialists.image}'),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          specialists.name!,
                          style: TextStyle(
                            color: darkBlue,
                            fontFamily: 'FivoSansMedium',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 5.0),
                        //TODO:migration updated
                        Align(
                          alignment: Alignment.topLeft,
                          child: RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: specialists.rating!.toDouble(),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            // itemCount: specialists.rating!.toInt(),
                            itemCount: 5,
                            itemSize: 15,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: ratingStar,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: SmoothStarRating(
                        //     borderColor: ratingStar,
                        //     color: ratingStar,
                        //     size: 15,
                        //     defaultIconData: Icons.star_border,
                        //     rating: specialists.rating,
                        //     spacing: 1.0,
                        //     allowHalfRating: true,
                        //     isReadOnly: true,
                        //   ),
                        // ),
                        SizedBox(height: 5.0),
                        Text(
                          skill.name!,
                          style: TextStyle(
                            color: darkBlue,
                            fontSize: 12,
                            fontFamily: 'FivoSansMedium',
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //offerdata

  Future<void> _getDataOffer() async {
    check().then((internet) async {
      if (internet != null && internet) {
        // Internet Present Case
        setState(() {
          showSpinner = true;
        });
        var res = await CallApi().getWithToken('offer');
        var body = json.decode(res.body);
        var theData = body['data'];
        for (int i = 0; i < theData.length; i++) {
          Map<String, dynamic> map = theData[i];
          of.add(Offers.fromJson(map));
        }
        setState(() {
          showSpinner = false;
        });
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
                        builder: (context) => HomePage(),
                      ));
                },
                child: Text('OK'),
              )
            ],
          ),
          context: context,
        );
      }
      // No-Internet Case
    });
  }

  List<Offers> of = <Offers>[];
  Offers o = Offers();

  Widget  offer() {
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              '${model!.content!.offers}',
              style: TextStyle(
                color: darkBlue,
                fontFamily: 'FivoSansMedium',
                fontSize: 18,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 5.7, //133.0
            // color: Colors.red,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: of.length,
              itemBuilder: (context, index) {
                Offers offer = of[index];
                return Container(
                  // color: Colors.red,
                  height: 113,
                  width: 253,
                  // color: Colors.yellow,
                  margin: EdgeInsets.all(15.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          height: 113,
                          width: 253,
                          fit: BoxFit.fill,
                          image: NetworkImage(offer.image!),
                        ),
                      ),
                      Positioned(
                        top: 15.0,
                        right: 15.0,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          // color: Colors.yellow,
                          height: 68.0,
                          width: 100.0,
                          child: Text(
                            offer.description!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: darkBlue,
                              fontFamily: 'FivoSansMedium',
                              fontSize: 14.0,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
