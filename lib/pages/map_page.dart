/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:provider/provider.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/models/earthquake_models.dart' as models;
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _userLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError(
            'Location services are disabled. Please enable location services in your device settings.');
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError(
              'Location permission denied. Please grant location permission in app settings.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError(
            'Location permissions are permanently denied. Please enable location access in app settings.');
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      // Move map to user location
      _mapController.move(_userLocation!, 10.0);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error getting location: $e');
      _showLocationError(
          'Failed to get location. Please check your internet connection and try again.');
    }
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Settings',
          textColor: Colors.white,
          onPressed: () {
            // You can add navigation to app settings here if needed
          },
        ),
      ),
    );
  }

  List<Marker> _buildEarthquakeMarkers(
      models.EarthquakeModels? earthquakeData) {
    if (earthquakeData?.features == null) return [];

    return earthquakeData!.features!
        .map((feature) {
          final properties = feature.properties;
          if (properties == null || feature.geometry?.coordinates == null)
            return null;

          final coordinates = feature.geometry!.coordinates!;
          if (coordinates.length < 2) return null;

          final lat = coordinates[1].toDouble();
          final lng = coordinates[0].toDouble();

          return Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () {
                _showEarthquakeDetails(properties);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _getMagnitudeColor(properties.mag ?? 0),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${properties.mag?.toStringAsFixed(1) ?? "N/A"}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          );
        })
        .where((marker) => marker != null)
        .cast<Marker>()
        .toList();
  }

  Color _getMagnitudeColor(num magnitude) {
    if (magnitude >= 7.0) return Colors.red;
    if (magnitude >= 6.0) return Colors.orange;
    if (magnitude >= 5.0) return Colors.yellow;
    if (magnitude >= 4.0) return Colors.green;
    return Colors.blue;
  }

  void _showEarthquakeDetails(models.Properties properties) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Earthquake Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${properties.place ?? "Unknown"}'),
            SizedBox(height: 8),
            Text('Magnitude: ${properties.mag?.toStringAsFixed(1) ?? "N/A"}'),
            SizedBox(height: 8),
            Text(
                'Time: ${properties.time != null ? DateTime.fromMillisecondsSinceEpoch(properties.time!.toInt()).toString() : "Unknown"}'),
            if (properties.alert != null) ...[
              SizedBox(height: 8),
              Text('Alert: ${properties.alert}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake Map'),
        actions: [
          IconButton(
            onPressed: _getUserLocation,
            icon: Icon(Icons.my_location),
            tooltip: 'Go to my location',
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          final markers = _buildEarthquakeMarkers(provider.earthquakeModels);

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation ?? LatLng(0, 0),
              initialZoom: 5.0,
              onMapReady: () {
                if (_userLocation != null) {
                  _mapController.move(_userLocation!, 10.0);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.earthquake_app',
              ),
              // User location marker
              if (_userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              // Earthquake markers with clustering
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  markers: markers,
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AppDataProvider>(context, listen: false)
              .getEarthQuakeData();
        },
        child: Icon(Icons.refresh),
        tooltip: 'Refresh earthquake data',
      ),
    );
  }
}
*/
