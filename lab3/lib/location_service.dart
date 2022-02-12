import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab3/notification_service.dart';
import 'package:lab3/user.dart';
import 'package:location/location.dart' hide LocationAccuracy;

import 'exam.dart';

class LocationService {
  static final LocationService _instance = LocationService._private();

  final NotificationService _notificationService = NotificationService();
  List<User> _users = [];

  set users(List<User> value) {
    _users = value;
  }

  LocationService._private();

  factory LocationService() {
    return _instance;
  }

  void navigateToDestination(String destination) async {
    var currentLocation = await getCurrentLocation();

    String origin = currentLocation;
    print("Origin $origin");
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin +
                  "&destination=" +
                  destination +
                  "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
  }

  Future<String> getCurrentLocation() async {
    final Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error(PermissionStatus.denied);
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error(PermissionStatus.denied);
      }
    }

    LocationData locationData = await location.getLocation();

    return locationData.latitude.toString() +
        "," +
        locationData.longitude.toString();
  }

  void startLocationNotifications() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (position != null) {
        for (User u in _users) {
          List<Exam> exams = u.exams;
          for (Exam e in exams) {
            double endLatitude = double.parse(e.location.split(",")[0]);
            double endLongitude = double.parse(e.location.split(",")[1]);
            double distanceBetween = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                endLatitude,
                endLongitude);

            print("Exam location ${e.location}");
            print("Distance between $distanceBetween");


            if (distanceBetween <= 10) {
              print("Exam ${e.name} is nearby");
              _notificationService.showNotification("Nearby exam for ${u.name}",
                  "Exam location for ${e.name} is nearby");
            }
          }
        }
      }
    });
  }
}
