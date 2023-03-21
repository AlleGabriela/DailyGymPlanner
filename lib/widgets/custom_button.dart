import 'package:daily_gym_planner/core/app_export.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {this.padding,
        this.variant,
        this.fontStyle,
        this.alignment,
        this.margin,
        this.onTap,
        this.width,
        this.height,
        this.text,
        this.prefixWidget,
        this.suffixWidget});

  ButtonPadding? padding;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;

  double? height;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment!,
      child: _buildButtonWidget(),
    )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shadowColor: _setTextButtonShadowColor(),
      shape: RoundedRectangleBorder(),
    );
  }

  _setPadding() {
    switch (padding) {
      default:
        return getPadding(
          all: 7,
        );
    }
  }

  _setColor() {
    switch (variant) {
      default:
        return ColorConstant.blueGray100;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      default:
        return BorderSide(
          color: ColorConstant.black900,
          width: getHorizontalSize(
            1.00,
          ),
        );
    }
  }

  _setTextButtonShadowColor() {
    switch (variant) {
      default:
        return ColorConstant.black9003f;
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      default:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            20,
          ),
          fontFamily: 'Lora',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.25,
          ),
        );
    }
  }
}

enum ButtonPadding {
  PaddingAll7,
}

enum ButtonVariant {
  Buttons,
}

enum ButtonFontStyle {
  LoraRomanRegular20,
}