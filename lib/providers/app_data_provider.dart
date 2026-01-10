import 'dart:convert';
//import 'package:geolocator/geolocator.dart';
import 'package:earthquake_app/models/earthquake_models.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
//import 'package:geocoding/geocoding.dart' as gc;
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:earthquake_app/platform/location_channel.dart';
//import 'package:location/location.dart';

enum InternetStatus {
  loading,
  connected,
  disconnected,
}

class AppDataProvider with ChangeNotifier{
  final baseurl = Uri.parse('https://earthquake.usgs.gov/fdsnws/event/1/query');
  Map<String, dynamic> queryParams = {};
  InternetStatus internetStatus = InternetStatus.loading;
  late double _maxRadiusKM;
  double _latitude = 0.0, _longitude = 0.0;
  String _startTime = '' , _endTime = '';
  String _orderBy = 'time';
  String? _currentCity;
  final double _maxRadiusKmThreshold = 20001.6;
  bool _shouldUseLocation = false;
  EarthquakeModels? earthquakeModels;
  //final Location _location = Location();

  double get maxRadiusKM => _maxRadiusKM;

  double get latitude => _latitude;

  get longitude => _longitude;

  String get startTime => _startTime;

  get endTime => _endTime;

  String get orderBy => _orderBy;

  //String? get currentCity => _currentCity;

  double get maxRadiusKmThreshold => _maxRadiusKmThreshold;

  bool get shouldUseLocation => _shouldUseLocation;

  bool get hasDataLoaded => earthquakeModels != null;

  // init() {
  //   _startTime = getFormatedDateTime(DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch);
  //   _endTime = getFormatedDateTime(DateTime.now().millisecondsSinceEpoch);
  //   _maxRadiusikm = maxRadiusKmThreshold;
  //   _setQueryParams();
  //   getEarthQuakeData();
  // }

  Future<void> init() async {
    internetStatus = InternetStatus.loading;
    notifyListeners();

    // final connectivityResult =
    // await Connectivity().checkConnectivity();
    //
    // if (connectivityResult == ConnectivityResult.none) {
    //   internetStatus = InternetStatus.disconnected;
    //   notifyListeners();
    //   return;
    // }

    // internetStatus = InternetStatus.connected;

    _startTime = getFormatedDateTime(
      DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
    );
    _endTime = getFormatedDateTime(
      DateTime.now().millisecondsSinceEpoch,
    );
    _maxRadiusKM = maxRadiusKmThreshold;

    _setQueryParams();
    await getEarthQuakeData();
  }

  _setQueryParams() {
    queryParams['format'] = 'geojson';
    queryParams['starttime'] = _startTime;
    queryParams['endtime'] = _endTime;
    queryParams['minmagnitude'] = '4';
    queryParams['orderby'] = _orderBy;
    queryParams['limit'] = '500';
    queryParams['latitude'] = '$_latitude';
    queryParams['longitude'] = '$_longitude';
    queryParams['maxradiuskm'] = '$_maxRadiusKM';
  }


  Color getAlertColor(String color) {
    return switch(color) {
      'green' => Colors.green,
      'yellow' => Colors.yellow,
      'orange' => Colors.orange,
      _ => Colors.red,
    };
  }

  // Future<void> getEarthQuakeData() async{
  //   final uri = Uri.https(baseurl.authority, baseurl.path, queryParams);
  //   try{
  //     final response = await http.get(uri);
  //     if(response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       earthquakeModels = EarthquakeModels.fromJson(json);
  //       print(earthquakeModels!.features!.length);
  //       notifyListeners();
  //     }
  //   }
  //   catch(error){
  //     print(error.toString());
  //   }
  // }

  Future<void> getEarthQuakeData() async {
    try {
      final uri = Uri.https(
        baseurl.authority,
        baseurl.path,
        queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        earthquakeModels = EarthquakeModels.fromJson(json);
        notifyListeners();
      }
    } catch (error) {
      internetStatus = InternetStatus.disconnected;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    earthquakeModels = null;
    await init();
  }

  void setOrder(String value) {
    _orderBy = value;
    notifyListeners();
    _setQueryParams();
    getEarthQuakeData();
  }


  void setStartTime(String date) {
    _startTime = date;
    _setQueryParams();
    notifyListeners();
  }

  void setEndTime(String date) {
    _endTime = date;
    _setQueryParams();
    notifyListeners();
  }



  Future<void> setLocation(bool value) async {
    _shouldUseLocation = value;

    if (value) {
      final loc = await NativeLocation.getLocation();
      _latitude = loc['latitude']!;
      _longitude = loc['longitude']!;
      _maxRadiusKM = 500;
    } else {
      _latitude = 0.0;
      _longitude = 0.0;
      _maxRadiusKM = _maxRadiusKmThreshold;
    }

    _setQueryParams();
    await getEarthQuakeData();
    notifyListeners();
  }


  // Future<void> setLocation(bool value) async {
  //   _shouldUseLocation = value;
  //
  //   if (value) {
  //     final locationData = await _getLocation();
  //     _latitude = locationData.latitude ?? 0.0;
  //     _longitude = locationData.longitude ?? 0.0;
  //
  //     _maxRadiusKM = 500;
  //   } else {
  //     _latitude = 0.0;
  //     _longitude = 0.0;
  //     //_currentCity = null;
  //     _maxRadiusKM = _maxRadiusKmThreshold;
  //   }
  //
  //   _setQueryParams();
  //   await getEarthQuakeData();
  //
  //   notifyListeners();
  // }


  // Future<void> setLocation(bool value) async{
  //   _shouldUseLocation = value;
  //   notifyListeners();
  //   if(value) {
  //     final position = await _determinePosition();
  //     _latitude = position.latitude;
  //     _longitude = position.longitude;
  //     await _getCurrentCity();
  //     _maxRadiusikm = 500;
  //     _setQueryParams();
  //     getEarthQuakeData();
  //   }
  //   else{
  //     _latitude = 0.0;
  //     _longitude = 0.0;
  //     _maxRadiusikm = _maxRadiusKmThreshold;
  //     _currentCity = null;
  //     _setQueryParams();
  //     getEarthQuakeData();
  //   }
  // }

  // Future<LocationData> _getLocation() async {
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //
  //   serviceEnabled = await _location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await _location.requestService();
  //     if (!serviceEnabled) {
  //       throw Exception('Location services are disabled.');
  //     }
  //   }
  //
  //   permissionGranted = await _location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await _location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       throw Exception('Location permission denied.');
  //     }
  //   }
  //
  //   return await _location.getLocation();
  // }

  // Future<void> _getCurrentCity() async {
  //   try {
  //     final uri = Uri.parse(
  //       'https://nominatim.openstreetmap.org/reverse'
  //           '?format=json'
  //           '&lat=$_latitude'
  //           '&lon=$_longitude'
  //           '&zoom=10'
  //           '&addressdetails=1',
  //     );
  //
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         'User-Agent': 'QuakeTrace (contact: aditya@example.com)',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final address = data['address'];
  //
  //       _currentCity =
  //           address['city'] ??
  //               address['town'] ??
  //               address['village'] ??
  //               address['state'];
  //
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     debugPrint('Reverse geocoding failed: $e');
  //   }
  // }

  // Future<void> _getCurrentCity() async{
  //   try{
  //     final placemarkList = await gc.placemarkFromCoordinates(_latitude, _longitude);
  //     if(placemarkList.isNotEmpty) {
  //       final placemark = placemarkList.first;
  //       _currentCity = placemark.locality;
  //       notifyListeners();
  //     }
  //   }
  //   catch(error){
  //     print(error);
  //   }
  // }



  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }
}






