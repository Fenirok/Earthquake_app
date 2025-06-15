import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';

class FilterDialog extends StatefulWidget {
  final bool debugMode;

  const FilterDialog({
    Key? key,
    this.debugMode = false,
  }) : super(key: key ?? const Key('filter_dialog'));

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    final filter = Provider.of<FilterProvider>(context, listen: false);
    if (filter.startDateTime != null) {
      _startTime = TimeOfDay.fromDateTime(filter.startDateTime!);
    }
    if (filter.endDateTime != null) {
      _endTime = TimeOfDay.fromDateTime(filter.endDateTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debugMode) debugPrint('Building FilterDialog...');

    return Consumer<FilterProvider>(
      builder: (context, filter, _) {
        if (widget.debugMode) debugPrint('FilterDialog Consumer rebuilding...');

        return AlertDialog(
          key: const Key('filter_dialog_alert'),
          title: const Text(
            'Filter Earthquakes',
            key: Key('filter_earthquakes_title'),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Range Picker
                ListTile(
                  key: Key('date_range_list_tile'),
                  title: const Text(
                    'Date Range',
                    key: Key('date_range_text'),
                  ),
                  subtitle: Text(
                    '${filter.startDate?.toString().split(' ')[0] ?? 'Start Date'} - '
                    '${filter.endDate?.toString().split(' ')[0] ?? 'End Date'}',
                  ),
                  onTap: () async {
                    final DateTimeRange? result = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      currentDate: DateTime.now(),
                    );
                    if (result != null) {
                      filter.setDateRange(result.start, result.end);
                    }
                  },
                ),

                // Start Time Picker
                ListTile(
                  key: Key('start_time_list_tile'),
                  title: const Text(
                    'Start Time',
                    key: Key('start_time_text'),
                  ),
                  subtitle: Text(_startTime?.format(context) ?? 'Select Start Time'),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _startTime ?? TimeOfDay(hour: 0, minute: 0),
                    );
                    if (picked != null) setState(() => _startTime = picked);
                  },
                ),

                // End Time Picker
                ListTile(
                  key: Key('end_time_list_tile'),
                  title: const Text(
                    'End Time',
                    key: Key('end_time_text'),
                  ),
                  subtitle: Text(_endTime?.format(context) ?? 'Select End Time'),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _endTime ?? TimeOfDay(hour: 23, minute: 59),
                    );
                    if (picked != null) setState(() => _endTime = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              key: const Key('filter_dialog_cancel'),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              key: const Key('filter_dialog_apply'),
              onPressed: () {
                // Combine date and time
                DateTime? finalStart;
                DateTime? finalEnd;

                if (filter.startDate != null) {
                  finalStart = DateTime(
                    filter.startDate!.year,
                    filter.startDate!.month,
                    filter.startDate!.day,
                    _startTime?.hour ?? 0,
                    _startTime?.minute ?? 0,
                  );
                }

                if (filter.endDate != null) {
                  finalEnd = DateTime(
                    filter.endDate!.year,
                    filter.endDate!.month,
                    filter.endDate!.day,
                    _endTime?.hour ?? 23,
                    _endTime?.minute ?? 59,
                  );
                }

                if (finalStart != null &&
                    finalEnd != null &&
                    finalStart.isBefore(finalEnd)) {
                  filter.setTimeRange(
                      _startTime ?? TimeOfDay(hour: 0, minute: 0),
                      _endTime ?? TimeOfDay(hour: 23, minute: 59));

                  filter.setDateRange(filter.startDate, filter.endDate);

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select valid date and time ranges'),
                    ),
                  );
                }
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
