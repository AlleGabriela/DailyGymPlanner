import 'package:flutter/material.dart';
import '../../../util/constants.dart';

class MealDetails extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String description;
  final double timeInMinutes;
  final double timeInHours;

  const MealDetails({Key? key, required this.title, required this.description, this.imageUrl, required this.timeInMinutes, required this.timeInHours}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String timeOfPreparationMessage = "Timp de preparare: ";
    if (timeInHours == 0) {
      timeOfPreparationMessage += "${timeInMinutes.toInt()} minute";
    } else if (timeInHours == 1) {
      timeOfPreparationMessage += "o ora si ${timeInMinutes.toInt()} minute";
    } else {
      timeOfPreparationMessage += "${timeInHours.toInt()} ore si ${timeInMinutes.toInt()} minute";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
              imageUrl!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            )
                : Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                timeOfPreparationMessage,
                style: const TextStyle(color: primaryColor, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

