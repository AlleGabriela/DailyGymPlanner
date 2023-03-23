import 'package:daily_gym_planner/core/app_export.dart';
import 'package:daily_gym_planner/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FirstAppPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.purple900,
        body: Container(
          width: double.maxFinite,
          padding: getPadding(
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: getMargin(
                    left: 22,
                    top: 62,
                  ),
                  decoration: AppDecoration.txtOutlineBlack9003f,
                  child: Text(
                    "Daily",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtLoraRomanRegular48,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: getMargin(
                    left: 96,
                  ),
                  decoration: AppDecoration.txtOutlineBlack9003f,
                  child: Text(
                    "Gym",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtLoraRomanRegular48,
                  ),
                ),
              ),
              Container(
                margin: getMargin(
                  right: 41,
                ),
                decoration: AppDecoration.txtOutlineBlack9003f,
                child: Text(
                  "Planner",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtLoraRomanRegular48,
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgEllipse3,
                height: getVerticalSize(
                  281,
                ),
                width: getHorizontalSize(
                  285,
                ),
                radius: BorderRadius.circular(
                  getHorizontalSize(
                    142,
                  ),
                ),
                alignment: Alignment.center,
                margin: getMargin(
                  top: 9,
                ),
              ),
              Spacer(),
              Container(
                height: getVerticalSize(
                  43,
                ),
                width: getHorizontalSize(
                  208,
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    CustomImageView(
                      svgPath: ImageConstant.imgRectangle1,
                      height: getVerticalSize(
                        43,
                      ),
                      width: getHorizontalSize(
                        208,
                      ),
                      alignment: Alignment.center,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: getMargin(
                          left: 65,
                        ),
                        decoration: AppDecoration.txtOutlineBlack9003f,
                        child: Text(
                          "LOG IN",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtLoraRomanRegular20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                height: getVerticalSize(
                  41,
                ),
                width: getHorizontalSize(
                  208,
                ),
                text: "SIGN IN",
                margin: getMargin(
                  top: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}