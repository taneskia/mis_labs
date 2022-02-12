import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'exam.dart';

class MapScreen extends StatelessWidget {
  final List<Exam> exams;
  final String location;

  const MapScreen({Key? key, required this.location, required this.exams})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLng target = LatLng(double.parse(location.split(",")[0]),
        double.parse(location.split(",")[1]));
    CameraPosition cameraPosition = CameraPosition(target: target, zoom: 8);
    return Scaffold(
        body: GoogleMap(
      initialCameraPosition: cameraPosition,
      markers: createMarkers(),
    ));
  }

  Set<Marker> createMarkers() {
    return exams
        .map((e) => Marker(
            markerId: MarkerId(e.location),
            position: LatLng(double.parse(e.location.split(",")[0]),
                double.parse(e.location.split(",")[1])),
            infoWindow: InfoWindow(
                title: e.name,
                snippet: DateFormat("dd MMM yyyy - hh:mm")
                    .format(e.dateTime)
                    .toString())))
        .toSet();
  }
}
