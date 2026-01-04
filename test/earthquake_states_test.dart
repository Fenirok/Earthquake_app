import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:earthquake_app/pages/home_page.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/models/earthquake_models.dart' as models;
import 'package:earthquake_app/providers/ThemeProvider.dart';

/// Fake provider aligned with real AppDataProvider contract
class FakeAppDataProvider extends ChangeNotifier
    implements AppDataProvider {

  @override
  InternetStatus internetStatus;

  models.EarthquakeModels? _mockEarthquakeModels;

  FakeAppDataProvider.loading()
      : internetStatus = InternetStatus.loading;

  FakeAppDataProvider.disconnected()
      : internetStatus = InternetStatus.disconnected;

  FakeAppDataProvider.success(String place)
      : internetStatus = InternetStatus.connected {
    _mockEarthquakeModels = models.EarthquakeModels(
      features: [
        models.Features(
          properties: models.Properties(
            place: place,
            mag: 5.2,
            time: DateTime.now().millisecondsSinceEpoch,
            title: place,
          ),
        ),
      ],
    );
  }

  // -------- Required overrides used by HomePage --------

  @override
  bool get hasDataLoaded =>
      internetStatus == InternetStatus.connected &&
          _mockEarthquakeModels != null;

  @override
  models.EarthquakeModels? get earthquakeModels =>
      _mockEarthquakeModels;

  @override
  Future<void> retry() async {}

  // -------- Unused but required interface members --------

  @override
  Uri get baseurl =>
      Uri.parse('https://earthquake.usgs.gov/fdsnws/event/1/query');

  @override
  Map<String, dynamic> get queryParams => {};

  @override
  set queryParams(Map<String, dynamic> value) {}

  @override
  set earthquakeModels(models.EarthquakeModels? value) {
    _mockEarthquakeModels = value;
  }

  @override
  Future<void> init() async{}

  @override
  Future<void> getEarthQuakeData() async {}

  @override
  void setOrder(String value) {}

  @override
  void setStartTime(String date) {}

  @override
  void setEndTime(String date) {}

  @override
  Future<void> setLocation(bool value) async {}

  @override
  Color getAlertColor(String color) => Colors.red;

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
}

void main() {
  Widget makeTestable(FakeAppDataProvider fakeProvider) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataProvider>.value(
          value: fakeProvider,
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  group('HomePage UI states', () {

    testWidgets(
        'Loading state shows "Please Wait"',
            (WidgetTester tester) async {
          final fake = FakeAppDataProvider.loading();

          await tester.pumpWidget(makeTestable(fake));
          await tester.pump();

          expect(find.text('Please Wait'), findsOneWidget);
        });

    testWidgets(
        'Disconnected state shows no internet UI',
            (WidgetTester tester) async {
          final fake = FakeAppDataProvider.disconnected();

          await tester.pumpWidget(makeTestable(fake));
          await tester.pump();

          expect(
            find.text('Sorry, no internet connection'),
            findsOneWidget,
          );
          expect(find.text('Retry'), findsOneWidget);
        });

    testWidgets(
        'Connected state shows earthquake list',
            (WidgetTester tester) async {
          final fake = FakeAppDataProvider.success('Mock Quake');

          await tester.pumpWidget(makeTestable(fake));
          await tester.pump();

          expect(find.text('Mock Quake'), findsOneWidget);
        });
  });
}
