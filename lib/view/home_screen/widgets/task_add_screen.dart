import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/app_colors.dart';
import 'package:todoapp/common/button.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/common/text.dart';
import 'package:todoapp/constant.dart';
import 'package:todoapp/controller/controller.dart';

class TaskScreen extends StatefulWidget {
  final String? subMainId, subPlanId;
  final int? mainTab, mainPlan, length;
  final num? totalHour, totalMinute;

  TaskScreen({
    Key? key,
    this.subMainId,
    this.mainTab,
    this.subPlanId,
    this.mainPlan,
    this.totalHour,
    this.length,
    this.totalMinute,
  }) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final taskName = TextEditingController();
  final taskDescription = TextEditingController();
  final taskPerformer = TextEditingController();
  final priorityNumber = TextEditingController();

  final taskHour = TextEditingController();
  final taskMinute = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SubController subController = Get.put(SubController());
  List<Map<String, dynamic>> time = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue,
        centerTitle: true,
        elevation: 0,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(
                'assets/images/Vector.svg',
                height: 21.h,
                width: 24.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
        title: Ts(
          text: 'New Task',
          size: 24.h,
          weight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColor.blue,
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Sizes.h21,
            Expanded(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.h),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 43.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Sizes.h46,

                        /// Task Name
                        Ts(
                          text: 'Name',
                          size: 18.h,
                        ),
                        TextFormField(
                          style: TextStyle(
                              fontSize: 17.h,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Mulish'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter TaskName';
                            }
                          },
                          controller: taskName,
                        ),
                        if (widget.mainPlan != 0) Sizes.h40,
                        if (widget.mainPlan != 0)

                          /// Priority
                          Ts(
                            text: 'Priority Number',
                            size: 18.h,
                          ),
                        if (widget.mainPlan != 0)
                          TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 17.h,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Mulish'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter priorityNumber';
                              }
                            },
                            controller: priorityNumber,
                          ),
                        Sizes.h40,

                        /// Time
                        Ts(
                          text: 'Amount of Time',
                          size: 18.h,
                        ),
                        Sizes.h10,
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Ts(
                                    text: 'Hours',
                                    size: 18.h,
                                  ),
                                  TextFormField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: 17.h,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Mulish'),
                                    validator: (value) {
                                      if (widget.mainTab == 0) {
                                      } else {
                                        if (value!.isEmpty) {
                                          return 'Enter Hour';
                                        }
                                      }
                                    },
                                    controller: taskHour,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 43.w,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Ts(
                                    text: 'Minute',
                                    size: 18.h,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17.h,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Mulish'),
                                    validator: (value) {
                                      if (widget.mainTab == 0) {
                                      } else {
                                        if (value!.isEmpty) {
                                          return 'Enter minute';
                                        }
                                      }
                                    },
                                    controller: taskMinute,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        /// Description
                        Sizes.h40,
                        Ts(
                          text: 'Description',
                          size: 18.h,
                        ),
                        TextFormField(
                          style: TextStyle(
                              fontSize: 17.h,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Mulish'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Discription';
                            }
                          },
                          controller: taskDescription,
                        ),
                        Sizes.h35,

                        /// Task Performer
                        Ts(
                          text: 'Who does the task?',
                          size: 18.h,
                        ),
                        TextField(
                          style: TextStyle(
                              fontSize: 17.h,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Mulish'),
                          controller: taskPerformer,
                        ),
                        Sizes.h64,
                        Align(
                          alignment: Alignment.center,
                          child: Button(
                            fontSize: 18.h,
                            height: 46.h,
                            width: 204.w,
                            buttonName: 'Create Task',
                            onTap: () {
                              if (widget.mainTab == 1) {
                                createTask();
                              } else if (widget.mainPlan == 0) {
                                createPlan();
                              } else if (subController.selectSub.value ==
                                  true) {
                                createSubTask();
                              } else if (subController.selectSub.value ==
                                  false) {
                                createSubPlan();
                              }
                            },
                            buttonColor: AppColor.blue,
                          ),
                        ),
                        Sizes.h21,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// subtask
  createSubTask() async {
    DocumentReference doc =
        mainTaskCollection.doc(widget.subMainId).collection('MainSub.1').doc();

    if (formKey.currentState!.validate()) {
      await doc.set({
        'name': taskName.text,
        // 'priority': widget.length! + 1,
        'priority': int.parse(priorityNumber.text),
        'Hour': taskHour.text,
        'Minute': taskMinute.text,
        'description': taskDescription.text,
        'performer': taskPerformer.text,
        'isSelect': false,
        'isUpdate': false,
        'isDelete': false,
        'uid': doc.id,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Ts(text: 'Task Added Susseccfully')));
      Get.back();
    }
  }

  /// subPlan
  createSubPlan() async {
    DocumentReference doc =
        dailyPlanCollection.doc(widget.subPlanId).collection('plan.1').doc();

    await doc.set({
      'name': taskName.text,
      'priority': int.parse(priorityNumber.text),
      'Hour': taskHour.text,
      'Minute': taskMinute.text,
      'description': taskDescription.text,
      'performer': taskPerformer.text,
      'isSelect': false,
      'isUpdate': false,
      'isDelete': false,
      'uid': doc.id
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Ts(text: 'Task Added Susseccfully')));
    Get.back();
  }

  ///  task
  createTask() async {
    DocumentReference doc = mainTaskCollection.doc();

    if (formKey.currentState!.validate()) {
      await doc.set({
        'name': taskName.text,
        'priority': int.parse(priorityNumber.text),
        'Hour': taskHour.text,
        'Minute': taskMinute.text,
        'description': taskDescription.text,
        'performer': taskPerformer.text,
        'isSelect': false,
        'isUpdate': false,
        'isDelete': false,
        'uid': doc.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1),
          content: Ts(text: 'Task Added Susseccfully')));
      Get.back();
    }
  }

  /// plan
  createPlan() async {
    if (formKey.currentState!.validate()) {
      DocumentReference doc = dailyPlanCollection.doc();
      await doc.set({
        'name': taskName.text,
        'priority': widget.length! + 1,
        'Hour': taskHour.text,
        'Minute': taskMinute.text,
        'description': taskDescription.text,
        'performer': taskPerformer.text,
        'isSelect': false,
        'isUpdate': false,
        'isDelete': false,
        'uid': doc.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Ts(text: 'Task Added Susseccfully')));
      Get.back();
    }
  }
}
