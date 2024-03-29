import 'package:daily_gym_planner/util/constants.dart';
import 'package:flutter/material.dart';

class Box {
  InputDecoration textInputDecoration([String lableText="", String hintText = ""]){
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(marginSize, marginSize, marginSize, marginSize),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }

}

InputDecoration addPageInputStyle(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: inputDecorationColor),

    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: inputDecorationColor),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: inputDecorationColor),
    ),
  );
}

Text titleStyle(String title, double size) {
  return Text(
      title,
      style: TextStyle(
        color: primaryColor,
        fontSize: size,
        fontFamily: font1,
      )
  );
}

