import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/constants.dart';

Stack listItems(String title, String imageUrl, IconData icon, Color iconColor) {
  return Stack(
    children: [
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover
          ),
        ),
      ),
      Positioned(
          bottom:0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                ),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent
                    ]
                )
            ),
          )
      ),
      Positioned(
        bottom: 0,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    color: iconColor,
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      // Icons.info
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  ),
                )
              ],
            )
        ),
      )
    ],
  );
}

Stack listItemsUsingImageAsset(String title, String imageUrl, IconData icon, Color iconColor) {
  return Stack(
    children: [
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
              imageUrl,
              fit: BoxFit.cover
          ),
        ),
      ),
      Positioned(
        bottom:0,
        left: 0,
        right: 0,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              ),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent
                  ]
              )
          ),
        )
      ),
      Positioned(
        bottom: 0,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  color: iconColor,
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    // Icons.info
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25
                ),
              )
            ],
          )
        ),
      )
    ],
  );
}

Stack listItemsWithoutImage(String title, IconData icon, Color iconColor) {
  return Stack(
    children: [
      Positioned.fill(
        bottom:0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xff552586),
                    Color(0xff6A359C),
                    Color(0xff804FB3),
                    Color(0xff9969C7),
                    Color(0xffB589D6),
                  ]
              )
          ),
        )
      ),
      Positioned(
        bottom: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container (
            width: 350,
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    color: iconColor,
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 200,
                  child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  )
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            )
          )
        ),
      )
    ],
  );
}

Container listClientsAndTrainer(String photo, String name, String email, String location) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.all(15),
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      color: lightLila,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: (photo == '') ? const AssetImage('assets/images/user.png') as ImageProvider : NetworkImage(photo),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: $name",
                style: const TextStyle(
                  color: buttonTextColor,
                  fontSize: questionSize,
                  fontFamily: font2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "E-mail: $email",
                style: const TextStyle(
                  color: buttonTextColor,
                  fontSize: questionSize,
                  fontFamily: font2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Location: $location",
                style: const TextStyle(
                  color: buttonTextColor,
                  fontSize: questionSize,
                  fontFamily: font2,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
