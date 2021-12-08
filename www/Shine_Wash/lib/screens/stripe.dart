import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Shinewash/api/api.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'appointment.dart';

class PaymentStripe extends StatefulWidget {
  final String? cardNumber;
  final String? expDate;
  final String? cvv;
  final String? cardHolderName;
  final int? paymentTokenKnow;
  final int? paymentStatus;
  final String? patmentType;
  final int? selectedIndex;
  final bool? addressShop;
  final bool? addressHome;
  final String? addressHomeText;

  const PaymentStripe({
    Key? key,
    this.paymentTokenKnow,
    this.paymentStatus,
    this.patmentType,
    this.cardNumber,
    this.expDate,
    this.cvv,
    this.cardHolderName,
    this.selectedIndex,
    this.addressShop,
    this.addressHomeText,
    this.addressHome,
  }) : super(key: key);

  @override
  _PaymentStripeState createState() => _PaymentStripeState();
}

class _PaymentStripeState extends State<PaymentStripe> {
  //change
  Token? _paymentToken;
  //change
  PaymentMethod? _paymentMethod;
  String? _error;
  String? _currentSecret; //set this yourself, e.g using curl
  //change
  PaymentIntentResult? _paymentIntent;
  //change
  Source? _source;
  String? stripePublicKey;
  String? stripeSecretKey;
  String? stripeToken;
  int? paymentTokenKnow;
  int? paymentStatus;
  String? paymentType;
  ScrollController _controller = ScrollController();
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool showSpinner = false;
  int? selectedIndex;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var totalPayableAmount;
  var totalDiscount;
  bool? addressShop;
  bool? addressHome;
  bool? addressView;
  String? addressHomeText;
  List<int> serviceIdList = <int>[];
  var coworkerId;
  var timeSlot;
  var date;
  var offerId;
  String serviceType = '';
  var lat;
  var long;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // CardFieldInputDetails? _card;

  @override
  initState() {
    super.initState();
    getStripePublishKey();
    paymentTokenKnow = widget.paymentTokenKnow;
    paymentStatus = widget.paymentStatus;
    paymentType = widget.patmentType;
    selectedIndex = widget.selectedIndex;
    addressShop = widget.addressShop;
    addressHome = widget.addressHome;
    addressHomeText = widget.addressHomeText;
    _totalPayableAmount();
    getLocation();
  }

  Future<void> getStripePublishKey() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    stripeSecretKey = localStorage.get('stripeSecretKey') as String?;
    stripePublicKey = localStorage.get('stripePublishKey') as String?;
    //change
    StripePayment.setOptions(StripeOptions(
        publishableKey: "$stripePublicKey",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
    // showDialog(
    //   builder: (context) => AlertDialog(
    //     title: Text('Payment Error'),
    //     content: Text('something went wrong'),
    //     actions: <Widget>[
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         child: Text('Ok'),
    //       )
    //     ],
    //   ),
    //   context: context,
    // );
    setState(() {
      _error = error.toString();
    });
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  _totalPayableAmount() async {
    setState(() {
      showSpinner = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    totalPayableAmount = localStorage.getString('totalPayableAmount');
    totalDiscount = localStorage.getString('totalDiscount');
    coworkerId = localStorage.getString('coworkerId');
    timeSlot = localStorage.getString('timeSlot');
    date = localStorage.getString('date');
    totalDiscount = localStorage.getString('totalDiscount');
    offerId = localStorage.getString('offer_id');
    setState(() {
      showSpinner = false;
    });
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

  Future<void> bookingAppointment(data) async {
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
      if (body['success'] == true) {
        setState(() {
          showSpinner = false;
        });
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('addValue');
        Timer(Duration(seconds: 2), () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(
          'Stripe Payment',
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.vertical,
            controller: _controller,
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              SingleChildScrollView(
                child: CreditCardForm(
                  formKey: formKey,
                  onCreditCardModelChange: onCreditCardModelChange,
                  //     cardNumber = creditCardModel.cardNumber;
                  //       expiryDate = creditCardModel.expiryDate;
                  //       cardHolderName = creditCardModel.cardHolderName;
                  //       cvvCode = creditCardModel.cvvCode;
                  //       isCvvFocused = creditCardModel.isCvvFocused;
                  cardHolderName: cardHolderName,
                  cardNumber: cardNumber,
                  cvvCode: cvvCode,
                  expiryDate: expiryDate,
                  themeColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            ],
          ),
        ),
      ),
      // click to next
      bottomNavigationBar: Container(
        // height: MediaQuery.of(context).size.height * 0.06,
        // width: MediaQuery.of(context).size.width,
        // margin: EdgeInsets.all(10.0),
        color: Theme.of(context).primaryColor,
        child: TextButton(
          onPressed: () {
            setState(() {
              showSpinner = true;
            });
            var expMonth = expiryDate.split('/')[0];
            var expYear = expiryDate.split('/')[1];
            int finalExpMonth = int.parse(expMonth.toString());
            int finalExpYear = int.parse(expYear.toString());

            StripePayment.createTokenWithCard(
              CreditCard(
                number: '$cardNumber',
                expMonth: finalExpMonth,
                expYear: finalExpYear,
                cvc: '$cvvCode',
                name: '$cardHolderName',
              ),
            ).then((token) async {
              // _scaffoldKey.currentState.showSnackBar(
              //     // SnackBar(content: Text('Received ${token.tokenId}')));
              //     SnackBar(content: Text('Payment Completed')));
              stripeToken = token.tokenId;
              //---------
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
              setState(() {
                addressShop == true ? addressView = false : addressView = true;
              });
              if (addressView == false) {
                passAddress = 'SHOP';
                serviceType = 'SHOP';
              } else {
                serviceType = 'HOME';
                passAddress = addressHomeText.toString();
              }
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
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
              Map<String, dynamic> body;
              addressView == true
                  ? body = {
                      'service_id': serviceIdList,
                      'coworker_id': coworkerId,
                      'start_time': timeSlot,
                      'discount': totalDiscountINT,
                      'coupen_id': offerId,
                      'date': date,
                      'payment_type': paymentType,
                      'payment_token': stripeToken,
                      'amount': totalPayableINT,
                      'payment_status': '1',
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
                      'payment_token': stripeToken,
                      'amount': totalPayableINT,
                      'payment_status': '1',
                      'service_type': serviceType,
                    };
              print(body);
              bookingAppointment(body);
            }).catchError(setError);

            setState(() {
              showSpinner = false;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'FivoSansMedium',
            ),
          ),
        ),
      ),
    );
  }
}
