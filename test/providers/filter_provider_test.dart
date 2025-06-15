import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:earthquake_app/providers/filter_provider.dart'; // Updated import

void main() {
  group('FilterProvider Tests', () {
    late FilterProvider filterProvider;

    setUp(() {
      filterProvider = FilterProvider();
    });

    test('initial values should be correct', () {
      expect(filterProvider.startDate, null);
      expect(filterProvider.endDate, null);
      expect(filterProvider.startTime, const TimeOfDay(hour: 0, minute: 0));
      expect(filterProvider.endTime, const TimeOfDay(hour: 23, minute: 59));
    });

    test('setDateRange updates dates correctly', () {
      final startDate = DateTime(2023, 1, 1);
      final endDate = DateTime(2023, 1, 2);

      filterProvider.setDateRange(startDate, endDate);

      expect(filterProvider.startDate, startDate);
      expect(filterProvider.endDate, endDate);
    });

    test('setTimeRange updates times correctly', () {
      final startTime = const TimeOfDay(hour: 10, minute: 30);
      final endTime = const TimeOfDay(hour: 14, minute: 45);

      filterProvider.setTimeRange(startTime, endTime);

      expect(filterProvider.startTime, startTime);
      expect(filterProvider.endTime, endTime);
    });

    test('combined DateTime objects are correct', () {
      final startDate = DateTime(2023, 1, 1);
      final endDate = DateTime(2023, 1, 2);
      final startTime = const TimeOfDay(hour: 10, minute: 30);
      final endTime = const TimeOfDay(hour: 14, minute: 45);

      filterProvider.setDateRange(startDate, endDate);
      filterProvider.setTimeRange(startTime, endTime);

      expect(
        filterProvider.combinedStartDateTime,
        DateTime(2023, 1, 1, 10, 30),
      );
      expect(
        filterProvider.combinedEndDateTime,
        DateTime(2023, 1, 2, 14, 45),
      );
    });

    test('invalid time range should not update', () {
      final startDate = DateTime(2023, 1, 1);
      final endDate = DateTime(2023, 1, 1); // Same day
      filterProvider.setDateRange(startDate, endDate);

      final startTime = const TimeOfDay(hour: 14, minute: 0);
      final endTime = const TimeOfDay(hour: 10, minute: 0);

      filterProvider.setTimeRange(startTime, endTime);

      // Times should not update due to invalid range
      expect(filterProvider.startTime, const TimeOfDay(hour: 0, minute: 0));
      expect(filterProvider.endTime, const TimeOfDay(hour: 23, minute: 59));
    });
  });
}
