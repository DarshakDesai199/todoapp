import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/app_colors.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/common/text.dart';
import '../../../common/dismiss.dart';
import '../../../constant.dart';
import '../../../controller/controller.dart';
import '../widgets/details_screen.dart';
import '../widgets/note_task_screen.dart';
import '../widgets/sub_task_screen.dart';
import '../widgets/task_add_screen.dart';

class MainTask extends StatefulWidget {
  const MainTask({Key? key}) : super(key: key);

  @override
  State<MainTask> createState() => _MainTaskState();
}

class _MainTaskState extends State<MainTask>
    with SingleTickerProviderStateMixin {
  TaskSelectController taskSelectController = Get.put(TaskSelectController());
  ViewController viewController = Get.put(ViewController());

  TabsController tabsController = Get.put(TabsController());
  SubController subController = Get.put(SubController());
  TabController? tabController;
  List type = [Icons.list, Icons.widgets_outlined];
  @override
  initState() {
    tabController = TabController(length: type.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.blue,
        onPressed: () {
          Get.to(() => TaskScreen(
                mainTab: tabsController.selectedTab.value,
              ));
        },
        child: Icon(
          Icons.add,
          size: 30.h,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(7.h),
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            height: 55.h,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.h),
              color: AppColor.lightBlue,
            ),
            child: TabBar(
              unselectedLabelColor: AppColor.grey500,
              indicator: BoxDecoration(
                color: AppColor.blue,
                borderRadius: BorderRadius.circular(10.h),
              ),
              controller: tabController,
              onTap: (value) {
                viewController.selectedView(value);
              },
              tabs: List.generate(type.length, (index) => Icon(type[index])),
            ),
          ),
          Sizes.h17,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Ts(
              text: 'Tasks',
              size: 26.h,
              weight: FontWeight.w600,
            ),
          ),
          Sizes.h17,
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                StreamBuilder(
                  stream: mainTaskCollection
                      .orderBy('priority', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 14.h),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var info = snapshot.data?.docs[index];
                          return Column(
                            children: [
                              Sizes.h5,
                              Dismissible(
                                background: dismiss1(),
                                onDismissed: (value) {
                                  mainTaskCollection
                                      .doc(info?.id)
                                      .delete()
                                      .then(
                                        (value) => ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Ts(
                                                text:
                                                    'Task Delete Successfully!'),
                                          ),
                                        ),
                                      );
                                },
                                key: ValueKey(info?.id),
                                child: Container(
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
                                    padding: EdgeInsets.only(
                                        right: 21.w, left: 17.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            taskSelectController
                                                .selectedTask(index);
                                            Get.to(
                                              () => NoteScreen(
                                                id: info!.id,
                                                mainTab: tabsController
                                                    .selectedTab.value,
                                              ),
                                            );
                                          },
                                          child: Obx(
                                            () => Icon(
                                              Icons.list,
                                              size: 22.h,
                                              color: taskSelectController
                                                          .selectTask.value ==
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
                                                  mainTab: tabsController
                                                      .selectedTab.value,
                                                  taskNames:
                                                      '${info?.get('name')}',
                                                  taskPriority:
                                                      '${info?.get('priority')}',
                                                  hour: '${info?.get('Hour')}',
                                                  minute:
                                                      '${info?.get('Minute')}',
                                                  discription:
                                                      '${info?.get('description')}',
                                                  performer:
                                                      '${info?.get('performer')}',
                                                  isUpdate:
                                                      info?.get('isUpdate'),
                                                  id: snapshot
                                                      .data?.docs[index].id,
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 21.w, right: 17.w),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Ts(
                                                  overFlow:
                                                      TextOverflow.ellipsis,
                                                  text:
                                                      '${info?.get('priority')} . ${info?.get('name')}',
                                                  size: 18.h,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            subController.selectedSub();
                                            print(
                                                subController.selectSub.value);
                                            Get.to(
                                              () => SubTaskScreen(
                                                mainTaskId: snapshot
                                                    .data?.docs[index].id,
                                              ),
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
                              ),
                              Sizes.h5,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Ts(
                                    overFlow: TextOverflow.ellipsis,
                                    text:
                                        'Time : ${info?.get('Hour')} : ${info?.get('Minute')}',
                                    size: 12.h,
                                    weight: FontWeight.w600,
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
                StreamBuilder(
                  stream: mainTaskCollection
                      .orderBy('priority', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        itemCount: snapshot.data?.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.w,
                          crossAxisSpacing: 20.w,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          var mainInfo = snapshot.data?.docs[index];
                          return GestureDetector(
                            onTap: () async {
                              Get.to(() => DetailScreen(
                                    taskNames: '${mainInfo?.get('name')}',
                                    taskPriority:
                                        '${mainInfo?.get('priority')}',
                                    hour: '${mainInfo?.get('Hour')}',
                                    minute: '${mainInfo?.get('Minute')}',
                                    discription:
                                        '${mainInfo?.get('description')}',
                                    performer: '${mainInfo?.get('performer')}',
                                    isUpdate: mainInfo?.get('isUpdate'),
                                    id: snapshot.data?.docs[index].id,
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.h),
                                  color: Colors.white,
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
                                  ]),
                              padding: EdgeInsets.all(10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Ts(
                                    text:
                                        '${mainInfo?.get('priority')} . ${mainInfo?.get('name')}',
                                    size: 16.h,
                                    weight: FontWeight.w700,
                                    maxLine: 2,
                                    overFlow: TextOverflow.ellipsis,
                                  ),
                                  Sizes.h5,
                                  Ts(
                                    text: '${mainInfo?.get('description')}',
                                    weight: FontWeight.w600,
                                    maxLine: 5,
                                    overFlow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Ts(
                                      text:
                                          'Time : ${mainInfo?.get('Hour')} : ${mainInfo?.get('Minute')} hours',
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
