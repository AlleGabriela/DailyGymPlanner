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
                      borderRadius: BorderRadius.only(
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
                      SizedBox(width: 10),
                      Text(title,
                        style: TextStyle(
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
                borderRadius: BorderRadius.only(
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
                SizedBox(width: 10),
                Text(title,
                  style: TextStyle(
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
