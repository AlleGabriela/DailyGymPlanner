import 'package:flutter/widgets.dart';

class Category {
  String name;
  IconData icon;
  Color color;
  String imgName;

  Category(
      {
        required this.name,
        required this.icon,
        required this.color,
        required this.imgName
      }
      );
}