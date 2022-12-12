import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_information/device_information.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'locator_state.dart';

@singleton
class LocatorCubit extends Cubit<LocatorState> {
  LocatorCubit() : super(const LocatorState());

  JsonEncoder encoder = const JsonEncoder.withIndent("     ");
  final Permission _permission = Permission.phone;

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
      loiteringDelay: 10000,
    ),
    bg.Geofence(
      identifier: 'IMPEL',
      radius: 500,
      latitude: 51.128075,
      longitude: 17.045076,
      notifyOnEntry: true,
      notifyOnExit: true,
      loiteringDelay: 10000,
    ),
  ];

  void _saveLocation() {
    FirebaseFirestore.instance.collection('locationWithDate').add({
      'latitude': state.latitude,
      'longitude': state.longitude,
      'imei': state.imei,
      'date': DateTime.now().toLocal().toString()
    });
  }

  Future<void> setLocation(String location) async {
    emit(state.copyWith(location: location));
  }

  Future<void> initialize() async {
    requestPermission(_permission);

    bg.BackgroundGeolocation.onLocation(_onLocation);

    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);

    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);

    bg.BackgroundGeolocation.onGeofence(_onGeofence);

    bg.BackgroundGeolocation.addGeofences(geofences).then((bool success) {
      debugPrint('[addGeofence] success');
    });
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

    bg.BackgroundGeolocation.ready(
      bg.Config(
        notification: bg.Notification(
          title: "Pobieranie lokalizacji",
          text: '',
        ),
        reset: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_ERROR,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 5.0,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
      ),
    ).then((bg.State state) {
      bg.BackgroundGeolocation.start();
    }).catchError((error) {
      debugPrint('[ready] ERROR: $error');
    });
  }

  void _onLocation(bg.Location location) {
    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
    int confidence = location.activity.confidence;
    String activityType = location.activity.type;
    double lat = location.coords.latitude;
    double lng = location.coords.longitude;
    double speed = location.coords.speed;
    String uuid = location.uuid;
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

  Future<void> _onGetDeviceInfo() async {
    String imei;
    var imeiNo = await DeviceInformation.deviceIMEINumber;
    imei = imeiNo.toString();
    emit(state.copyWith(status: LocatorStatus.success, imei: imei));
  }

  void _onMotionChange(bg.Location location) {
    debugPrint(' ---->>>>>>>>>    [motionchange] - ${location.isMoving}');
    debugPrint('[Motion Activity Type]: ${location.activity.type}');
    if (!location.isMoving) {
      debugPrint('DEVICE IS NOT MOVING');
      bg.BackgroundGeolocation.getCurrentPosition(samples: 1, persist: true)
          .then((bg.Location location) {
        debugPrint(
            '[getCurrentPosition] ${location.coords.latitude} ${location.coords.longitude}');
      });
    } else {
      debugPrint('DEVICE IS MOVING');
    }
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    debugPrint('$event');
    emit(state.copyWith(
      status: LocatorStatus.success,
      content: encoder.convert(event.toMap()),
    ));
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    debugPrint('$event');
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    String motionActivity = event.activity;
    emit(state.copyWith(
      status: LocatorStatus.success,
      motionActivity: motionActivity,
    ));
  }

  void _onGeofence(bg.GeofenceEvent event) {
    if (event.action == 'ENTER') {
      _saveLocation();
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
    }
    if (event.action == 'DWELL') {}
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      await _onGetDeviceInfo();
    }
  }
}
