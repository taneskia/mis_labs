class Exam {
  final String _name;
  final DateTime _dateTime;

  Exam(this._name, this._dateTime);

  DateTime get dateTime => _dateTime;

  String get name => _name;
}