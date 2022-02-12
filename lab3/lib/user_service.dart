import 'package:lab3/location_service.dart';
import 'package:lab3/user.dart';

import 'exam.dart';

class UserService {
  static final UserService _instance = UserService._private();

  final LocationService _locationService = LocationService();

  List<User> _users = [];

  factory UserService() {
    return _instance;
  }

  List<User> get users => _users;

  void addUser(String name) {
    _users.add(User(name));
  }

  void addExamForUser(
      String userName, String examName, DateTime dateTime, String location) {
    _users
        .firstWhere((u) => u.name == userName, orElse: () => User(""))
        .addExam(Exam(examName, dateTime, location));

    _locationService.users = _users;
  }

  List<Exam> getExamsForUser(String userName) {
    return _users
        .firstWhere((u) => u.name == userName, orElse: () => User(""))
        .exams;
  }

  UserService._private();
}
