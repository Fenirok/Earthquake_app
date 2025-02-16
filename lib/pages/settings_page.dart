import 'package:earthquake_app/providers/ThemeProvider.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    var isDark = theme.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            Text(
              'Time Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap(10),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Start Time'),
                    subtitle: Text(provider.startTime),
                    trailing: IconButton(
                      onPressed: () async {
                        final date = await selectDate();
                        if (date != null) {
                          provider.setStartTime(date);
                        }
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                  ),
                  ListTile(
                    title: Text('End Time'),
                    subtitle: Text(provider.endTime),
                    trailing: IconButton(
                      onPressed: () async {
                        final date = await selectDate();
                        if (date != null) {
                          provider.setEndTime(date);
                        }
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.black : Colors.purple,
                    ),
                    onPressed: () {
                      provider.getEarthQuakeData();
                      showMsg(context, 'Times are Updaeted');
                    },
                    child: Text(
                      'Update Time Changes',
                      style: TextStyle(
                          color: isDark ? Colors.purpleAccent : Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Gap(30),
            Text(
              'Location Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap(10),
            Card(
              child: SwitchListTile(
                title: Text(provider.currentCity ?? 'Your city is unknown'),
                subtitle: provider.currentCity == null
                    ? null
                    : Text(
                        'EarthQuake data will be shown within ${provider.maxRadiusikm} km radius from ${provider.currentCity}'),
                value: provider.shouldUseLocation,
                onChanged: (value) async {
                  EasyLoading.show(status: 'Getting location');
                  await provider.setLocation(value);
                  EasyLoading.dismiss();
                },
              ),
            ),
            Gap(30),
            Card(
              child: ListTile(
                title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white12 : Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isDark = !isDark;
                    });
                    theme.toggle();
                  },
                  child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<String?> selectDate() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (dt != null) {
      return getFormatedDateTime(dt.millisecondsSinceEpoch);
    } else {
      return null;
    }
  }
}
