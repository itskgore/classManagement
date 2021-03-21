import 'dart:async';
import 'dart:convert';

import 'package:classstud/constants/apiUrl.dart';
import 'package:classstud/models/studentModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentPro extends ChangeNotifier {
  bool isLoading = false;

  // Student data List
  List<StudentModel> studentData = [];
  List<StudentModel> get getStudentData {
    return [...studentData];
  }

  List<String> studentIds = [];

  // Search Student List
  List<StudentModel> searchStudents = [];

  Future<Map<String, dynamic>> getStudents() async {
    try {
      final res = await http.get(
        url + token + '?indent=2',
      );
      final response = json.decode(res.body) as Map<String, dynamic>;
      if (response['error_msg'].isNotEmpty) {
        return reponseData(false, "Something went wrong!");
      }
      studentData.clear();
      searchStudents.clear();
      response['data'].forEach((value) {
        studentData.add(StudentModel.fromJson(value));
      });
      searchStudents.addAll(studentData);
      return reponseData(true, "Done!");
    } catch (e) {
      print(e.toString() + " Error");
      return reponseData(false, "Something went wrong!");
    }
  }

  void searchStudent(String name) {
    if (name.isEmpty) {
      searchStudents.addAll(studentData);
    } else {
      searchStudents.removeWhere((element) {
        return !element.name.toLowerCase().contains(name.toLowerCase());
      });
    }
    searchStudents.sort((a, b) => a.iD.compareTo(b.iD));

    notifyListeners();
  }

  void selectDeselectStudent(String studentId, bool clear) async {
    if (!clear) {
      if (studentIds.isEmpty) {
        studentIds.add(studentId);
      } else {
        if (studentIds.contains(studentId)) {
          studentIds.removeWhere((element) => element == studentId);
        } else {
          studentIds.add(studentId);
        }
      }
    } else {
      studentIds.clear();
    }

    notifyListeners();
  }

  int indexOfStudent(String id) {
    return getStudentData.indexWhere((element) => element.iD.toString() == id);
  }

  void startEndLoader(bool start) {
    isLoading = start;
    notifyListeners();
  }

  Map<String, dynamic> reponseData(bool status, String msg) {
    return {"msg": msg, "status": status};
  }
}
