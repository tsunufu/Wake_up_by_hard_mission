import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MainScreen(),
        '/alarm': (context) => AlarmSettingScreen(),
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
