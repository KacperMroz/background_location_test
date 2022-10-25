import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'test.dart' as t;

////
// For pretty-printing location JSON.  Not a requirement of flutter_background_geolocation
//
import 'dart:convert';
JsonEncoder encoder = new JsonEncoder.withIndent("     ");
//
////
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BackgroundGeolocation Demo',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage('BackgroundGeolocation Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {
  late bool _isMoving;
  late bool _enabled;
  late String _motionActivity;
  late String _odometer;
  late String _content;

  @override
  void initState() {
    _isMoving = false;
    _enabled = false;
    _content = '';
    _motionActivity = 'UNKNOWN';
    _odometer = '0';

    // 1.  Listen to events (See docs for all 12 available events).
    bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) {
      // print('[onHeartbeat] ${event}');
      // You could request a new location if you wish.
      bg.BackgroundGeolocation.getCurrentPosition(
          samples: 1,
          persist: true
      ).then((bg.Location location) {
        // print('[getCurrentPosition] ${location.coords.latitude} ${location.coords.longitude}');
        t.testCallback(location.coords.latitude.toString(), location.coords.longitude.toString());
      });
    });


    // 2.  Configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
        heartbeatInterval: 60,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        reset: true
    )).then((bg.State state) {
      setState(() {
        _enabled = state.enabled;
        _isMoving = state.isMoving!;
      });
    });
  }

  void _onClickEnable(enabled) {
    if (enabled) {
      bg.BackgroundGeolocation.start().then((bg.State state) {
        print('[start] success $state');
        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving!;
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
          _isMoving = state.isMoving!;
        });
      });
    }
  }

  // Manually toggle the tracking state:  moving vs stationary
  void _onClickChangePace() {
    setState(() {
      _isMoving = !_isMoving;
    });
    print("[onClickChangePace] -> $_isMoving");

    bg.BackgroundGeolocation.changePace(_isMoving).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });
  }

  // Manually fetch the current position.
  void _onClickGetCurrentPosition() {
    bg.BackgroundGeolocation.getCurrentPosition(
        persist: false,     // <-- do not persist this location
        desiredAccuracy: 0, // <-- desire best possible accuracy
        timeout: 30000,     // <-- wait 30s before giving up.
        samples: 3          // <-- sample 3 location before selecting best.
    ).then((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  ////
  // Event handlers
  //

  void _onHeartbeat(bg.Location location){
    print('[location] - $location');
  }

  void _onLocation(bg.Location location) {
    print('[location] - $location');

    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);

    setState(() {
      _content = encoder.convert(location.toMap());
      _odometer = odometerKM;
    });
  }

  void _onMotionChange(bg.Location location) {
    print('[motionchange] - $location');
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    print('[activitychange] - $event');
    setState(() {
      _motionActivity = event.activity;
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
    return Scaffold(
      appBar: AppBar(
          title: const Text('Background Geolocation'),
          actions: <Widget>[
            Switch(
                value: _enabled,
                onChanged: _onClickEnable
            ),
          ]
      ),
      body: SingleChildScrollView(
          child: Text('$_content')
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.gps_fixed),
                      onPressed: _onClickGetCurrentPosition,
                    ),
                    Text('$_motionActivity · $_odometer km'),
                    MaterialButton(
                        minWidth: 50.0,
                        child: Icon((_isMoving) ? Icons.pause : Icons.play_arrow, color: Colors.white),
                        color: (_isMoving) ? Colors.red : Colors.green,
                        onPressed: _onClickChangePace
                    )
                  ]
              )
          )
      ),
    );
  }
}