import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/button.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/common/text.dart';
import 'package:todoapp/view/select_sub_screen.dart';
import '../common/app_colors.dart';
import '../constant.dart';

class SelectTaskScreen extends StatefulWidget {
  final String? id1;
  const SelectTaskScreen({Key? key, this.id1}) : super(key: key);

  @override
  State<SelectTaskScreen> createState() => _SelectTaskScreenState();
}

class _SelectTaskScreenState extends State<SelectTaskScreen> {
  var select;
  DocumentReference doc = dailyPlanCollection.doc();

  List<Map<String, dynamic>> data = [];

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
                // if (select != true) {
                //   await firebaseFirestore
                //       .collection('MainTask')
                //       .doc(subIds)
                //       .update({'isSelect': false});
                // }
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
                  .orderBy('priority', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                var info1 = snapshot.data?.docs;
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    itemCount: info1?.length,
                    itemBuilder: (BuildContext context, int index) {
                      // dataFromServer.forEach((element) {
                      //   if (dataFromServer.contains(info1![index].data())) {
                      //     selectMainTask.insert(index, true);
                      //     print('TRUE:+++');
                      //   } else {
                      //     selectMainTask.insert(index, false);
                      //     print('FALSE+++');
                      //   }
                      // });

                      // if (dataFromServer.contains(info1![index].data())) {
                      //   selectMainTask.insert(index, true);
                      //   print('TRUE:+++');
                      // } else {
                      //   selectMainTask.insert(index, false);
                      //   print('FALSE+++');
                      // }
                      bool selectMainTask = info1![index].get('isSelect');
                      return Column(
                        children: [
                          Sizes.h5,
                          Container(
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
                                        selectMainTask = !selectMainTask;
                                        select = selectMainTask;
                                      });

                                      await firebaseFirestore
                                          .collection('MainTask')
                                          .doc(snapshot.data?.docs[index].id)
                                          .update({'isSelect': selectMainTask});

                                      if (select == true) {
                                        // data = [];
                                        data.insert(index, {
                                          "uid": doc.id,
                                          "name": info1[index].get('name'),
                                          "priority":
                                              info1[index].get('priority'),
                                          "Hour": info1[index].get('Hour'),
                                          "Minute": info1[index].get('Minute'),
                                          "description":
                                              info1[index].get('description'),
                                          "performer":
                                              info1[index].get('performer'),
                                          "isSelect":
                                              info1[index].get('isSelect'),
                                          "isUpdate":
                                              info1[index].get('isUpdate'),
                                          "isDelete":
                                              info1[index].get('isDelete')
                                        });
                                      } else {
                                        data.remove(index);
                                      }
                                      print('LENGTH${data}');
                                    },
                                    child: Container(
                                      height: 30.h,
                                      width: 30.h,
                                      decoration: BoxDecoration(
                                        color: selectMainTask == true
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
                                        color: selectMainTask == true
                                            ? AppColor.white
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 17.w, right: 21.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Ts(
                                            overFlow: TextOverflow.ellipsis,
                                            text: '${info1[index].get('name')}',
                                            size: 18.h,
                                            weight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => SubSelectScreen(
                                            mainTaskId:
                                                snapshot.data?.docs[index].id),
                                      );
                                    },
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
                                    'Time : ${info1[index].get('Hour')}:${info1[index].get('Minute')}',
                                size: 12.h,
                                color: AppColor.grey500,
                              ),
                            ),
                          ),
                          Sizes.h17
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
            onTap: () {
              if (select == true) {
                selectTask();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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

  void selectTask() async {
    data.forEach(
      (element) async {
        await dailyPlanCollection.add(element).whenComplete(
              () => Get.back(),
            );
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Ts(text: 'Task Added Successfully!')));
  }
}
