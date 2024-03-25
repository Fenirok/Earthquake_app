import 'package:earthquake_app/pages/settings_page.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EarthQuake App'),
        actions: [
          IconButton(
            onPressed: _showSortingDialog,
            icon: Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => provider.hasDataLoaded
            ? provider.earthquakeModels!.features!.isEmpty
                ? Center(
                    child: Text('No record found'),
                  )
                : ListView.builder(
                    itemCount: provider.earthquakeModels!.features!.length,
                    itemBuilder: (context, index) {
                      final data = provider
                          .earthquakeModels!.features![index].properties!;
                      return ListTile(
                        title: Text(data.place ?? data.title ?? 'Unknown'),
                        subtitle: Text(getFormatedDateTime(
                            data.time!, 'EEE MMM dd yyyy hh:mm a')),
                        trailing: Chip(
                          avatar: data.alert == null
                              ? null
                              : CircleAvatar(
                                  backgroundColor:
                                      provider.getAlertColor(data.alert!),
                                ),
                          label: Text('${data.mag}'),
                        ),
                      );
                    })
            : Center(
                child: Text('Please Wait'),
              ),
      ),
    );
  }

  void _showSortingDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
          ],
            ));
  }
}

class RadioGroup extends StatelessWidget {
  final String groupValue;
  final String value;
  final String label;
  final Function(String?) onChange;
  const RadioGroup({
    super.key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(label)
      ],
    );
  }
}
