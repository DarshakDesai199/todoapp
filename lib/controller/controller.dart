import 'package:get/get.dart';

class TabsController extends GetxController {
  var selectedTab = 0.obs;
  selectedTabs(value) {
    selectedTab.value = value;
  }
}

class Plan1SelectController extends GetxController {
  var selectedPlan = true.obs;
  selectedButton() {
    selectedPlan.value = true;
  }

  unSelectedButton() {
    selectedPlan.value = false;
  }
}

/// add subtask
class SubController extends GetxController {
  var selectSub = true.obs;
  selectedSub() {
    selectSub.value = true;
  }

  unSelectedSub() {
    selectSub.value = false;
  }
}

class SubNoteController extends GetxController {
  var selectSubNote = 0.obs;
  selectedSub() {
    selectSubNote.value = 1;
  }

  deselectedSub() {
    selectSubNote.value = 0;
  }
}

class SubDetailController extends GetxController {
  var selectSubDetail = true.obs;
  selectedSub() {
    selectSubDetail.value = true;
  }

  unSelectedSub() {
    selectSubDetail.value = false;
  }
}

class UpdateController extends GetxController {
  var updateTask = true.obs;
  updated() {
    updateTask.value = !updateTask.value;
  }

  notUpdated() {
    updateTask.value = false;
  }
}

class ViewController extends GetxController {
  var selectView = 0.obs;
  selectedView(value) {
    selectView.value = value;
  }
}

class TaskSelectController extends GetxController {
  var selectTask = 0.obs;
  selectedTask(index) {
    selectTask.value = index;
  }
}

class PlanSelectController extends GetxController {
  var selectPlan = 0.obs;
  selectedPlan(index) {
    selectPlan.value = index;
  }
}

class SubPlanSelectController extends GetxController {
  var selectSubPlan = 0.obs;
  selectedSubPlan(index) {
    selectSubPlan.value = index;
  }
}

class SelectController extends GetxController {
  var selectPlan = 0.obs;
  selectedPlan(index) {
    selectPlan.value = index;
  }
}
