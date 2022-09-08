import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/app_colors.dart';
import 'package:todoapp/common/button.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/controller/controller.dart';
import 'package:todoapp/view/home_screen/widgets/note_task_screen.dart';
import 'package:todoapp/view/select_task_screen.dart';
import '../../../common/dismiss.dart';
import '../../../common/text.dart';
import '../../../constant.dart';
import '../widgets/details_screen.dart';
import '../widgets/task_add_screen.dart';

class DailyPlaning extends StatefulWidget {
  const DailyPlaning({Key? key}) : super(key: key);

  @override
  State<DailyPlaning> createState() => _DailyPlaningState();
}

class _DailyPlaningState extends State<DailyPlaning> {
  PlanSelectController planSelectController = Get.put(PlanSelectController());
  Plan1SelectController plan1selectController =
      Get.put(Plan1SelectController());
  TabsController tabsController = Get.put(TabsController());
  SubController subController = Get.put(SubController());
  List reorder = [];
  int? newInd;
  var doc;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Obx(
                  () => Button(
                    height: 37.h,
                    width: 119.w,
                    buttonName: 'Select Task',
                    onTap: () {
                      plan1selectController.unSelectedButton();
                    },
                    buttonColor:
                        plan1selectController.selectedPlan.value == false
                            ? AppColor.blue
                            : AppColor.lightBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                    fontColor: plan1selectController.selectedPlan.value == false
                        ? AppColor.white
                        : AppColor.grey500,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Obx(
                  () => Button(
                    height: 37.h,
                    width: 130.w,
                    buttonName: 'Regular Task',
                    onTap: () {
                      plan1selectController.selectedButton();
                    },
                    buttonColor:
                        plan1selectController.selectedPlan.value == true
                            ? AppColor.blue
                            : AppColor.lightBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                    fontColor: plan1selectController.selectedPlan.value == true
                        ? AppColor.white
                        : AppColor.grey500,
                  ),
                ),
              ],
            ),
          ),
          Sizes.h39,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Ts(
              text: 'Task',
              size: 26.h,
              weight: FontWeight.w600,
            ),
          ),
          Sizes.h17,
          Expanded(
            child: StreamBuilder(
              stream: dailyPlanCollection
                  .orderBy('priority', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  reorder = [];
                  for (var i = 0; i < snapshot.data!.docs.length; i++) {
                    print('Empty List:-${snapshot.data!.docs[i].get('name')}');

                    reorder.add({
                      'name': snapshot.data!.docs[i].get('name'),
                      "priority": snapshot.data!.docs[i].get('priority'),
                      "Hour": snapshot.data!.docs[i].get('Hour'),
                      "Minute": snapshot.data!.docs[i].get('Minute'),
                      "description": snapshot.data!.docs[i].get('description'),
                      "performer": snapshot.data!.docs[i].get('performer'),
                      "isSelect": snapshot.data!.docs[i].get('isSelect'),
                      "isUpdate": snapshot.data!.docs[i].get('isUpdate'),
                      "isDelete": snapshot.data!.docs[i].get('isDelete'),
                      "uid": snapshot.data!.docs[i].id,
                      'index': i
                    });
                  }

                  print('Item Added List:-$reorder');

                  return ReorderableListView.builder(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 14.w),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data?.docs[index];
                      return Dismissible(
                        background: Padding(
                          padding: EdgeInsets.only(bottom: 17.h),
                          child: dismiss1(),
                        ),
                        key: ValueKey(data?.id),
                        onDismissed: (val) {
                          dailyPlanCollection.doc(data?.id).delete().then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 1),
                                    content:
                                        Ts(text: 'Task Delete Successfully!'),
                                  ),
                                ),
                              );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 17.h),
                          child: Container(
                            key: ValueKey(reorder[index]),
                            // margin: EdgeInsets.only(bottom: 17.h),
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
                              padding: EdgeInsets.only(right: 21.w, left: 17.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      planSelectController.selectPlan(index);
                                      Get.to(
                                        () => NoteScreen(
                                          id: data!.id,
                                          planTab:
                                              tabsController.selectedTab.value,
                                        ),
                                      );
                                    },
                                    child: Obx(
                                      () => Icon(
                                        Icons.list,
                                        size: 22.h,
                                        color: planSelectController
                                                    .selectPlan.value ==
                                                index
                                            ? AppColor.blue
                                            : AppColor.grey500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => DetailScreen(
                                            planTab: tabsController
                                                .selectedTab.value,
                                            taskNames:
                                                '${reorder[index]['name']}',
                                            taskPriority:
                                                '${reorder[index]['priority']}',
                                            hour: '${reorder[index]['Hour']}',
                                            minute:
                                                '${reorder[index]['Minute']}',
                                            discription:
                                                '${reorder[index]['description']}',
                                            id: reorder[index]['uid'],
                                            performer:
                                                '${reorder[index]['performer']}',
                                            isUpdate: reorder[index]
                                                ['isUpdate'],
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
                                            text: '${reorder[index]!['name']}',
                                            size: 18.h,
                                            weight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5.h),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Ts(
                                        text:
                                            'Time : ${reorder[index]!['Hour']} : ${reorder[index]!['Minute']}',
                                        size: 12.h,
                                        color: AppColor.grey500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onReorder: (oldIndex, newIndex) async {
                      setState(
                        () {
                          newInd =
                              newIndex > oldIndex ? newIndex - 1 : newIndex;
                          final user = reorder.removeAt(oldIndex);
                          print('Remove Task===>>>$user');
                          reorder.insert(newInd!, user);
                          print('New Reorder : - $reorder');
                          print('NEWIND : - $newInd');
                          print('OLDINDEX : - $oldIndex');
                          for (var x = 0; x < reorder.length; x++) {
                            dailyPlanCollection
                                .doc(reorder[reorder[x]['index']]['uid'])
                                .update({
                              'priority': reorder[x]['index'],
                            });
                          }
                        },
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.blue,
        onPressed: () {
          if (plan1selectController.selectedPlan.value == false) {
            Get.to(() => const SelectTaskScreen());
          } else {
            Get.to(
              () => TaskScreen(
                length: reorder.length,
                mainPlan: tabsController.selectedTab.value,
              ),
            );
          }
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
