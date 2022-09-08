import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget dismiss() {
  return Container(
    margin: EdgeInsets.only(
      top: 17.h,
      left: 14.w,
      right: 14.w,
    ),
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    height: 60.h,
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.h),
      color: Colors.red,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.delete,
          color: Colors.white,
        ),
        Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ],
    ),
  );
}

Widget dismiss1() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    height: 68.h,
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.h),
      color: Colors.red,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.delete,
          color: Colors.white,
        ),
        Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ],
    ),
  );
}
