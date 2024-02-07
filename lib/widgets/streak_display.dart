import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakDisplay extends StatefulWidget {
  @override
  _StreakDisplayState createState() => _StreakDisplayState();
}

class _StreakDisplayState extends State<StreakDisplay> {
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _streak = prefs.getInt('streak') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFD4E9E4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$_streak days\n',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'success🔥',
              style: TextStyle(
                color: Color(0xFF9F9F9F),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}