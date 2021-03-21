import 'package:flutter/material.dart';

SizedBox buildSizedBox([double height, double width]) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
  );
}

RichText buildRichTextStudentCard(String title, String value) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
            text: '$title : ', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: '$value'),
      ],
    ),
  );
}

void showSnack(
    BuildContext context, stringList, GlobalKey<ScaffoldState> _scaffoldkey) {
  // final states = Provider.of<AppStates>(context);
  _scaffoldkey.currentState.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 8,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(width: 1, color: Colors.blue)),
    content: Text(
      stringList,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.white,
  ));
}
