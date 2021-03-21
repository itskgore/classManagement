import 'dart:async';

import 'package:classstud/models/classesModel.dart';
import 'package:classstud/models/studentModel.dart';
import 'package:classstud/providers/stuClasses.dart';
import 'package:classstud/providers/students.dart';
import 'package:classstud/utils/functions/widgetFunc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScearchStudent extends StatefulWidget {
  @required
  final ClassesModel classId;
  ScearchStudent({Key key, this.classId}) : super(key: key);

  @override
  _ScearchStudentState createState() => _ScearchStudentState();
}

class _ScearchStudentState extends State<ScearchStudent> {
  TextEditingController _controller = TextEditingController();
  Timer search;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getStudent(BuildContext context) async {
    final student = Provider.of<StudentPro>(context, listen: false);
    if (student.getStudentData.isEmpty) {
      final res = await student.getStudents();
    }
  }

  Future<void> searchStudent() async {
    final student = Provider.of<StudentPro>(context, listen: false);
    student.searchStudent(_controller.text);
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Future<void> submitStudents(BuildContext context) async {
    final classes = Provider.of<StuClasses>(context, listen: false);
    final student = Provider.of<StudentPro>(context, listen: false);
    final resp = await classes.addClassAndStudents(
        widget.classId.className, student.studentIds, widget.classId.id);
    if (resp['status']) {
      student.selectDeselectStudent("", true);
      showSnack(context, "Student added!", _scaffoldkey);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldkey,
      floatingActionButton: Consumer<StudentPro>(
        builder: (con, stu, _) => stu.studentIds.isEmpty
            ? Container()
            : FloatingActionButton.extended(
                onPressed: () {
                  submitStudents(context);
                },
                label: Text("Submit (${stu.studentIds.length})")),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Add Student"),
        bottom: PreferredSize(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 8, top: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: TextFormField(
                    autocorrect: true,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (val) {
                      searchStudent();
                    },
                    onChanged: (val) {
                      if (search?.isActive ?? false) search.cancel();
                      search = Timer(Duration(milliseconds: 1000), () {
                        searchStudent();
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'Search student',
                        contentPadding: const EdgeInsets.only(left: 24.0),
                        border: InputBorder.none),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    searchStudent();
                  })
            ],
          ),
          preferredSize: Size.fromHeight(48.0),
        ),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: getStudent(context),
        builder: (con, snap) => snap.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Consumer<StudentPro>(
                    builder: (con, stu, _) => stu.searchStudents.isEmpty
                        ? Center(
                            child: Text(
                                "No Student with ${_controller.text} name!"),
                          )
                        : ListView.builder(
                            itemCount: stu.searchStudents.length,
                            itemBuilder: (con, i) {
                              var data = stu.searchStudents[i];
                              return GestureDetector(
                                onTap: () {
                                  stu.selectDeselectStudent(
                                      "${data.iD}", false);
                                },
                                child: Container(
                                  height: height * 0.13,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: stu.studentIds
                                                  .contains("${data.iD}")
                                              ? Colors.green
                                              : Colors.transparent,
                                          width: stu.studentIds
                                                  .contains("${data.iD}")
                                              ? 2
                                              : 0),
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          stu.studentIds.contains("${data.iD}")
                                              ? Colors.green[100]
                                              : Colors.black26),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildRichTextStudentCard(
                                          "ID", "${data.iD}"),
                                      Row(
                                        children: [
                                          buildRichTextStudentCard(
                                              "Class", "${data.stuClass}   |"),
                                          buildSizedBox(0, 10.0),
                                          buildRichTextStudentCard(
                                              "Name", "${data.name}"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          buildRichTextStudentCard(
                                              "Gender", "${data.gender}   |"),
                                          buildSizedBox(0, 10.0),
                                          buildRichTextStudentCard(
                                              "Seat", "${data.seat}"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
              ),
      )),
    );
  }
}
