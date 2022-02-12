import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lab3/calendar_screen.dart';
import 'package:lab3/location_service.dart';
import 'package:lab3/map_screen.dart';
import 'package:lab3/notification_service.dart';
import 'package:lab3/user_service.dart';
import 'package:lab3/users_screen.dart';
import 'package:place_picker/place_picker.dart';

import 'exam.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<_ExamsState> examsStateKey = GlobalKey<_ExamsState>();
  bool _isButtonDisabled = true;
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _isButtonDisabled ? null : _addExam,
            icon: const Icon(Icons.add_circle),
            iconSize: 40,
          ),
          IconButton(
            onPressed: _navigateToUsers,
            icon: const Icon(Icons.account_circle),
            iconSize: 40,
          )
        ],
        title: const Text("Exam List"),
      ),
      body: Exams(
        key: examsStateKey,
        enableButton: setButtonDisabled,
      ),
    );
  }

  void _navigateToUsers() async {
    dynamic result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const UsersScreen()));

    if (result != null) {
      examsStateKey.currentState?.setState(() {
        String userName = result as String;
        examsStateKey.currentState?.userName = userName;
        examsStateKey.currentState?.exams =
            userService.getExamsForUser(userName);
      });
    }
  }

  void _addExam() {
    examsStateKey.currentState?.addExam();
  }

  void setButtonDisabled(bool enabled) {
    setState(() {
      _isButtonDisabled = !enabled;
    });
  }
}

class Exams extends StatefulWidget {
  final void Function(bool enabled) enableButton;

  const Exams({Key? key, required this.enableButton}) : super(key: key);

  @override
  _ExamsState createState() => _ExamsState(enableButton);
}

class _ExamsState extends State<Exams> {
  final _textController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? examDateTime;
  String? examName;
  String? examLocation;
  final void Function(bool enabled) enableButton;
  final UserService _userService = UserService();
  final NotificationService _notificationService = NotificationService();
  final LocationService _locationService = LocationService();

  String userName = "";
  List<Exam> exams = [];

  _ExamsState(this.enableButton);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
      child: Column(children: [
        Card(
          elevation: 7.0,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title(
                    color: Colors.black,
                    child: const Text(
                      "Add new exam",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Exam name",
                  ),
                  controller: _textController,
                  onChanged: _textChanged,
                ),
                DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  dateLabelText: 'Exam date',
                  onChanged: _dateChanged,
                  controller: _dateController,
                ),
                ElevatedButton(
                  child: const Text("Pick Exam Location"),
                  onPressed: () {
                    showPlacePicker();
                  },
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exams[index].name,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat("dd MMM yyyy - hh:mm")
                                  .format(exams[index].dateTime)
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black54),
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              _navigateToLocation(exams[index].location);
                            },
                            icon: const Icon(Icons.directions))
                      ],
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              fixedSize:
                  MaterialStateProperty.all<Size>(const Size.fromWidth(1000)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: const Text(
              'Show in calendar',
              style: TextStyle(fontSize: 17),
            ),
            onPressed: _navigateToCalendar,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              fixedSize:
              MaterialStateProperty.all<Size>(const Size.fromWidth(1000)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: const Text(
              'Show on map',
              style: TextStyle(fontSize: 17),
            ),
            onPressed: _navigateToMap,
          ),
        ),
      ]),
    );
  }

  void _navigateToCalendar() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CalendarScreen(exams: exams)));
  }

  void _navigateToMap() async {
    String location = await _locationService.getCurrentLocation();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MapScreen(exams: exams, location: location,)));
  }

  void addExam() {
    _userService.addExamForUser(
        userName, examName!, examDateTime!, examLocation!);
    _notificationService.scheduleNotification(
        userName, examName!, examDateTime!);
    setState(() {
      exams = _userService.getExamsForUser(userName);
      examName = null;
      examDateTime = null;
      examLocation = null;
    });
    _textController.clear();
    _dateController.clear();
    enableButton(false);
  }

  void _textChanged(String value) {
    setState(() {
      examName = _textController.value.text;
    });
    if (examName != null && examDateTime != null && examLocation != null) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }

  void _dateChanged(String date) {
    setState(() {
      examDateTime = DateTime.parse(_dateController.value.text);
    });
    if (examName != null && examDateTime != null && examLocation != null) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }

  void showPlacePicker() async {
    String initialLocation = await _locationService.getCurrentLocation();
    LatLng latLng = LatLng(double.parse(initialLocation.split(",")[0]),
        double.parse(initialLocation.split(",")[1]));
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
            "API_KEY",
            displayLocation: latLng)));

    // Handle the result in your way
    if (result.latLng != null &&
        result.latLng?.latitude != null &&
        result.latLng?.longitude != null) {
      String lat = result.latLng?.latitude.toString() ?? "";
      String lon = result.latLng?.longitude.toString() ?? "";
      String location = lat + "," + lon;
      setState(() {
        examLocation = location;
      });
    }
    if (examName != null && examDateTime != null && examLocation != null) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }

  _navigateToLocation(String location) {
    _locationService.navigateToDestination(location);
  }
}
