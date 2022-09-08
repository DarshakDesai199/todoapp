import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todoapp/common/app_colors.dart';
import 'package:todoapp/common/button.dart';
import 'package:todoapp/common/sizes.dart';
import 'package:todoapp/common/text.dart';
import 'package:todoapp/controller/controller.dart';
import '../../../constant.dart';

class NoteScreen extends StatefulWidget {
  final String? id, mainId;
  final int? mainTab, planTab, subId;

  const NoteScreen(
      {Key? key,
      required this.id,
      this.mainTab,
      this.planTab,
      this.mainId,
      this.subId})
      : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController add = TextEditingController();
  SubController subController = Get.put(SubController());
  SubNoteController subNoteController = Get.put(SubNoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue,
        title: Text('Note'),
        leading: GestureDetector(
            onTap: () {
              subNoteController.deselectedSub();
              Get.back();
              print(subNoteController.selectSubNote.value);
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.mainTab == 1
                    ? mainTaskCollection
                        .doc(widget.id)
                        .collection('MainNotes.1')
                        .orderBy('date_time', descending: true)
                        .snapshots()
                    : widget.subId == 1
                        ? mainTaskCollection
                            .doc(widget.mainId)
                            .collection('MainSub.1')
                            .doc(widget.id)
                            .collection('MainSubNotes.2')
                            .orderBy('date_time', descending: true)
                            .snapshots()
                        : dailyPlanCollection
                            .doc(widget.id)
                            .collection('dailyNote.1')
                            .orderBy('date_time', descending: true)
                            .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var info1 = snapshot.data?.docs[index];
                        bool change = info1?.get('isCheked');

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                change = !change;
                              });

                              if (widget.mainTab == 1) {
                                await mainTaskCollection
                                    .doc(widget.id)
                                    .collection('MainNotes.1')
                                    .doc(info1?.id)
                                    .update({'isCheked': change});
                              } else if (widget.planTab == 0) {
                                await dailyPlanCollection
                                    .doc(widget.id)
                                    .collection('dailyNote.1')
                                    .doc(info1?.id)
                                    .update({'isCheked': change});
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 22.h,
                                  width: 22.h,
                                  decoration: BoxDecoration(
                                    color: change == true
                                        ? AppColor.blue
                                        : Colors.transparent,
                                    border: Border.all(color: AppColor.blue),
                                    borderRadius: BorderRadius.circular(4.h),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.done,
                                      color: change == true
                                          ? AppColor.white
                                          : Colors.transparent,
                                      size: 18.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Ts(
                                  text: '${info1?.get('name')}',
                                  size: 18.h,
                                ),
                                Spacer(),
                                if (change == true)
                                  Button(
                                    buttonName: 'Delete',
                                    onTap: () async {
                                      Get.dialog(
                                        AlertDialog(
                                          title: Ts(
                                            text: 'Are You Sure?',
                                            size: 20.h,
                                            weight: FontWeight.w700,
                                          ),
                                          content: Ts(
                                            text:
                                                'This Task Delete Perminetly!',
                                            size: 16.h,
                                          ),
                                          actions: [
                                            Button(
                                              buttonName: 'YES',
                                              onTap: () async {
                                                if (widget.mainTab == 1) {
                                                  await mainTaskCollection
                                                      .doc(widget.id)
                                                      .collection('MainNotes.1')
                                                      .doc(snapshot
                                                          .data?.docs[index].id)
                                                      .delete();
                                                } else if (widget.planTab ==
                                                    0) {
                                                  await dailyPlanCollection
                                                      .doc(widget.id)
                                                      .collection('dailyNote.1')
                                                      .doc(snapshot
                                                          .data?.docs[index].id)
                                                      .delete();
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Ts(
                                                        text:
                                                            'Task Delete Susseccfully'),
                                                  ),
                                                );
                                                Get.back();
                                              },
                                              buttonColor: AppColor.blue,
                                            ),
                                            Button(
                                              buttonName: 'No',
                                              onTap: () {
                                                Get.back();
                                              },
                                              buttonColor: AppColor.blue,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    buttonColor: AppColor.blue,
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            TextField(
              style: TextStyle(fontSize: 22.h),
              decoration: InputDecoration(hintText: 'Add Note'),
              controller: add,
            ),
            Sizes.h25,
            Button(
              height: 54.h,
              width: 205.w,
              buttonName: 'Add',
              onTap: () {
                if (add.text.isEmpty) {
                  print('Add Task');
                } else if (widget.mainTab == 1) {
                  mainNoteAdded();
                } else if (widget.planTab == 0) {
                  dailyNoteAdded();
                } else if (widget.subId == 1) {
                  mainSubNoteAdded();
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Ts(text: 'Task Added Successfully')));
              },
              buttonColor: AppColor.blue,
              fontSize: 18.h,
            ),
            Sizes.h25
          ],
        ),
      ),
    );
  }

  void mainNoteAdded() async {
    await mainTaskCollection.doc(widget.id).collection('MainNotes.1').add(
      {'name': add.text, 'isCheked': false, "date_time": DateTime.now()},
    );
    add.clear();
  }

  void mainSubNoteAdded() async {
    await mainTaskCollection
        .doc(widget.mainId)
        .collection('MainSub.1')
        .doc(widget.id)
        .collection('MainSubNotes.2')
        .add(
      {'name': add.text, 'isCheked': false, "date_time": DateTime.now()},
    );
    add.clear();
  }

  void dailyNoteAdded() async {
    await dailyPlanCollection.doc(widget.id).collection('dailyNote.1').add(
      {'name': add.text, 'isCheked': false, "date_time": DateTime.now()},
    );
    add.clear();
  }
}
