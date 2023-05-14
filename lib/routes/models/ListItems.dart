import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: 40,
                ),
            ],
          )
        ),
      )
    ],
  );
}

