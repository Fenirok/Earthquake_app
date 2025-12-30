import 'dart:ui';

import 'package:earthquake_app/pages/customPageRoute.dart';
import 'package:earthquake_app/pages/settings_page.dart';
import 'package:earthquake_app/pages/sortingDialog.dart';
import 'package:earthquake_app/pages/map_page.dart';
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
          // Location indicator
          Consumer<AppDataProvider>(
            builder: (context, provider, child) => provider.shouldUseLocation
                ? Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          provider.currentCity ?? 'Near you',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
          IconButton(
            onPressed: _showSortingDialog,
            icon: Icon(Icons.sort),
            tooltip: 'Sort earthquakes',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
            icon: Icon(Icons.map),
            tooltip: 'View on map',
          ),
          IconButton(
            onPressed: () =>
                Navigator.push(context, CustomPageRoute(child: SettingsPage())),
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
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
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // This makes the background transparent
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
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
                  child: SortingDialog(),
                ),
              )
            ],
          ),
        ),
        transitionDuration: Duration(milliseconds: 200),
        reverseTransitionDuration: Duration(milliseconds: 200),
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
