import 'package:flutter/material.dart';
import 'package:daily_gym_planner/presentation/welcome_page_screen.dart';

class AppRoutes {
  static const String firstAppPageScreen = '/first_app_page_screen';

  static const String logInScreen = '/log_in_screen';

  static const String signInScreen = '/sign_in_screen';

  static const String passwordResetScreen = '/password_reset_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    firstAppPageScreen: (context) => FirstAppPageScreen()
  };
}