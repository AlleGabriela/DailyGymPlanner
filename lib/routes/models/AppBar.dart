import 'package:daily_gym_planner/util/constants.dart';
import 'package:flutter/material.dart';

import '../trainer/settings/Settings.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userRole;

  const MyAppBar({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor:  primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Image.asset(
        'assets/images/barbell.png',
        fit: BoxFit.contain,
        height: 32,
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
          onPressed: () {
            if( userRole == "trainer") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Settings(userRole: "trainer")));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Settings(userRole: "customer")));
            }
          },
        ),
      ],
      floating: false,
      pinned: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
