import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color yellowA200 = fromHex('#e9fb00');

  static Color blueGray100 = fromHex('#d9d9d9');

  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color purple900 = fromHex('#54026e');

  static Color limeA100 = fromHex('#eafc71');

  static Color black9003f = fromHex('#3f000000');

  static Color redA700 = fromHex('#f80d0d');

  static Color whiteA700 = fromHex('#ffffff');

  static Color limeA400 = fromHex('#d8f800');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}