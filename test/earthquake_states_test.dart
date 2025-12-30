import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:earthquake_app/main.dart';
import 'package:earthquake_app/pages/home_page.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/models/earthquake_models.dart' as models;
import 'package:earthquake_app/providers/ThemeProvider.dart'; // Fixed import path

// Add mock NetworkState and Earthquake for test only
enum NetworkState { loading, error, success }

class Earthquake {
  final int id;
  final String place;
  Earthquake({required this.id, required this.place});
}

class FakeAppDataProvider extends ChangeNotifier implements AppDataProvider {
  NetworkState _state;
  List<Earthquake> _quakes;
  Map<String, dynamic> _queryParams = {};
  models.EarthquakeModels? _mockEarthquakeModels;

  FakeAppDataProvider.loading()
      : _state = NetworkState.loading,
        _quakes = [];

  FakeAppDataProvider.error()
      : _state = NetworkState.error,
        _quakes = [];

  FakeAppDataProvider.success(this._quakes) : _state = NetworkState.success {
    // Create a mock EarthquakeModels with one feature with place 'Mock Quake'
    _mockEarthquakeModels = models.EarthquakeModels(
      features: [
        models.Features(
          properties: models.Properties(
            place: _quakes.isNotEmpty ? _quakes[0].place : 'Mock Quake',
            mag: 5.0,
            time: 1234567890,
            title: 'Mock Quake',
          ),
        ),
      ],
    );
  }


  NetworkState get state => _state;


  List<Earthquake> get quakes => _quakes;

  Future<void> fetchEarthquakes() async {}

  // Implement all required AppDataProvider methods
  @override
  void setOrder(String value) {}

  @override
  void setStartTime(String date) {}

  @override
  void setEndTime(String date) {}

  @override
  Future<void> setLocation(bool value) async {}

  @override
  void init() {}

  @override
  Color getAlertColor(String color) => const Color(0xFFFFFFFF);

  @override
  Future<void> getEarthQuakeData() async {}

  @override
  double get maxRadiusikm => 0.0;

  @override
  double get latitude => 0.0;

  @override
  double get longitude => 0.0;

  @override
  String get startTime => '';

  @override
  String get endTime => '';

  @override
  String get orderBy => '';

  @override
  String? get currentCity => null;

  @override
  double get maxRadiusKmThreshold => 0.0;

  @override
  bool get shouldUseLocation => false;

  @override
  bool get hasDataLoaded => _state == NetworkState.success;

  @override
  models.EarthquakeModels? get earthquakeModels => _mockEarthquakeModels;

  @override
  Uri get baseurl => Uri.parse('https://earthquake.usgs.gov/fdsnws/event/1/query');

  @override
  Map<String, dynamic> get queryParams => _queryParams;

  @override
  set queryParams(Map<String, dynamic> value) {
    _queryParams = value;
  }

  @override
  set earthquakeModels(models.EarthquakeModels? value) {
    _mockEarthquakeModels = value;
  }

  // Add any missing methods that might be required by your AppDataProvider interface
  // Check your actual AppDataProvider class for any additional methods

  // If your HomePage checks for loading state differently, override those methods

  bool get isLoading => _state == NetworkState.loading;


  bool get hasError => _state == NetworkState.error;


  String? get errorMessage => _state == NetworkState.error ? 'Oh snap!!!!! No Internet' : null;
}

void main() {
  Widget makeTestable(FakeAppDataProvider fakeProvider) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataProvider>.value(value: fakeProvider),
        // Create a real ThemeProvider instance
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  group('Earthquake App States', () {
    testWidgets('Loading state shows "Please Wait"', (WidgetTester tester) async {
      final fake = FakeAppDataProvider.loading();
      await tester.pumpWidget(makeTestable(fake));

      // Wait for the widget tree to build
      await tester.pumpAndSettle();

      // Debug: Print all text widgets found
      final textWidgets = find.byType(Text);
      print('Found ${textWidgets.evaluate().length} text widgets');
      for (final element in textWidgets.evaluate()) {
        final widget = element.widget as Text;
        print('Text widget: "${widget.data}"');
      }

      expect(find.text('Please Wait'), findsOneWidget);
    });

    testWidgets('Error state shows "Oh snap!!!!! No Internet"', (WidgetTester tester) async {
      final fake = FakeAppDataProvider.error();
      await tester.pumpWidget(makeTestable(fake));

      await tester.pumpAndSettle();

      // Debug: Print all text widgets found
      final textWidgets = find.byType(Text);
      print('Found ${textWidgets.evaluate().length} text widgets');
      for (final element in textWidgets.evaluate()) {
        final widget = element.widget as Text;
        print('Text widget: "${widget.data}"');
      }

      expect(find.text('Oh snap!!!!! No Internet'), findsOneWidget);
    });

    testWidgets('Success state displays list of earthquakes', (WidgetTester tester) async {
      final mockQuakes = [Earthquake(id: 1, place: 'Mock Quake')];
      final fake = FakeAppDataProvider.success(mockQuakes);
      await tester.pumpWidget(makeTestable(fake));

      await tester.pumpAndSettle();

      // Debug: Print all text widgets found
      final textWidgets = find.byType(Text);
      print('Found ${textWidgets.evaluate().length} text widgets');
      for (final element in textWidgets.evaluate()) {
        final widget = element.widget as Text;
        print('Text widget: "${widget.data}"');
      }

      // Verify the one item appears in the list:
      expect(find.text('Mock Quake'), findsOneWidget);
    });
  });
}