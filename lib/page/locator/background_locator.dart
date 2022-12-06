import 'dart:async';
import 'dart:convert';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter/material.dart';

class BackgroundLocatorView extends StatefulWidget {
  const BackgroundLocatorView({Key? key}) : super(key: key);

  @override
  State<BackgroundLocatorView> createState() => _BackgroundLocatorViewState();
}

JsonEncoder encoder = const JsonEncoder.withIndent("     ");

class _BackgroundLocatorViewState extends State<BackgroundLocatorView> {
  String? _motionActivity;
  String? _odometer;
  String? _content;
  Timer? timer;
  bool? isInSpecificArea;
  double? _lattitude;
  double? _longitude;
  double? _speed;
  String? _uuid;

  @override
  void initState() {
    super.initState();
    _content = '';
    _motionActivity = '- brak';
    _odometer = '0';

    // 1.  Listen to events (See docs for all 12 available events).
    bg.BackgroundGeolocation.onLocation(_onLocation);

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print(' ---->>>>>>>>>    [motionchange] - ${location.isMoving}');
      print('printuje tu tyyyp ${location.activity.type}');
      if (!location.isMoving) {
        print('nie ide nigdzie');
        bg.BackgroundGeolocation.getCurrentPosition(samples: 1, persist: true)
            .then((bg.Location location) {
          print(
              '[getCurrentPosition] ${location.coords.latitude} ${location.coords.longitude}');
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
        // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        //   debugPrint(timer.tick.toString());
        //   debugPrint('wchodze w strefe domu');
        //
        // });
        //todo zamiast timera tu bedzie request wysylka api mail + iq lokalizacji tzw uuid z -Location
        setState(() {
          isInSpecificArea = true;
        });

      }
      if (event.action == 'EXIT') {
        setState(() {
          isInSpecificArea = false;
        });
        // timer!.cancel();
        //todo tu nie strzelamy wiecej wiec ucinamy requesty
      }
      if (event.action == 'DWELL') {
        print('co to jest kurwa');
        timer!.cancel();
      }
      print('dom event ${event.action}');
    });

    List<bg.Geofence> geofences = [
      bg.Geofence(
          identifier: 'DOM',
          radius: 150,
          latitude: 50.0507085,
          longitude: 19.9294436,
          notifyOnEntry: true,
          notifyOnExit: true,
          loiteringDelay: 10000),
      bg.Geofence(
          identifier: 'DOM2',
          radius: 150,
          latitude: 50.6949,
          longitude: 20.4600,
          notifyOnEntry: true,
          notifyOnExit: true,
          loiteringDelay: 10000),
    ];

    bg.BackgroundGeolocation.addGeofences(geofences).then((bool success) {
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

  ////
  // Event handlers
  //

  void _onLocation(bg.Location location) {
    print('[location] - $location');
    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
    int confidence = location.activity.confidence;
    String activityType = location.activity.type;
    double lat = location.coords.latitude;
    double lng = location.coords.longitude;
    double speed = location.coords.speed;
    String uuid = location.uuid;
    print(
        "debug 3 ->>>>>>>>>>>>>>>>>>>>> [onLocation] Motion activity, type: $activityType, confidence: $confidence");
    setState(() {
      _content = encoder.convert(location.toMap());
      _odometer = odometerKM;
      _lattitude = lat;
      _longitude = lng;
      _speed = speed;
      _uuid = uuid;
    });
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Jesteś w wyznaczonym miejscu: ${isInSpecificArea == true ? 'Tak' : 'Nie'}'),
              Text('Współrzędne: $_lattitude $_longitude'),
              Text('Ostatnia prędkość: $_speed'),
              Text('Id: $_uuid'),
              Text('Aktywność ruchowa:$_motionActivity '),
              Text('Przebyty dystans: $_odometer km'),
            ]
                .expand(
                  (element) => [
                    element,
                    const SizedBox(
                      height: 13,
                    ),
                  ],
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
