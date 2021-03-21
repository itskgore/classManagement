import 'package:classstud/providers/stuClasses.dart';
import 'package:classstud/providers/students.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/addClass.dart';
import 'screens/scearchStudent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: StudentPro()),
        ChangeNotifierProvider.value(value: StuClasses()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AddClass(),
      ),
    );
  }
}
