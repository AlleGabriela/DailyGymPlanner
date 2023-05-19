import 'package:daily_gym_planner/util/constants.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  const MyAppBar({Key? key}) : super(key: key);

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
            //TODO: Add your user photo onPressed logic here
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
