// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:earthquake_app/providers/filter_provider.dart';
import 'package:earthquake_app/widgets/filter_dialog.dart';

void main() {
  group('FilterDialog Tests', () {
    late FilterProvider filterProvider;

    setUp(() {
      filterProvider = FilterProvider();
      debugPrint('Setting up FilterProvider...');
    });

    testWidgets('Filter Dialog shows and updates correctly', (WidgetTester tester) async {
      debugPrint('Starting dialog test...');

      // Track if showDialog is called
      final dialogShown = ValueNotifier<bool>(false);

      // Build widget tree with Scaffold for proper dialog context
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: filterProvider,
              child: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    key: Key('show_filter_button'),
                    onPressed: () {
                      debugPrint('Button tapped, showing dialog...');
                      dialogShown.value = true; // Set to true when dialog is shown
                      showDialog(
                        context: context,
                        builder: (_) {
                          debugPrint('Building dialog...');
                          return const FilterDialog(debugMode: true);
                        },
                      );
                    },
                    child: const Text('Show Filter'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Debug current widget tree
      debugPrint('\n=== Widget Tree Before Tap ===');
      debugDumpApp();
      debugPrint('===============================\n');

      // Tap button and wait for dialog
      debugPrint('Tapping "Show Filter" button...');
      await tester.tap(find.byKey(Key('show_filter_button')));
      await tester.pump(); // Start animation
      debugPrint('Dialog animation started...');
      await tester.pumpAndSettle(); // Wait for animation to complete

      // Debug widget tree after dialog should be shown
      debugPrint('\n=== Widget Tree After Dialog ===');
      debugDumpApp();
      debugPrint('================================\n');

      // Verify that showDialog was called
      expect(dialogShown.value, isTrue, reason: 'showDialog was not called');

      // Find dialog by key
      expect(
        find.byKey(const Key('filter_dialog_alert')),
        findsOneWidget,
        reason: 'AlertDialog not found after tapping "Show Filter"',
      );

      // Verify dialog content
      expect(
          find.descendant(
            of: find.byKey(Key('filter_dialog_alert')),
            matching: find.byKey(Key('filter_earthquakes_title')),
          ),
          findsOneWidget,
          reason: 'Filter title not found');
      expect(
          find.descendant(
            of: find.byKey(Key('filter_dialog_alert')),
            matching: find.byKey(Key('date_range_text')),
          ),
          findsOneWidget,
          reason: 'Date Range text not found',
        );
      expect(
          find.descendant(
            of: find.byKey(Key('filter_dialog_alert')),
            matching: find.byKey(Key('start_time_text')),
          ),
          findsOneWidget,
          reason: 'Start Time text not found',
        );
      expect(
          find.descendant(
            of: find.byKey(Key('filter_dialog_alert')),
            matching: find.text('Select Start Time'),
          ),
          findsOneWidget,
          reason: 'Select Start Time text not found',
        );
      expect(
          find.descendant(
            of: find.byKey(Key('filter_dialog_alert')),
            matching: find.text('Select End Time'),
          ),
          findsOneWidget,
          reason: 'Select End Time text not found',
        );

      // Test date range picker
      await tester.tap(find.text('Date Range'));
      await tester.pumpAndSettle();
      expect(find.byType(DateRangePickerDialog), findsOneWidget, reason: 'DateRangePickerDialog not found');

      // Test both time pickers
      await tester.tap(find.text('Select Start Time'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget, reason: 'TimePickerDialog not found');
      Navigator.pop(tester.element(find.byType(TimePickerDialog)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select End Time'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget, reason: 'TimePickerDialog not found');
      Navigator.pop(tester.element(find.byType(TimePickerDialog)));
      await tester.pumpAndSettle();

      // Test dialog closure
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
    });
  });
}
