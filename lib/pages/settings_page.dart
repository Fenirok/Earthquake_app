import 'package:earthquake_app/providers/ThemeProvider.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:earthquake_app/pages/map_page.dart';
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

  void showPillSnackBar(
      BuildContext context, {
        required String message,
        required bool isDark,
        required double scale,
        Duration duration = const Duration(seconds: 3),
      }) {
    final w = MediaQuery.of(context).size.width;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.06,
            vertical: w * 0.03,
          ),
          decoration: BoxDecoration(
            color: isDark ? Colors.black54 : Colors.purpleAccent,
            borderRadius: BorderRadius.circular(w * 0.08),
          ),
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: isDark ? Colors.purpleAccent : Colors.white,
              fontSize: 13 * scale,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final scale = w / 375;
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    var isDark = theme.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 18 * scale),
        ),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => ListView(
          padding: EdgeInsets.all(w * 0.02), //8.0
          children: [
            Text(
              'Time Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap(size.height * 0.01), //10
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Start Time',
                      style: TextStyle(fontSize: 16 * scale),
                    ),
                    subtitle: Text(
                      provider.startTime,
                      style: TextStyle(fontSize: 13 * scale),
                    ),
                    trailing: IconButton(
                      iconSize: 22 * scale,
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
                    title: Text(
                      'End Time',
                      style: TextStyle(fontSize: 16 * scale),
                    ),
                    subtitle: Text(
                      provider.endTime,
                      style: TextStyle(fontSize: 13 * scale),
                    ),
                    trailing: IconButton(
                      iconSize: 22 * scale,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.06,
                        vertical: h * 0.012,
                      ),
                    ),
                    onPressed: () {
                      provider.getEarthQuakeData();
                      showPillSnackBar(context, message: 'Times are Updated', isDark: isDark, scale: scale);
                      //showMsg(context, 'Times are Updated');
                    },
                    child: Text(
                      'Update Time Changes',
                      style: TextStyle(
                          fontSize: 14 * scale,
                          color: isDark ? Colors.purpleAccent : Colors.white),
                    ),
                  ),
                  SizedBox(height: h * 0.018),
                ],
              ),
            ),
            Gap(h * 0.04), //30
            Text(
              'Location Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap(h * 0.015), //10
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      provider.currentCity ?? 'Your city is unknown',
                      style: TextStyle(fontSize: 16 * scale),
                    ),
                    subtitle: provider.currentCity == null
                        ? Text(
                            'Tap to enable location services',
                            style: TextStyle(fontSize: 13 * scale),
                          )
                        : Text(
                            'EarthQuake data will be shown within ${provider.maxRadiusikm} km radius from ${provider.currentCity}'),
                    value: provider.shouldUseLocation,
                    onChanged: (value) async {
                      if (value) {
                        // When turning on location
                        EasyLoading.show(status: 'Getting your location...');
                        try {
                          await provider.setLocation(true);
                          // After getting location, fetch earthquake data for that area
                          await provider.getEarthQuakeData();
                          EasyLoading.dismiss();
                          showPillSnackBar(context, message: "Showing earthquakes near you.", isDark: isDark, scale: scale);
                          // showMsg(context,
                          //     'Location updated! Showing earthquakes near you.');
                        } catch (e) {
                          EasyLoading.dismiss();
                          showPillSnackBar(context, message: 'Failed to get location.', isDark: isDark, scale: scale);
                          // showMsg(context,
                          //     'Failed to get location. Please check permissions.');
                        }
                      } else {
                        // When turning off location
                        EasyLoading.show(status: 'Updating settings...');
                        await provider.setLocation(false);
                        await provider.getEarthQuakeData();
                        EasyLoading.dismiss();
                        showPillSnackBar(context, message: 'Location Disabled', isDark: isDark, scale: scale);
                      }
                    },
                  ),
                ],
              ),
            ),
            Gap(h * 0.02), // 30
            Card(
              child: ListTile(
                title: Text(
                  isDark ? 'Light Mode' : 'Dark Mode',
                  style: TextStyle(fontSize: 16 * scale),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white12 : Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.08), //30
                    ),
                    padding: EdgeInsets.all(w * 0.015),
                  ),
                  onPressed: () {
                    setState(() {
                      isDark = !isDark;
                    });
                    theme.toggle();
                  },
                  child: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    size: 22 * scale,
                  ),
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
