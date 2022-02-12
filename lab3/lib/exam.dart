class Exam {
  final String _name;
  final DateTime _dateTime;
  final String _location;

  Exam(this._name, this._dateTime, this._location);

  DateTime get dateTime => _dateTime;

  String get name => _name;

  String get location => _location;
}