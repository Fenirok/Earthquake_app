import 'package:earthquake_app/pages/RadioButtons.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SortingDialog extends StatelessWidget {
  const SortingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sort by'),
      content: Consumer<AppDataProvider>(
        builder: (context, provider, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioGroup(
              label: 'Magnitude-Desc',
              groupValue: provider.orderBy,
              value: 'magnitude',
              onChange: (value) {
                provider.setOrder(value!);
              },
            ),
            RadioGroup(
              label: 'Magnitude-Asc',
              groupValue: provider.orderBy,
              value: 'magnitude-asc',
              onChange: (value) {
                provider.setOrder(value!);
              },
            ),
            RadioGroup(
              label: 'Time-Desc',
              groupValue: provider.orderBy,
              value: 'time',
              onChange: (value) {
                provider.setOrder(value!);
              },
            ),
            RadioGroup(
              label: 'Time-Asc',
              groupValue: provider.orderBy,
              value: 'time-asc',
              onChange: (value) {
                provider.setOrder(value!);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'))
      ],
    );
  }
}
