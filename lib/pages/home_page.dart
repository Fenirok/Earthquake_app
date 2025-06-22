import 'dart:ui';

import 'package:earthquake_app/pages/customPageRoute.dart';
import 'package:earthquake_app/pages/settings_page.dart';
import 'package:earthquake_app/pages/sortingDialog.dart';
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
  double _selectedMinMagnitude = 0;
  final List<double> _magnitudeOptions = [0, 1, 2, 3, 4, 5, 6, 7];

  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EarthQuake App'),
        actions: [
          IconButton(
            onPressed: _showSortingDialog,
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () =>
                Navigator.push(context, CustomPageRoute(child: const SettingsPage())),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Min Magnitude: '),
                DropdownButton<double>(
                  value: _selectedMinMagnitude,
                  items: _magnitudeOptions
                      .map((mag) => DropdownMenuItem(
                            value: mag,
                            child: Text(mag.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMinMagnitude = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<AppDataProvider>(
              builder: (context, provider, child) {
                if (!provider.hasDataLoaded) {
                  return const Center(child: Text('Please Wait'));
                }
                final allFeatures = provider.earthquakeModels!.features!;
                final filteredFeatures = allFeatures.where((feature) {
                  final mag = feature.properties?.mag;
                  return mag != null && mag >= _selectedMinMagnitude;
                }).toList();
                if (filteredFeatures.isEmpty) {
                  return const Center(child: Text('No record found'));
                }
                return ListView.builder(
                  itemCount: filteredFeatures.length,
                  itemBuilder: (context, index) {
                    final data = filteredFeatures[index].properties!;
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSortingDialog() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // This makes the background transparent
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX:4 , sigmaY: 4),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Center(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(2, -1),
                    end: Offset.zero, // To normal position
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
                  child: const SortingDialog(),
                ),
              )
            ],
          ),
        ),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
