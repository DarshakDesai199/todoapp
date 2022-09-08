import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/button.dart';
import 'package:todoapp/common/text.dart';
import 'package:todoapp/controller/controller.dart';
import 'package:todoapp/view/home_screen/home_screen.dart';
import '../../../common/app_colors.dart';
import '../../../common/sizes.dart';
import '../../../constant.dart';

class DetailScreen extends StatefulWidget {
  final String? taskNames, taskPriority, hour, minute, discription, performer;
  final bool? isUpdate;
  final String? id, subId;
  final int? mainTab, planTab;

  const DetailScreen({
    Key? key,
    this.taskNames,
    this.taskPriority,
    this.hour,
    this.minute,
    this.discription,
    this.performer,
    this.isUpdate,
    this.id,
    this.mainTab,
    this.planTab,
    this.subId,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final taskName = TextEditingController();

  final taskDescription = TextEditingController();

  final taskPerformer = TextEditingController();

  final taskPriorityNumber = TextEditingController();

  final taskHour = TextEditingController();

  final taskMinute = TextEditingController();
  bool? x;
  int? main;
  int? plan;

  SubDetailController subDetailController = Get.put(SubDetailController());
  @override
  initState() {
    taskName.text = widget.taskNames!;
    taskDescription.text = widget.discription!;
    taskPriorityNumber.text = widget.taskPriority!;
    taskHour.text = widget.hour!;
    taskMinute.text = widget.minute!;
    taskPerformer.text = widget.performer!;
    x = widget.isUpdate!;
    main = widget.mainTab;
    plan = widget.planTab;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              child: Image.asset(
                'assets/images/Back.png',
                height: 21.h,
                width: 24.w,
              ),
            ),
          ],
        ),
        title: Ts(
          text: 'My Task',
          size: 22.h,
          weight: FontWeight.w600,
        ),
        actions: [
          if (x == false)
            Row(
              children: [
                IconButton(
                  splashRadius: 20,
                  onPressed: () async {
                    setState(() {
                      x = !x!;
                    });
                    if (main == 0) {
                      await mainTaskCollection
                          .doc(widget.id)
                          .update({'isUpdate': x});
                    } else if (plan == 1) {
                      await dailyPlanCollection
                          .doc(widget.id)
                          .update({'isUpdate': x});
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 25.h,
                    color: AppColor.white,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                IconButton(
                  splashRadius: 20,
                  onPressed: () async {
                    Get.dialog(
                      AlertDialog(
                        title: Ts(
                          text: 'Are You Sure?',
                          size: 20.h,
                          weight: FontWeight.w700,
                        ),
                        content: Ts(
                          text: 'This Task Delete Permanently!',
                          size: 16.h,
                        ),
                        actions: [
                          Button(
                            buttonName: 'No',
                            onTap: () {
                              Get.back();
                            },
                            buttonColor: AppColor.blue,
                          ),
                          Button(
                            buttonName: 'YES',
                            onTap: () async {
                              if (main == 1) {
                                await mainTaskCollection
                                    .doc(widget.id)
                                    .delete();
                              } else if (plan == 0) {
                                await dailyPlanCollection
                                    .doc(widget.id)
                                    .delete();
                              } else if (subDetailController
                                      .selectSubDetail.value ==
                                  true) {
                                await mainTaskCollection
                                    .doc(widget.id)
                                    .collection('MainSub.1')
                                    .doc(widget.subId)
                                    .delete();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content:
                                      Ts(text: 'Task Delete Successfully!'),
                                ),
                              );
                              Get.back();
                              Get.back();
                            },
                            buttonColor: AppColor.blue,
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 25.h,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
        ],
      ),
      backgroundColor: AppColor.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Sizes.h25,
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 48.w, right: 48.w, top: 48.h),
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.h),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Ts(
                      text: 'Name',
                      size: 22.h,
                    ),
                    TextField(
                      controller: taskName,
                      enabled: x,
                      style: TextStyle(fontSize: 16.h),
                    ),
                    Sizes.h40,
                    Ts(
                      text: 'Priority Number',
                      size: 22.h,
                    ),
                    TextField(
                      controller: taskPriorityNumber,
                      enabled: x,
                      style: TextStyle(fontSize: 16.h),
                    ),
                    Sizes.h40,
                    Ts(
                      text: 'Amount of Time',
                      size: 22.h,
                    ),
                    Sizes.h10,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Ts(
                                text: 'Hour',
                                size: 20.h,
                              ),
                              TextField(
                                enabled: x,
                                textAlign: TextAlign.center,
                                controller: taskHour,
                                style: TextStyle(fontSize: 16.h),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 43.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Ts(
                                text: 'Minute',
                                size: 20.h,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (int.parse(value!) > 60) {
                                    return 'Enter lessThan 60 Minute';
                                  }
                                },
                                enabled: x,
                                textAlign: TextAlign.center,
                                controller: taskMinute,
                                style: TextStyle(fontSize: 16.h),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Sizes.h40,
                    Ts(
                      text: 'Description',
                      size: 22.h,
                    ),
                    TextField(
                      enabled: x,
                      controller: taskDescription,
                      style: TextStyle(fontSize: 16.h),
                    ),
                    Sizes.h40,
                    Ts(
                      text: 'Who does the task?',
                      size: 22.h,
                    ),
                    TextField(
                      enabled: x,
                      controller: taskPerformer,
                      style: TextStyle(fontSize: 16.h),
                    ),
                    Sizes.h17,
                    if (x == true)
                      Align(
                        alignment: Alignment.center,
                        child: Button(
                          height: 50.h,
                          width: 119.w,
                          fontSize: 18.h,
                          buttonName: 'Update',
                          onTap: () {
                            setState(() {
                              x = false;
                            });

                            if (main == 1) {
                              updateTask();
                            } else if (plan == 0) {
                              updatePlan();
                            } else if (subDetailController
                                    .selectSubDetail.value ==
                                true) {
                              updateSubTask();
                            }

                            Get.back();
                          },
                          buttonColor: AppColor.blue,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  updateTask() async {
    {
      await mainTaskCollection.doc(widget.id).update(
        {
          'isUpdate': x,
          'Hour': taskHour.text,
          'Minute': taskMinute.text,
          'description': taskDescription.text,
          'name': taskName.text,
          'performer': taskPerformer.text,
          'priority': int.parse(taskPriorityNumber.text)
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Ts(text: 'Task Update Successfully!'),
        ),
      );
    }
  }

  updateSubTask() async {
    mainTaskCollection
        .doc(widget.id)
        .collection('MainSub.1')
        .doc(widget.subId)
        .update(
      {
        'isUpdate': x,
        'Hour': taskHour.text,
        'Minute': taskMinute.text,
        'description': taskDescription.text,
        'name': taskName.text,
        'performer': taskPerformer.text,
        'priority': int.parse(taskPriorityNumber.text)
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Ts(text: 'Task Update Successfully!'),
      ),
    );
    // Get.back();
  }

  updatePlan() async {
    await dailyPlanCollection.doc(widget.id).update(
      {
        'isUpdate': x,
        'Hour': taskHour.text,
        'Minute': taskMinute.text,
        'description': taskDescription.text,
        'name': taskName.text,
        'performer': taskPerformer.text,
        'priority': int.parse(taskPriorityNumber.text)
      },
    );

    Get.back();
  }
}
