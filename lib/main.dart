import 'package:earthquake_app/pages/home_page.dart';
import 'package:earthquake_app/providers/ThemeProvider.dart';
import 'package:earthquake_app/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AppDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuakeTrace',
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: EasyLoading.init(),
      home: HomePage(),
    );
  }
}
