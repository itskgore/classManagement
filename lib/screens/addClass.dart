import 'package:classstud/providers/stuClasses.dart';
import 'package:classstud/providers/students.dart';
import 'package:classstud/screens/scearchStudent.dart';
import 'package:classstud/utils/functions/widgetFunc.dart';
import 'package:classstud/widgets/animatedNavigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddClass extends StatefulWidget {
  AddClass({Key key}) : super(key: key);

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String className = "";
  Future<void> getClasses(BuildContext context) async {
    final classes = Provider.of<StuClasses>(context, listen: false);
    final student = Provider.of<StudentPro>(context, listen: false);
    var resp;
    if (student.getStudentData.isEmpty) {
      resp = await student.getStudents();
    }
    if (resp['status']) {
      if (classes.getClassesModel.isEmpty) {
        classes.getClasses();
      }
    }
  }

  Future<void> addClass(BuildContext context) async {
    modalBottomSheetMenu();
  }

  Future<void> submitClass() async {
    final classes = Provider.of<StuClasses>(context, listen: false);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final res = await classes.addClassAndStudents(className);
      if (res['status']) {
        showSnack(context, res['msg'], _scaffoldkey);
      }
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  void modalBottomSheetMenu() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        elevation: 5,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        context: context,
        builder: (builder) {
          return Container(
            height: 200.0,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: new TextFormField(
                        autocorrect: true,
                        style: TextStyle(color: Colors.black, fontSize: 22),
                        validator: (value) {
                          if (value.trimRight().trimLeft().isEmpty) {
                            return 'Please enter class name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          className = value.trimLeft().trimRight();
                        },
                        decoration: InputDecoration(
                          labelText: 'Class Name',
                          labelStyle: TextStyle(color: Colors.black38),
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        )),
                  ),
                ),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                        onPressed: () {
                          submitClass();
                        },
                        child: Text("Submit")))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Classes"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getClasses(context),
          builder: (con, snap) => snap.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<StuClasses>(
                  builder: (con, classes, _) => classes.getClassesModel.isEmpty
                      ? Center(
                          child: Container(
                            width: width * 0.80,
                            height: height * 0.08,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueAccent)),
                              onPressed: () {
                                addClass(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.add),
                                  Expanded(
                                      child: Text(
                                    "Add Class",
                                    textAlign: TextAlign.center,
                                  )),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: classes.getClassesModel.length,
                                  itemBuilder: (con, i) {
                                    var data = classes.getClassesModel[i];
                                    return Container(
                                      child: ExpansionTile(
                                        title: Text(data.className),
                                        backgroundColor: Colors.black26,
                                        children: List.generate(
                                            data.studentId.isEmpty
                                                ? 1
                                                : data.studentId.length,
                                            (index) {
                                          if (data.studentId.isEmpty) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      FadeNavigation(
                                                          widget:
                                                              ScearchStudent(
                                                    classId: data,
                                                  )));
                                                },
                                                child: Text("Add Student"),
                                              ),
                                            );
                                          } else {
                                            var stud = data.studentId[index];

                                            return Consumer<StudentPro>(
                                                builder: (con, student, _) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 10, bottom: 8),
                                                    child: buildRichTextStudentCard(
                                                        "Name",
                                                        "${student.studentData[student.indexOfStudent(stud)].name}"),
                                                  ),
                                                  index ==
                                                          data.studentId
                                                                  .length -
                                                              1
                                                      ? Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 10),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                  FadeNavigation(
                                                                      widget:
                                                                          ScearchStudent(
                                                                classId: data,
                                                              )));
                                                            },
                                                            child: Text(
                                                                "Add Student"),
                                                          ),
                                                        )
                                                      : SizedBox()
                                                ],
                                              );
                                            });
                                          }
                                        }),
                                      ),
                                    );
                                  }),
                            ),
                            Container(
                              width: double.infinity,
                              height: height * 0.08,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueAccent)),
                                onPressed: () {
                                  addClass(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    Expanded(
                                        child: Text(
                                      "Add Class",
                                      textAlign: TextAlign.center,
                                    )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                ),
        ),
      ),
    );
  }
}
