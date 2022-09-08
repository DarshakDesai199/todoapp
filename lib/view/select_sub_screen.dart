import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/button.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/common/text.dart';

import '../common/app_colors.dart';
import '../constant.dart';

class SubSelectScreen extends StatefulWidget {
  final String? mainTaskId;
  const SubSelectScreen({Key? key, this.mainTaskId}) : super(key: key);

  @override
  State<SubSelectScreen> createState() => _SubSelectScreenState();
}

class _SubSelectScreenState extends State<SubSelectScreen> {
  // SubController subController = Get.put(SubController());
  // String? name;
  // String? priority;
  // String? hour;
  // String? min;
  // String? description;
  // String? performer;
  // bool? delete;
  // bool? update;
  // bool? select;
  DocumentReference doc = dailyPlanCollection.doc();

  String? id;
  bool? unSelect;
  List<Map<String, dynamic>> subData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
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
              ),
            ),
          ],
        ),
        title: Ts(
          text: 'Task',
          size: 24.h,
          color: Colors.black,
          weight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          Sizes.h46,
          Expanded(
            child: StreamBuilder(
              stream: mainTaskCollection
                  .doc(widget.mainTaskId)
                  .collection('MainSub.1')
                  .orderBy('priority', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var info = snapshot.data?.docs;
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool selectTask = info![index].get('isSelect');
                      return Column(
                        children: [
                          Sizes.h5,
                          Container(
                            margin: EdgeInsets.only(left: 14.w, right: 14.w),
                            height: 68.h,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.h),
                              color: AppColor.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(2, 2),
                                  blurRadius: 2,
                                  color: AppColor.grey500.withAlpha(100),
                                ),
                                BoxShadow(
                                  offset: const Offset(-2, -2),
                                  blurRadius: 2,
                                  color: AppColor.grey500.withAlpha(100),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 17.w, right: 21.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        selectTask = !selectTask;
                                        unSelect = selectTask;
                                      });
                                      print('selectTask :- $selectTask');
                                      await mainTaskCollection
                                          .doc(widget.mainTaskId)
                                          .collection('MainSub.1')
                                          .doc(snapshot.data?.docs[index].id)
                                          .update({'isSelect': selectTask});
                                      if (unSelect == true) {
                                        subData.add({
                                          "uid": doc.id,
                                          "name": info[index].get('name'),
                                          "priority":
                                              info[index].get('priority'),
                                          "Hour": info[index].get('Hour'),
                                          "Minute": info[index].get('Minute'),
                                          "description":
                                              info[index].get('description'),
                                          "performer":
                                              info[index].get('performer'),
                                          "isSelect":
                                              info[index].get('isSelect'),
                                          "isUpdate":
                                              info[index].get('isUpdate'),
                                          "isDelete":
                                              info[index].get('isDelete')
                                        });
                                      } else {
                                        subData.removeAt(index);
                                      }
                                    },
                                    child: Container(
                                      height: 30.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                        color: selectTask == true
                                            ? AppColor.blue
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColor.blue,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.done,
                                        size: 15.h,
                                        color: selectTask == true
                                            ? AppColor.white
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 21.w, right: 17.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Ts(
                                            overFlow: TextOverflow.ellipsis,
                                            text: '${info[index].get('name')}',
                                            size: 18.h,
                                            weight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 22.h,
                                      width: 22.h,
                                      decoration: BoxDecoration(
                                        color: AppColor.blue,
                                        borderRadius:
                                            BorderRadius.circular(4.h),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white,
                                          size: 15.h,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Sizes.h5,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Ts(
                                text:
                                    'Time : ${info[index].get('Hour')}:${info[index].get('Minute')}',
                                size: 12.h,
                                color: AppColor.grey500,
                              ),
                            ),
                          ),
                          Sizes.h17,
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Button(
            height: 46.h,
            width: 204.w,
            fontSize: 18.h,
            buttonName: 'Select Task',
            onTap: () async {
              if (unSelect == true) {
                selectSubTask();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Ts(text: 'Select Any One!')));
              }
            },
            buttonColor: AppColor.blue,
          ),
          Sizes.h30,
        ],
      ),
    );
  }

  void selectSubTask() {
    subData.forEach((element) async {
      await dailyPlanCollection.add(element).whenComplete(
            () => Get.back(),
          );
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Ts(text: 'Task Added Successfully!')));
  }
}
