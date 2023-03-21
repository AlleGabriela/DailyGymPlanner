import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    backgroundColor: Color(0xff54026e);
    body: Stack(
      children: [ ]
    )
    return Container(
      width: MediaQuery.of(context).size.width ,
      height: MediaQuery.of(context).size.height ,
      color: Color(0xff54026e),
      padding: const EdgeInsets.only(
        left: 32,
        right: 10,
        top: 125,
        bottom: 63,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Daily",
            style: TextStyle(
              color: Color(0xffe9fb00),
              fontSize: 48,
            ),
          ),
          SizedBox(height: 23.20),
          Text(
            "Gym",
            style: TextStyle(
              color: Color(0xffe9fb00),
              fontSize: 48,
            ),
          ),
          SizedBox(height: 23.20),
          Text(
            "Planner",
            style: TextStyle(
              color: Color(0xffe9fb00),
              fontSize: 48,
            ),
          ),
          SizedBox(height: 23.20),
          Container(
            width: 285,
            height: 281,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 285,
                  height: 281,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 285,
                        height: 281,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: FlutterLogo(size: 281),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 23.20),
          Container(
            width: 208,
            height: 43,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0x33000000),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
              color: Color(0xffd9d9d9),
            ),
            padding: const EdgeInsets.only(
              left: 65,
              right: 73,
              top: 8,
              bottom: 9,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "LOG IN",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 23.20),
          Container(
            width: 208,
            height: 41,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0x33000000), width: 1,),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
              color: Color(0xffd9d9d9),
            ),
            padding: const EdgeInsets.only(
              left: 65, right: 67, top: 7, bottom: 8,),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "SIGN IN",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
