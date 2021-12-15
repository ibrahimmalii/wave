import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../constants.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool showSpinner = false;

  double? _currentLatitude = 0.0;
  double? _currentLongitude = 0.0;
  double? _shopLatitude = 0.0;
  double? _shopLongitude = 0.0;

  //google map
  late LatLng _initialCameraPosition;
  late LatLng destinationPosition;
  double cameraZoom = 13;
  double cameraTilt = 0;
  double cameraBearing = 30;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polyLines = {};
  late GoogleMapController _controller;
  Location _location = Location();
  // this set will hold my markers
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _location.getLocation().then((value) {
      _currentLatitude = value.latitude;
      _currentLongitude = value.longitude;
    });
    _initialCameraPosition = LatLng(_currentLatitude!, _currentLongitude!);
    getLocationData();
  }

  @override
  void dispose() {
    // _controller?.finalize();
    super.dispose();
  }

  Future<void> getLocationData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    _currentLatitude = localStorage.getDouble('currentLatitude');
    _currentLongitude = localStorage.getDouble('currentLongitude');
    _shopLatitude = localStorage.getDouble('shopLatitude');
    _shopLongitude = localStorage.getDouble('shopLongitude');
    _initialCameraPosition = LatLng(_currentLatitude!, _currentLongitude!);
    destinationPosition = LatLng(_shopLatitude!, _shopLongitude!);
    _createPolylines(
        _currentLatitude!, _currentLongitude!, _shopLatitude!, _shopLongitude!);
    // source pin
    _markers.add(Marker(
        markerId: MarkerId("sourcePin"),
        position: _initialCameraPosition,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId("destPin"),
        position: destinationPosition,
        icon: BitmapDescriptor.defaultMarker));
    print(
        'this is the value $_currentLatitude ,$_currentLongitude ,$_shopLatitude ,$_shopLongitude');
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    // Initializing PolylinePoints
    PolylinePoints polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.androidKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black87,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polyLines[id] = polyline;
    setState(() {});
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 13),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'FivoSansMedium',
          ),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialCameraPosition),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            // markers: _createMarker(),
            // markers: _markers,
            markers: _markers,
            // markers: Set<Marker>.of(_markers),
            polylines: Set<Polyline>.of(polyLines.values),
          ),
        ),
      ),
    );
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
}
