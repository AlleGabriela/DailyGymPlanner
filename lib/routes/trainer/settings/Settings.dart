

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/AppBar.dart';
import '../../models/RiverMenu.dart';

class Settings extends StatefulWidget{
  const Settings({super.key});

  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    String userName = "userName";
    return MaterialApp(
      home: Scaffold(
        drawer: RiverMenu(
          userName: userName,
          selectedSection: "Settings",
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            const MyAppBar(),
          ],
        ),
      ),
    );
  }
}