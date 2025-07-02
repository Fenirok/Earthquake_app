

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


import 'package:earthquake_app/main.dart';
import 'package:earthquake_app/pages/home_page.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/models/earthquake.dart';


class FakeAppDataProvider extends ChangeNotifier implements AppDataProvider {
  NetworkState _state;
  List<Earthquake> _quakes;

  FakeAppDataProvider.loading()
      : _state = NetworkState.loading,
        _quakes = [];

  FakeAppDataProvider.error()
      : _state = NetworkState.error,
        _quakes = [];

  FakeAppDataProvider.success(this._quakes)
      : _state = NetworkState.success;

  @override
  NetworkState get state => _state;

  @override
  List<Earthquake> get quakes => _quakes;

  @override
  Future<void> fetchEarthquakes() async {
    // no-op;  already have data in _quakes or just error/loading
  }
}

void main() {
  Widget makeTestable(FakeAppDataProvider fakeProvider) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataProvider>.value(value: fakeProvider),
        // If  need ThemeProvider too, inject a dummy one:
        ChangeNotifierProvider<ThemeProvider>.value(
            value: ThemeProvider()), 
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  testWidgets('Loading state shows "Please Wait"', (tester) async {
    final fake = FakeAppDataProvider.loading();
    await tester.pumpWidget(makeTestable(fake));
    
    await tester.pump();
    expect(find.text('Please Wait'), findsOneWidget);
  });

  testWidgets('Error state shows "Oh snap!!!!! No Internet"', (tester) async {
    final fake = FakeAppDataProvider.error();
    await tester.pumpWidget(makeTestable(fake));
    await tester.pump();
    expect(find.text('Oh snap!!!!! No Internet'), findsOneWidget);
  });

  testWidgets('Success state displays list of earthquakes', (tester) async {
    final mockQuakes = [Earthquake(id: 1, place: 'Mock Quake')];
    final fake = FakeAppDataProvider.success(mockQuakes);
    await tester.pumpWidget(makeTestable(fake));
    await tester.pump();
    // Verify the one item appears in the list:
    expect(find.text('Mock Quake'), findsOneWidget);
  });
}
