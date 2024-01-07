import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakeup_by_hard_mission/controllers/time_picker_controller.dart';


const double _kColumnWidths = 48.0;

class TimePicker extends StatefulWidget {
  const TimePicker({Key? key, required this.controller}) : super(key: key);

  final TimePickerController controller;

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHourPicker(),
        _buildSeparator(),
        _buildMinutePicker(),
      ],
    );
  }

Widget _buildHourPicker() {
  return _buildPicker(24, widget.controller.hourController);
}

Widget _buildMinutePicker() {
  return _buildPicker(60, widget.controller.minuteController);
}

Widget _buildPicker(int size, FixedExtentScrollController controller) {
  return SizedBox(
    width: _kColumnWidths * 1.2,
    height: 48,
    child: CupertinoPicker(
      backgroundColor: Color(0xFF1B1826),
      scrollController: controller,
      offAxisFraction: 0.45,
      itemExtent: 32,
      useMagnifier: true,
      magnification: 2.35 / 2.1,
      squeeze: 1.25,
      looping: true,
      onSelectedItemChanged: (_) {},
      children: List.generate(size, (int index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
                width: _kColumnWidths * 2
                , child: _buildLabel(context, index)),
          ),
        );
      }),
    ),
  );
}

Widget _buildLabel(BuildContext context, int number) {
  return Text(
    number.toString().padLeft(2, '0'),
    style: TextStyle(
      color: Colors.white,
      fontSize: 32,
    ),
  );
}

Widget _buildSeparator() {
  return const Text(' : ',
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500));
}

@override
void dispose() {
  widget.controller.dispose();
  super.dispose();
}
}


