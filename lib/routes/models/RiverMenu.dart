import 'package:daily_gym_planner/routes/trainer/clients/ClientsListPage.dart';
import 'package:daily_gym_planner/routes/trainer/news/TrainerHomePage.dart';
import 'package:daily_gym_planner/routes/trainer/Workout/WorkoutListPage.dart';
import 'package:daily_gym_planner/routes/welcome_screen.dart';
import 'package:daily_gym_planner/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../trainer/meals/MealCategories.dart';
import '../trainer/settings/Settings.dart';

class RiverMenu extends StatelessWidget {
  const RiverMenu({
    Key? key,
    required this.userName,
    this.selectedSection = 'Home',
  }) : super(key: key);

  final String userName;
  final String selectedSection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: primaryColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoCard(
                name: userName,
              ),
              const Divider(),
              SideMenuIcons(
                selectedSection: selectedSection,
                onHomeSelected: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TrainerHome()));
                },
                onClientsSelected: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ClientsList()));
                },
                onMealsSelected: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CategoryList()));
                },
                onWorkoutSelected: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WorkoutList()));
                },
                onTodaySelected: () {
                  // TODO: Navigate to Today page.
                },
                onSettingsSelected: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Settings()));
                },
                onLogoutSelected: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget{
  const InfoCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white30,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.black,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(color: secondColor),
      ),
    );
  }
}

class SideMenuIcons extends StatelessWidget {
  const SideMenuIcons({
    Key? key,
    required this.selectedSection,
    required this.onHomeSelected,
    required this.onClientsSelected,
    required this.onMealsSelected,
    required this.onWorkoutSelected,
    required this.onTodaySelected,
    required this.onSettingsSelected,
    required this.onLogoutSelected,
  }) : super(key: key);

  final String selectedSection;
  final VoidCallback onHomeSelected;
  final VoidCallback onClientsSelected;
  final VoidCallback onMealsSelected;
  final VoidCallback onWorkoutSelected;
  final VoidCallback onTodaySelected;
  final VoidCallback onSettingsSelected;
  final VoidCallback onLogoutSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          'Home',
          Icons.home,
          selectedSection == 'Home',
          onHomeSelected,
        ),
        _buildMenuItem(
          context,
          'Clients',
          Icons.people,
          selectedSection == 'Clients',
          onClientsSelected,
        ),
        _buildMenuItem(
          context,
          'Meals',
          Icons.restaurant,
          selectedSection == 'Meals',
          onMealsSelected,
        ),
        _buildMenuItem(
          context,
          'Workout',
          Icons.fitness_center,
          selectedSection == 'Workout',
          onWorkoutSelected,
        ),
        // TODO: Resolve this when you'll implement Today
        // _buildMenuItem(
        //   context,
        //   'Today',
        //   Icons.calendar_today,
        //   selectedSection == 'Today',
        //   onTodaySelected,
        // ),
        const Divider(color: accentColor),
        _buildMenuItem(
          context,
          'Settings',
          Icons.settings,
          selectedSection == 'Settings',
          onSettingsSelected,
        ),
        _buildMenuItem(
          context,
          'Logout',
          Icons.logout,
          selectedSection == 'Logout',
          onLogoutSelected,
        ),
      ],
    );
  }
}

Widget _buildMenuItem(BuildContext context, String title, IconData icon, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 3, color: isSelected ? accentColor : Colors.transparent),
        ),
        color: isSelected ? Colors.white.withOpacity(0.1) : null,
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ]
            : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? accentColor : Colors.white,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? accentColor : Colors.white,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
