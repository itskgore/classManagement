import 'dart:convert';

import 'package:classstud/constants/apiUrl.dart';
import 'package:classstud/models/classesModel.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class StuClasses with ChangeNotifier {
  //Classes List
  List<ClassesModel> classes = [];
  List<ClassesModel> get getClassesModel {
    return [...classes];
  }

  final LocalStorage storage = new LocalStorage('$localStorageKey');
  Future<void> getClasses() async {
    try {
      if (await storage.ready) {
        // storage.clear();
        var data = await storage.getItem("$localClasses") ?? [];
        final response = json.decode(data);
        var studentIds = [];
        if (response.isNotEmpty) {
          classes.clear();
          response.forEach((element) {
            classes.add(ClassesModel(
                id: element['id'],
                className: element['className'],
                studentId: element['students'].cast<String>() ?? []));
          });
        }
        notifyListeners();
        return reponseData(true, "Class added!");
      } else {
        return reponseData(false, "No Classes");
      }
    } catch (e) {
      print(e.toString());
      return reponseData(false, "Something went wrong!");
    }
  }

  Future<Map<String, dynamic>> addClassAndStudents(String className,
      [List<String> studId, String classId]) async {
    try {
      List data = [];

      if (studId == null) {
        classes.add(ClassesModel(
            id: DateTime.now().toIso8601String(),
            className: className,
            studentId: []));
        classes.forEach((element) {
          data.add({
            "id": element.id,
            "className": element.className,
            "students": []
          });
        });
        if (await storage.ready) {
          storage.setItem(localClasses, json.encode(data));
        }
        await getClasses();
        return reponseData(true, "Class added!");
      } else {
        classes.forEach((element) {
          if (element.id == classId) {
            element.studentId.addAll(studId);
            data.add({
              "id": element.id,
              "className": element.className,
              "students": element.studentId.toSet().toList(),
            });
          } else {
            data.add({
              "id": element.id,
              "className": element.className,
              "students": element.studentId ?? []
            });
          }
        });
        data.forEach((element) {
          element['students'].toSet().toList();
        });
        if (await storage.ready) {
          await storage.setItem(localClasses, json.encode(data));
          await getClasses();
        }

        return reponseData(true, "Students added!");
      }
    } catch (e) {
      print(e.toString());
      return reponseData(false, "Something went wrong!");
    }
  }

  Map<String, dynamic> reponseData(bool status, String msg) {
    return {"msg": msg, "status": status};
  }
}
