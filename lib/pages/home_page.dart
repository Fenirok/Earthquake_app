// Copyright 2026 Aditya Halder
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND.


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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppDataProvider>().init();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // Provider.of<AppDataProvider>(context, listen: false).init();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final scale = w / 375;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QuakeTrace',
          style: TextStyle(fontSize: 18 * scale),
        ),
        actions: [
          // Location indicator
          Consumer<AppDataProvider>(
            builder: (context, provider, child) => provider.shouldUseLocation
                ? Container(
                    margin: EdgeInsets.only(right: w * 0.02),
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02,
                      vertical: h * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(w * 0.03),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 16 * scale, color: Colors.green),
                        SizedBox(width: w * 0.01),
                        Text(
                          provider.currentCity ?? 'Near you',
                          style: TextStyle(
                            fontSize: 12 * scale,
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
            icon: Icon(Icons.sort, size: scale * 22,),
            tooltip: 'Sort earthquakes',
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => MapPage()),
          //     );
          //   },
          //   icon: Icon(Icons.map),
          //   tooltip: 'View on map',
          // ),
          IconButton(
            onPressed: () =>
                Navigator.push(context, CustomPageRoute(child: SettingsPage())),
            icon: Icon(Icons.settings, size: 22 * scale),
            tooltip: 'Settings',
          ),
        ],
      ),

      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          // 1️⃣ NO INTERNET STATE
          if (provider.internetStatus == InternetStatus.disconnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 80 * scale, color: Colors.lightBlueAccent),
                  SizedBox(height: h * 0.02),
                  Text(
                    'Sorry, no internet connection',
                    style: TextStyle(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // SizedBox(height: 8),
                  // Text('Please turn on your internet and try again'),
                  SizedBox(height: h * 0.03),
                  ElevatedButton(
                    onPressed: provider.retry,
                    child: Text('Retry', style: TextStyle(fontSize: 14 * scale),),
                  ),
                ],
              ),
            );
          }

          // 2️⃣ LOADING STATE
          if (!provider.hasDataLoaded) {
            return Center(
                child: Text(
              'Please Wait',
              style: TextStyle(fontSize: 20 * scale),
            ));
          }

          // 3️⃣ EMPTY DATA
          if (provider.earthquakeModels!.features!.isEmpty) {
            return Center(child: Text('No record found', style: TextStyle(fontSize: 16 * scale),));
          }

          // 4️⃣ NORMAL WORKING UI (UNCHANGED)
          return RefreshIndicator(
            onRefresh: provider.internetStatus == InternetStatus.connected
                ? provider.retry
                : () async {},
            child: ListView.builder(
              itemCount: provider.earthquakeModels!.features!.length,
              itemBuilder: (context, index) {
                final data =
                    provider.earthquakeModels!.features![index].properties!;
                return ListTile(
                  title: Text(data.place ?? data.title ?? 'Unknown', style: TextStyle(fontSize: 14 * scale),),
                  subtitle: Text(
                    getFormatedDateTime(
                      data.time!,
                      'EEE MMM dd yyyy hh:mm a',
                    ),
                    style: TextStyle(fontSize: 12 * scale),
                  ),
                  trailing: Chip(
                    avatar: data.alert == null
                        ? null
                        : CircleAvatar(
                      radius: 10 * scale,
                            backgroundColor:
                                provider.getAlertColor(data.alert!),
                          ),
                    label: Text('${data.mag}', style: TextStyle(fontSize: 12 * scale),),
                  ),
                );
              },
            ),
          );
        },
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
