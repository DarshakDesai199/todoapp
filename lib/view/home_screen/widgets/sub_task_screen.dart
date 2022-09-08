import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/common/text.dart';
import 'package:todoapp/controller/controller.dart';
import 'package:todoapp/view/home_screen/widgets/note_task_screen.dart';
import '../../../common/app_colors.dart';
import '../../../common/dismiss.dart';
import '../../../constant.dart';
import 'details_screen.dart';
import 'task_add_screen.dart';

class SubTaskScreen extends StatefulWidget {
  final String? mainTaskId;

  const SubTaskScreen({
    Key? key,
    this.mainTaskId,
  }) : super(key: key);

  @override
  State<SubTaskScreen> createState() => _SubTaskScreenState();
}

class _SubTaskScreenState extends State<SubTaskScreen> {
  SubController subController = Get.put(SubController());
  SubPlanSelectController subPlanSelectController =
      Get.put(SubPlanSelectController());
  SubNoteController subNoteController = Get.put(SubNoteController());
  SubDetailController subDetailController = Get.put(SubDetailController());

  var hour = [];
  var minute = [];
  final controller = ScrollController();
  List<Map<String, dynamic>> time = [];
  num x = 0;
  num y = 0;

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
              onTap: () async {
                await mainTaskCollection.doc(widget.mainTaskId).update(time[0]);

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
      body: StreamBuilder(
        stream: mainTaskCollection
            .doc(widget.mainTaskId)
            .collection('MainSub.1')
            .orderBy('priority', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            hour.clear();
            minute.clear();
            time.clear();
            print('HOUR :- $hour');
            print('HOUR :- $minute');
            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              hour.add(int.parse(snapshot.data!.docs[i].get('Hour')));
            }
            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              minute.add(int.parse(snapshot.data!.docs[i].get('Minute')));
            }
            x = 0;
            y = 0;
            print('List ;  - $hour');
            print('List ;  - $minute');
            for (var data in hour) {
              x += data;
            }
            for (var data in minute) {
              num a = y += data;
              if (a > 60) {
                x++;
                y = a - 60;
              }
            }
            print(x);
            print(y);

            time.add(
              {'Hour': x, 'Minute': y},
            );
            print(
              'Map:- $time',
            );
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var subInfo = snapshot.data?.docs[index];

                      return Column(
                        children: [
                          Dismissible(
                            background: dismiss(),
                            key: ValueKey(subInfo?.id),
                            onDismissed: (val) {
                              mainTaskCollection
                                  .doc(widget.mainTaskId)
                                  .collection('MainSub.1')
                                  .doc(subInfo?.id)
                                  .delete()
                                  .then(
                                    (value) => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Ts(
                                            text: 'Task Delete Successfully!'),
                                      ),
                                    ),
                                  );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 17.h, left: 14.w, right: 14.w),
                              height: 60.h,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.h),
                                color: AppColor.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 2,
                                    color: AppColor.grey500.withAlpha(100),
                                  ),
                                  BoxShadow(
                                    offset: Offset(-2, -2),
                                    blurRadius: 2,
                                    color: AppColor.grey500.withAlpha(100),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 17.w, right: 21.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        subPlanSelectController
                                            .selectedSubPlan(index);
                                        subNoteController.selectedSub();
                                        print(subNoteController
                                            .selectSubNote.value);
                                        Get.to(
                                          () => NoteScreen(
                                              id: snapshot.data?.docs[index].id,
                                              mainId: widget.mainTaskId,
                                              subId: subNoteController
                                                  .selectSubNote.value),
                                        );
                                      },
                                      icon: Obx(
                                        () => Icon(
                                          Icons.list,
                                          size: 22.h,
                                          color: subPlanSelectController
                                                      .selectSubPlan.value ==
                                                  index
                                              ? AppColor.blue
                                              : AppColor.grey500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          subDetailController.selectedSub();

                                          Get.to(
                                            () => DetailScreen(
                                              taskNames:
                                                  '${subInfo!.get('name')}',
                                              taskPriority:
                                                  '${subInfo.get('priority')}',
                                              hour: '${subInfo.get('Hour')}',
                                              minute:
                                                  '${subInfo.get('Minute')}',
                                              discription:
                                                  '${subInfo.get('description')}',
                                              performer:
                                                  '${subInfo.get('performer')}',
                                              isUpdate: subInfo.get('isUpdate'),
                                              id: widget.mainTaskId,
                                              subId:
                                                  snapshot.data?.docs[index].id,
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 21.w, right: 17.w),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Ts(
                                              overFlow: TextOverflow.ellipsis,
                                              text:
                                                  '${subInfo!.get('priority')} . ${subInfo.get('name')}',
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
                                        height: 20.h,
                                        width: 20.h,
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
                                    ),
                                  ],
                                ),
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
                                    'Time : ${subInfo.get('Hour')}:${subInfo.get('Minute')}',
                                size: 12.h,
                                color: AppColor.grey500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.blue,
        onPressed: () {
          Get.to(
            () => TaskScreen(
              subMainId: widget.mainTaskId,
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 25.h,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
