import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'exam.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<_ExamsState> examsStateKey = GlobalKey<_ExamsState>();
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Exams',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: _isButtonDisabled ? null : _addExam,
                icon: const Icon(Icons.add_circle),
                iconSize: 40,
              )
            ],
            title: const Text("Exam List"),
          ),
          body: Exams(
            key: examsStateKey,
            enableButton: setButtonDisabled,
          ),
        ));
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
  final void Function(bool enabled) enableButton;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exams[index].name,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat("dd MMM yyyy - hh:mm").format(exams[index].dateTime).toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }

  void addExam() {
    setState(() {
      exams.add(Exam(examName!, examDateTime!));
      examName = null;
      examDateTime = null;
    });
    _textController.clear();
    _dateController.clear();
    enableButton(false);
  }

  void _textChanged(String value) {
    setState(() {
      examName = _textController.value.text;
    });
    if (examName != null && examDateTime != null) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }

  void _dateChanged(String date) {
    setState(() {
      examDateTime = DateTime.parse(_dateController.value.text);
    });
    if (examName != null && examDateTime != null) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }
}
