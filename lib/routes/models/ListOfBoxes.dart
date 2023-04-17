import 'package:daily_gym_planner/util/components_theme/box.dart';
import 'package:flutter/material.dart';

class ListOfBoxes {
  static List<Widget> buildBoxes() {
    List<Widget> boxes = [];
    for (int i = 0; i < 10; i++) {
      boxes.add(
        GestureDetector(
          onTap: () {
            //TODO: handle tap on box
          },
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            height: 170,
            decoration: Box().listOfBoxDesign(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Box $i', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      );
    }
    return boxes;
  }
}
