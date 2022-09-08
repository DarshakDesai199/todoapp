import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoapp/common/text.dart';

class Button extends StatelessWidget {
  final double? height, width, fontSize;
  final String buttonName;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final GestureTapCallback onTap;
  final Color buttonColor;
  final Color? fontColor;
  Button({
    Key? key,
    this.height,
    this.width,
    required this.buttonName,
    required this.onTap,
    required this.buttonColor,
    this.fontSize,
    this.fontFamily = 'Mulish',
    this.fontWeight = FontWeight.w700,
    this.fontColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: buttonColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.h))),
        onPressed: onTap,
        child: Ts(
          text: buttonName,
          size: fontSize,
          weight: fontWeight,
          family: fontFamily!,
          color: fontColor,
        ),
      ),
    );
  }
}
