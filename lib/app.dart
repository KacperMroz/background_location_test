import 'package:backk_location_test/background_locator.dart';
import 'package:backk_location_test/location.dart';
import 'package:backk_location_test/navigation.dart';
import 'package:backk_location_test/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Lokalizator extends StatelessWidget {
  Lokalizator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white60,
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Color(0xFF2D2D2D),
        ),
        textTheme: const TextTheme(
          // text theme of the header on each step
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black),
        ),
      ),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: Navigation.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Navigation.location,
        builder: (context, state) => const LocationPage(),
      ),
      GoRoute(
        path: Navigation.home,
        builder: (context, state) => const BackgroundLocatorApp(),
      ),
    ],
  );
}
