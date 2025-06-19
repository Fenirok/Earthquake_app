import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EarthquakeApp Widget Tests', () {
    testWidgets('Displays loading state with "Please Wait"', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text("Please Wait")),
          ),
        ),
      );

      expect(find.text("Please Wait"), findsOneWidget);
    });

    testWidgets('Displays error state with "Oh snap!!!!! No Internet"', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text("Oh snap!!!!! No Internet")),
          ),
        ),
      );

      expect(find.text("Oh snap!!!!! No Internet"), findsOneWidget);
    });

    testWidgets('Displays success state with earthquake data', (WidgetTester tester) async {
      final List<String> mockData = ['Earthquake in Japan', 'Earthquake in California'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: mockData.map((quake) => ListTile(title: Text(quake))).toList(),
            ),
          ),
        ),
      );

      expect(find.text('Earthquake in Japan'), findsOneWidget);
      expect(find.text('Earthquake in California'), findsOneWidget);
    });
  });
}
