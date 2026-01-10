import 'package:flutter/services.dart';

class NativeLocation {
  static const _channel = MethodChannel('native_location');

  static Future<Map<String, double>> getLocation() async {
    final result = await _channel.invokeMethod<Map>('getLocation');
    if (result == null) {
      throw Exception('Failed to get location');
    }
    return {
      'latitude': result['latitude'] as double,
      'longitude': result['longitude'] as double,
    };
  }
}
