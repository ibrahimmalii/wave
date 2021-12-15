import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:Shinewash/screens/webview_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shinewash/api/api.dart';
import 'package:Shinewash/screens/custom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:Shinewash/screens/stripe.dart';

const darkBlue = Color(0xFF265E9E);
const extraDarkBlue = Color(0xFF91B4D8);
const containerShadow = Color(0xFF91B4D8);

enum CardType { visa }

enum Service { shop, home }

class Payment extends StatefulWidget {
  final String? stripeToken;
  final int? paymentTokenKnow;
  final int? paymentStatus;
  final String? paymentType;
  final int? selectedIndex;
  // final List<AddValues> addValue;
  const Payment({
    Key? key,
    this.stripeToken,
    this.paymentTokenKnow,
    this.paymentStatus,
    this.paymentType,
    this.selectedIndex,
    // this.addValue,
  }) : super(key: key);
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  CardType _cardType = CardType.visa;
  int? _selected;
  var totalPayableAmount;
  var showSpinner = false;
  var cod;
  var stripe;
  var paypal;
  var razorpay;
  var flutterwave;
  var flutterwaveSelected = false;
  var paystack;
  var paystackToken;
  var paystackPublicKey;
  var flutterwavePublicKey;
  var razorpayAmount;
  var serviceId;
  List<int> serviceIdList = <int>[];
  var coworkerId;
  var timeSlot;
  var date;
  var paymentType;
  var prefillMobileNumber;
  var prefillEmailId;
  var paymentToken;
  int? paymentTokenPassKnow;
  int? paymentTokenKnow;
  var razorpayToken;
  Map<String, dynamic>? body;
  var paymentStatus;
  var serviceType = 'SHOP';
  var lat;
  var long;
  var totalDiscount;
  bool addressView = false;
  bool addressNotView = true;
  var offerId;
  String? razorpayKey = '';
  String? stripeToken = '';
  int? stripePaymentStatus;
  String? stripePaymentType;
  int? previousSelectedIndex;
  var currencyIs;
  // List<AddValues> _addValue;
  var logger = Logger();
  bool paymentMethodSelected = false;
  bool stripeAddressShop = true;
  bool stripeAddressHome = false;
  final snackBar = SnackBar(content: Text('Please select the Service place'));
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _addressController = TextEditingController();

  Service? _service = Service.shop;

  late Razorpay _razorpay;
  final payStackPlugin = PaystackPlugin();

  @override
  void initState() {
    stripeToken = widget.stripeToken;
    paymentTokenKnow = widget.paymentTokenKnow;
    stripePaymentStatus = widget.paymentStatus;
    stripePaymentType = widget.paymentType;
    previousSelectedIndex = widget.selectedIndex;
    previousSelectedIndex == null
        ? _selected = _selected
        : setState(() {
            _selected = previousSelectedIndex;
          });
    _totalPayableAmount();
    _paymentMethodSelection();
    getLocation();
    prefillInfo();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('latitude', lat.toString());
    localStorage.setString('longitude', long.toString());
  }

  Future<void> prefillInfo() async {
    setState(() {
      showSpinner = true;
    });
    var res = await CallApi().getWithToken('user');
    var body = json.decode(res.body);
    var theData = body;
    prefillMobileNumber = theData['phone'];
    prefillEmailId = theData['email'];
    var res2 = await CallApi().getWithToken('payment_setting');
    var body2 = json.decode(res2.body);
    var theData2 = body2['data'];
    razorpayKey = theData2['razorpay_key'];
    paystackPublicKey = theData2['paystack_public_key'];
    flutterwavePublicKey = theData2['flutterwave_public_key'];
    var res3 = await CallApi().getWithToken('setting');
    var body3 = json.decode(res3.body);
    var theData3 = body3['data'];
    currencyIs = theData3['currency'];
    // PaystackPlugin.initialize(publicKey: paystackPublicKey);
    payStackPlugin.initialize(publicKey: paystackPublicKey);
    setState(() {
      showSpinner = false;
    });
  }

