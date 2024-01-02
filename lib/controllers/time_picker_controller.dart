import 'package:flutter/cupertino.dart';

class TimePickerController {
  // コントローラーをプライベートから公開に変更
  final FixedExtentScrollController hourController;
  final FixedExtentScrollController minuteController;

  TimePickerController()
      : hourController = FixedExtentScrollController(initialItem: 0),
        minuteController = FixedExtentScrollController(initialItem: 0);

  void setTime(DateTime time) {
    hourController.animateToItem(time.hour,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    minuteController.animateToItem(time.minute,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  int get hour {
    if (!hourController.hasClients) {
      return 0;
    }
    return hourController.selectedItem % 24;
  }

  int get minute {
    if (!minuteController.hasClients) {
      return 0;
    }
    return minuteController.selectedItem % 60;
  }

  void dispose() {
    hourController.dispose();
    minuteController.dispose();
  }
}
