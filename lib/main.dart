import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MainScreen(),
        '/alarm': (context) => LiveClock(),
      },
      initialRoute: '/',
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1826),
      body: Center(
        child: Image(
          image: AssetImage('images/main_image.png'),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/alarm');
          },
          child: Text(
            'Get Start!',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFE3C7FF),
            onPrimary: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }
}

class AlarmSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1826),
      appBar: AppBar(
        title: Text('Set Alarm', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1B1826),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Text(
          '8:00',
          style: TextStyle(color: Colors.white, fontSize: 100),
        ),
      ),
    );
  }
}


class LiveClock extends StatefulWidget {
  @override
  _LiveClockState createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  String _timeString = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final String formattedDateTime = _formatDateTime(DateTime.now());
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1826),
      appBar: AppBar(
        title: Text('Live Clock'),
      ),
      body: Center(
        child: Text(
          _timeString,
          style: TextStyle(
              color: Colors.white,
              fontSize: 110
          ),
        ),
      ),
    );
  }
}