  void razorpayMethod() async {
    double convertToDouble = double.parse(totalPayableAmount.toString());
    razorpayAmount = convertToDouble * 100;
    var options = {
      'key': '$razorpayKey',
      'amount': razorpayAmount,
      'name': 'Shinewash',
      'prefill': {'contact': prefillMobileNumber, 'email': prefillEmailId},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    razorpayToken = response.paymentId;
    paymentToken = razorpayToken;
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId!,
      timeInSecForIosWeb: 4,
    );
    paymentFunction().whenComplete(
      () {
        print('the payment body is $body');
        return bookingAppointment(body);
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, timeInSecForIosWeb: 4);
  }

  _totalPayableAmount() async {
    setState(() {
      showSpinner = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    totalPayableAmount = localStorage.getString('totalPayableAmount');
    serviceId = localStorage.getInt('serviceId');
    coworkerId = localStorage.getString('coworkerId');
    timeSlot = localStorage.getString('timeSlot');
    date = localStorage.getString('date');
    totalDiscount = localStorage.getString('totalDiscount');
    offerId = localStorage.getString('offer_id');
    setState(() {
      showSpinner = false;
    });
  }

  Future bookingAppointment(data) async {
    setState(() {
      showSpinner = true;
    });
    try {
      // print('data is $data');
      // logger.d(data);
      var res = await CallApi().postDataWithToken(data, 'book_appoinment');
      // print(res.body);
      var body = json.decode(res.body);
      print('body is $body');
      // var theData = body['data'];
      if (flutterwaveSelected == true) {
        var _url = body['url'];
        setState(() {
          showSpinner = false;
        });
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WebviewScreen(
                url: _url,
              ),
            ));
      } else {
        if (body['success'] == true) {
          setState(() {
            showSpinner = false;
          });
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.remove('addValue');
          Timer(Duration(seconds: 3), () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/HomePage', (route) => false);
          });
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 20,
                  fontFamily: 'PoppinsMedium',
                ),
              ),
              content: Wrap(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/payment_success.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text(
                        'Booking Confirmed',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 25,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, '/HomePage', (route) => false);
                  },
                  style: TextButton.styleFrom(alignment: Alignment.center),
                  child: Text(
                    'Thank You',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          );
          //TODO:migration updated
          // showDialog(
          //   context: context,
          //   builder: (_) => AssetGiffyDialog(
          //     onlyOkButton: true,
          //     image: Image(
          //       image: AssetImage(
          //         'assets/images/payment_success.png',
          //       ),
          //       fit: BoxFit.fill,
          //     ),
          //     title: Text(
          //       'Payment Successful',
          //       style: TextStyle(
          //         color: darkBlue,
          //         fontSize: 20,
          //         fontFamily: 'PoppinsMedium',
          //       ),
          //     ),
          //     description: Text(
          //       'Booking Confirmed',
          //       style: TextStyle(
          //         color: darkBlue,
          //         fontSize: 25,
          //         fontFamily: 'PoppinsMedium',
          //       ),
          //     ),
          //     entryAnimation: EntryAnimation.TOP_LEFT,
          //     buttonOkColor: Colors.green[400],
          //     onOkButtonPressed: () {
          //       Navigator.pushNamedAndRemoveUntil(
          //           context, '/HomePage', (route) => false);
          //     },
          //   ),
          // );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Payment Fail'),
              content: Text('Invalid currency'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Try Again'),
                )
              ],
            ),
          );
        }
      }
    } catch (e) {
      showDialog(
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
//                Navigator.popAndPushNamed(context, Login.route);
                Navigator.pop(context);
              },
              child: Text('Try Again'),
            )
          ],
        ),
        context: context,
      );
    }
    setState(() {
      showSpinner = false;
    });
  }

  Future<void> _paymentMethodSelection() async {
    setState(() {
      showSpinner = true;
    });
    var res = await CallApi().getWithToken('payment_setting');
    var body = json.decode(res.body);
    var theData = body['data'];
    cod = theData['id'];
    stripe = theData['stripe'];
    paypal = theData['paypal'];
    razorpay = theData['razorpay'];
    flutterwave = theData['flutterwave'];
    paystack = theData['paystack'];
    setState(() {
      showSpinner = false;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('isFrom');
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }

  //paystack
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  paystackFunction() async {
    int convertAmount = int.parse(totalPayableAmount.split(".")[0].toString());
    int amountToPaystack = convertAmount * 100;
    Charge charge = Charge()
      ..amount = amountToPaystack
      ..reference = _getReference()
      //TODO:implement real data
      ..currency = currencyIs.toString()
      // ..currency = 'ZAR'
//..accessCode = _createAcessCode(skTest, _getReference())
//     Card : 408 408 408 408 408 1
//     EXPIRY : 03/22
//     CVV : 408
      ..email = prefillEmailId;
    CheckoutResponse response = await payStackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      setState(() {
        paymentToken = response.reference;
      });
      paymentFunction().whenComplete(
        () {
          print('the payment body is $body');
          return bookingAppointment(body);
        },
      );
      print('success');
      print(response.reference);
    } else {
      print('error');
    }
  }

  Future<void> paymentFunction() async {
    var totalDiscountINT;
    if (totalDiscount != 'null') {
      var a = double.parse(totalDiscount);
      totalDiscountINT = a.toInt();
    } else {
      totalDiscountINT = 0;
    }
    var b = double.parse(totalPayableAmount.toString());
    var totalPayableINT = b.toInt();
    var passAddress = '';
    if (addressView == false) {
      passAddress = 'SHOP';
    } else {
      passAddress = _addressController.text;
    }
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    int addvaluelength = localStorage.getInt('addValueLength')!;
    List<String> lsModelserviceid = [];
    List<int> lsModelserviceidConverted = [];
    lsModelserviceid =
        (localStorage.getStringList('modelServiceId') ?? <String>[]);
    var convertmodelserviceid;
    for (int a = 0; a < addvaluelength; a++) {
      convertmodelserviceid = int.parse(lsModelserviceid[a]);
      lsModelserviceidConverted.add(convertmodelserviceid);
    }
    serviceIdList.clear();
    for (int i = 0; i < addvaluelength; i++) {
      serviceIdList.add(lsModelserviceidConverted[i]);
    }
    addressView == true
        ? body = {
            'service_id': serviceIdList,
            'coworker_id': coworkerId,
            'start_time': timeSlot,
            'discount': totalDiscountINT,
            'coupen_id': offerId,
            'date': date,
            'payment_type': paymentType,
            'payment_token': paymentToken,
            'amount': totalPayableINT,
            'payment_status': paymentStatus.toString(),
            'service_type': serviceType,
            'lat': lat.toString(),
            'lang': long.toString(),
            'address': passAddress,
          }
        : body = {
            'service_id': serviceIdList,
            'coworker_id': coworkerId,
            'start_time': timeSlot,
            'discount': totalDiscountINT,
            'coupen_id': offerId,
            'date': date,
            'payment_type': paymentType,
            'payment_token': paymentToken,
            'amount': totalPayableINT,
            'payment_status': paymentStatus.toString(),
            'service_type': serviceType,
          };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 24,
            color: darkBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Payment',
          style: TextStyle(
            color: darkBlue,
            fontSize: 18.0,
            fontFamily: 'FivoSansMedium',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.bars,
              size: 22,
              color: darkBlue,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomDrawer(),
                  ));
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: [
              ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          'Total Payable',
                          style: TextStyle(
                            color: darkBlue,
                            fontSize: 18.0,
                            fontFamily: 'FivoSansMedium',
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '\$$totalPayableAmount',
                          style: TextStyle(
                            color: darkBlue,
                            fontSize: 30.0,
                            fontFamily: 'FivoSansMedium',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Divider(
                    color: extraDarkBlue.withOpacity(0.3),
                    height: 5.0,
                    thickness: 3.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Where Would you like to service at?',
                                style: TextStyle(
                                  color: darkBlue,
                                  fontSize: 18.0,
                                  fontFamily: 'FivoSansMedium',
                                ),
                              ),
                              RadioListTile<Service>(
                                  value: Service.shop,
                                  groupValue: _service,
                                  activeColor: Theme.of(context).primaryColor,
                                  title: Text(
                                    'Shop',
                                    style: TextStyle(
                                      color: darkBlue,
                                      fontSize: 15.0,
                                      fontFamily: 'FivoSansMedium',
                                    ),
                                  ),
                                  onChanged: (Service? val) {
                                    setState(() {
                                      stripeAddressShop = true;
                                      stripeAddressHome = false;
                                      _service = val;
                                      serviceType = "SHOP";
                                      addressView = false;
                                      addressNotView = true;
                                    });
                                  }),
                              RadioListTile<Service>(
                                  value: Service.home,
                                  groupValue: _service,
                                  activeColor: Theme.of(context).primaryColor,
                                  title: Text(
                                    'Home',
                                    style: TextStyle(
                                      color: darkBlue,
                                      fontSize: 15.0,
                                      fontFamily: 'FivoSansMedium',
                                    ),
                                  ),
                                  onChanged: (Service? val) {
                                    setState(() {
                                      stripeAddressHome = true;
                                      stripeAddressShop = false;
                                      _service = val;
                                      serviceType = "HOME";
                                      addressView = true;
                                      addressNotView = false;
                                    });
                                  })
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Visibility(
                          visible: addressView,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your address Please...',
                                  style: TextStyle(
                                    color: darkBlue,
                                    fontSize: 18.0,
                                    fontFamily: 'FivoSansMedium',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                  child: TextField(
                                    controller: _addressController,
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: InputBorder.none,
                                      hintText: 'Type your address here',
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
                                SizedBox(height: 30.0),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: addressNotView,
                          child: Container(
                            height: 1,
                            width: 1,
                          ),
                        ),
                        // SizedBox(height: 30.0),
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            color: darkBlue,
                            fontSize: 18.0,
                            fontFamily: 'FivoSansMedium',
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //razorpay
                            Expanded(
                              child: ElevatedButton(
                                onPressed: razorpay == 1
                                    ? () {
                                        paymentTokenKnow = 1;
                                        paymentTokenPassKnow = 1;
                                        setState(() {
                                          paymentMethodSelected = true;
                                          _selected = 0;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: _selected == 0
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  child: Text(
                                    'Razorpay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'FivoSansMedium',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            //stripe
                            Expanded(
                              child: ElevatedButton(
                                onPressed: stripe == 1
                                    ? () {
                                        if (stripeAddressHome == true ||
                                            stripeAddressShop == true) {
                                          if (stripeAddressHome == true) {
                                            setState(() {
                                              _selected = 2;
                                              paymentMethodSelected = true;
                                            });
                                            paymentTokenKnow = 2;
                                            paymentTokenPassKnow = 2;
                                            paymentStatus = 1;
                                            paymentType = 'Stripe';
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentStripe(
                                                    // amount: totalPayableAmount,
                                                    paymentTokenKnow:
                                                        paymentTokenPassKnow,
                                                    paymentStatus:
                                                        paymentStatus,
                                                    patmentType: paymentType,
                                                    selectedIndex: _selected,
                                                    addressHome:
                                                        stripeAddressHome,
                                                    addressHomeText:
                                                        _addressController.text,
                                                  ),
                                                ));
                                          } else if (stripeAddressShop ==
                                              true) {
                                            setState(() {
                                              _selected = 2;
                                              paymentMethodSelected = true;
                                            });
                                            paymentTokenKnow = 2;
                                            paymentTokenPassKnow = 2;
                                            paymentStatus = 1;
                                            paymentType = 'Stripe';
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentStripe(
                                                    // amount: totalPayableAmount,
                                                    paymentTokenKnow:
                                                        paymentTokenPassKnow,
                                                    paymentStatus:
                                                        paymentStatus,
                                                    patmentType: paymentType,
                                                    selectedIndex: _selected,
                                                    addressShop:
                                                        stripeAddressShop,
                                                  ),
                                                ));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Please select the Service place')));
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: _selected == 2
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Stripe',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'FivoSansMedium',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            //cod
                            Expanded(
                              child: ElevatedButton(
                                onPressed: cod == 1
                                    ? () {
                                        paymentTokenKnow = 3;
                                        setState(() {
                                          _selected = 3;
                                          paymentMethodSelected = true;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: _selected == 3
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'COD',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'FivoSansMedium',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //flutterwave
                            Expanded(
                              child: ElevatedButton(
                                onPressed: flutterwave == 1
                                    ? () {
                                        paymentTokenKnow = 4;
                                        setState(() {
                                          _selected = 4;
                                          paymentMethodSelected = true;
                                          flutterwaveSelected = true;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: _selected == 4
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  child: Text(
                                    'Flutterwave',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'FivoSansMedium',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            //paystack
                            Expanded(
                              child: ElevatedButton(
                                onPressed: paystack == 1
                                    ? () {
                                        paymentTokenKnow = 5;
                                        setState(() {
                                          paymentMethodSelected = true;
                                          _selected = 5;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: _selected == 5
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Paystack',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'FivoSansMedium',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            //blank space
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
              Positioned(
                bottom: 0.01,
                child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (paymentMethodSelected == true) {
                        if (paymentTokenKnow == 1) {
                          paymentStatus = 1;
                          paymentType = 'Razor';
                          razorpayMethod();
                          prefillInfo();
                        } else if (paymentTokenKnow == 2) {
                          paymentToken = stripeToken;
                          paymentStatus = 1;
                          paymentType = 'Stripe';
                        } else if (paymentTokenKnow == 3) {
                          paymentStatus = 0;
                          paymentType = 'COD';
                          paymentFunction().whenComplete(
                            () {
                              print('the payment body is $body');
                              return bookingAppointment(body);
                            },
                          );
                        } else if (paymentTokenKnow == 4) {
                          paymentStatus = 0;
                          paymentType = 'FLUTTERWAVE';
                          paymentFunction().whenComplete(
                            () {
                              print('the payment body is $body');
                              return bookingAppointment(body);
                            },
                          );
                        } else if (paymentTokenKnow == 5) {
                          paystackFunction();
                          paymentToken = paystackToken;
                          paymentStatus = 1;
                          paymentType = 'PAYSTACK';
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Payment Selection'),
                            content: Text('Please select one Payment method'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Try Again'),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      'Complete Booking',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'FivoSansMedium',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
