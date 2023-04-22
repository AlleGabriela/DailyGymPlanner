import 'package:flutter/material.dart';
import '../../util/constants.dart';

class NewsDetails extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String description;

  const NewsDetails({Key? key, required this.title, required this.description, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}

