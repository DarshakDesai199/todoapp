import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/app_colors.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/common/text.dart';
import 'package:todoapp/controller/controller.dart';
import 'daily_planning/daily_planing_screen.dart';
import 'main_task/main_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<String> tabs = ['Daily planning ', 'Main Task'];
  TabsController tabsController = Get.put(TabsController());

  TabController? tabController;
  @override
  initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Sizes.h50,
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
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(6.h),
                color: AppColor.blue,
              ),
              onTap: (value) {
                tabsController.selectedTabs(value);
              },
              controller: tabController,
              tabs: List.generate(
                tabs.length,
                (index) => Ts(
                  text: tabs[index],
                  size: 18.h,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Sizes.h29,
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                DailyPlaning(),
                MainTask(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
