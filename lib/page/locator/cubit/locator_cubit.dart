import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

part 'locator_state.dart';

class LocatorCubit extends Cubit<LocatorState> {
  LocatorCubit() : super(const LocatorState());

  JsonEncoder encoder = const JsonEncoder.withIndent("     ");

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

  Future<void> initialize() async {
    // 1.  Listen to events (See docs for all 12 available events).
    bg.BackgroundGeolocation.onLocation(_onLocation);

    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);

    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);

    bg.BackgroundGeolocation.onGeofence(_onGeofence);

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
    emit(state.copyWith(
      status: LocatorStatus.success,
      content: encoder.convert(location.toMap()),
      odometer: odometerKM,
      latitude: lat,
      longitude: lng,
      speed: speed,
      uuid: uuid,
    ));
  }

  void _onMotionChange(bg.Location location) {
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
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    print('$event');
    emit(state.copyWith(
      status: LocatorStatus.success,
      content: encoder.convert(event.toMap()),
    ));
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    print('$event');
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    print('[activitychange] - $event');
    String motionActivity = event.activity;
    emit(state.copyWith(
      status: LocatorStatus.success,
      motionActivity: motionActivity,
    ));
    print('printuje tu motion $motionActivity');
  }

  void _onGeofence(bg.GeofenceEvent event) {
    if (event.action == 'ENTER') {
      // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //   debugPrint(timer.tick.toString());
      //   debugPrint('wchodze w strefe domu');
      //
      // });
      //todo zamiast timera tu bedzie request wysylka api mail + iq lokalizacji tzw uuid z -Location
      emit(state.copyWith(
        status: LocatorStatus.success,
        isInSpecificArea: true,
      ));
    }
    if (event.action == 'EXIT') {
      emit(state.copyWith(
        status: LocatorStatus.success,
        isInSpecificArea: false,
      ));
      // timer!.cancel();
      //todo tu nie strzelamy wiecej wiec ucinamy requesty
    }
    if (event.action == 'DWELL') {
      print('co to jest kurwa');
      // timer!.cancel();
    }
    print('dom event ${event.action}');
  }
}
