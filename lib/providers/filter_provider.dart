import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 59);

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  DateTime? get startDateTime => combinedStartDateTime;
  DateTime? get endDateTime => combinedEndDateTime;

  DateTime? get combinedStartDateTime {
    if (_startDate == null) return null;
    return DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime.hour,
      _startTime.minute,
    );
  }

  DateTime? get combinedEndDateTime {
    if (_endDate == null) return null;
    return DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime.hour,
      _endTime.minute,
    );
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void setTimeRange(TimeOfDay start, TimeOfDay end) {
    if (_isValidTimeRange(start, end)) {
      _startTime = start;
      _endTime = end;
      notifyListeners();
    }
  }

  bool _isValidTimeRange(TimeOfDay start, TimeOfDay end) {
    if (_startDate == null || _endDate == null) return true;
    if (_startDate != _endDate) return true;

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return startMinutes <= endMinutes;
  }

  bool isValidRange() {
    if (_startDate == null || _endDate == null) return false;

    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime.hour,
      _endTime.minute,
    );

    return startDateTime.isBefore(endDateTime) ||
        startDateTime.isAtSameMomentAs(endDateTime);
  }
}
