import 'exam.dart';

class User {
  final String _name;
  late List<Exam> _exams;

  User(this._name) {
    _exams = [];
  }

  List<Exam> get exams => _exams;

  String get name => _name;

  void addExam(Exam exam) {
    _exams.add(exam);
  }
}