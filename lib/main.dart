import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall/views/screens/HomePage.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/providers/connectivity_provider.dart';
import 'controllers/providers/url_provider.dart';
import 'models/url_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> bookmarkPageName = prefs.getStringList('bookmarkPageName') ?? [];
  List<String> bookmarkPageUrl = prefs.getStringList('bookmarkPageUrl') ?? [];

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UrlProvider(
            urlModel: UrlModel(
              url: "https://www.google.com/",
              searchController: TextEditingController(),
              bookmarkPageName: bookmarkPageName,
              bookmarkPageUrl: bookmarkPageUrl,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const HomePage(),
        },
      ),
    ),
  );
}
