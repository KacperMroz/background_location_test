import 'dart:async';
import 'dart:convert';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter/material.dart';

class BackgroundLocatorApp extends StatefulWidget {
  const BackgroundLocatorApp({Key? key}) : super(key: key);

  @override
  State<BackgroundLocatorApp> createState() => _BackgroundLocatorAppState();
}

JsonEncoder encoder = const JsonEncoder.withIndent("     ");

class _BackgroundLocatorAppState extends State<BackgroundLocatorApp> {
  bool? _isMoving;
  bool? _enabled;
  String? _motionActivity;
  String? _odometer;
  String? _content;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _isMoving = false;
    _enabled = false;
    _content = '';
    _motionActivity = 'UNKNOWN';
    _odometer = '0';

    _onClickEnable(true);

    // 1.  Listen to events (See docs for all 12 available events).
    bg.BackgroundGeolocation.onLocation(_onLocation);

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print(' ---->>>>>>>>>    [motionchange] - ${location.isMoving}');
      print('printuje tu tyyyp ${location.activity.type}');
      if (!location.isMoving) {
        print('nie ide nigdzie');
        bg.BackgroundGeolocation.getCurrentPosition(
            samples: 1,
            persist: true
        ).then((bg.Location location) {
          print('[getCurrentPosition] ${location.coords.latitude} ${location.coords.longitude}');
        });
      } else {
        print('ide i to z impetem');
      }
    });

    bg.BackgroundGeolocation.onActivityChange((bg.ActivityChangeEvent event) {
      print('[activitychange] - $event');

      setState(() {
        _motionActivity = event.activity;
      });
      print('printuje tu motion $_motionActivity');
    });
    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      if (event.action == 'ENTER') {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          debugPrint(timer.tick.toString());
          debugPrint('wchodze w strefe domu');
        });
        //todo zamiast timera tu bedzie request wysylka api mail + iq lokalizacji tzw uuid z -Location
      }
      if (event.action == 'EXIT') {
        timer!.cancel();
        //todo tu nie strzelamy wiecej wiec ucinamy requesty
      }
      if (event.action == 'DWELL') {
        print('co to jest kurwa');
        timer!.cancel();
      }
      print('dom event ${event.action}');
    });

    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        identifier: 'DOM',
        radius: 150,
        latitude: 50.0507085,
        longitude: 19.9294436,
        notifyOnEntry: true,
        notifyOnExit: true,
        loiteringDelay: 10000))
        .then((bool success) {
      print('[addGeofence] success');
    });

    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

    // 2.  Configure the plugin
    bg.BackgroundGeolocation.ready(
      bg.Config(
        notification: bg.Notification(
          title: "Pobieranie lokalizacji",
          text: '',
        ),
        reset: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 5.0,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
      ),
    ).then((bg.State state) {
      bg.BackgroundGeolocation.start();
    }).catchError((error) {
      print('[ready] ERROR: $error');
    });
  }
  // _getSensors();

  ////
  // Event handlers
  //

  void _onLocation(bg.Location location) {
    print('[location] - $location');
    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
    int confidence = location.activity.confidence;
    String activityType = location.activity.type;
    print(
        "debug 3 ->>>>>>>>>>>>>>>>>>>>> [onLocation] Motion activity, type: $activityType, confidence: $confidence");
    setState(() {
      _content = encoder.convert(location.toMap());
      _odometer = odometerKM;
    });
  }

  void _onClickEnable(enabled) {
    if (enabled) {
      bg.BackgroundGeolocation.start().then((bg.State state) {
        print('[start] success $state');
        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      });
    } else {
      bg.BackgroundGeolocation.stop().then((bg.State state) {
        print('[stop] success: $state');
        // Reset odometer.
        bg.BackgroundGeolocation.setOdometer(0.0);

        setState(() {
          _odometer = '0.0';
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      });
    }
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    print('$event');

    setState(() {
      _content = encoder.convert(event.toMap());
    });
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    print('$event');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Background Geolocation'),
        ),
        body: SingleChildScrollView(child: Text('$_content')),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('$_motionActivity · $_odometer km'),
                    ]))),
      ),
    );
  }
}