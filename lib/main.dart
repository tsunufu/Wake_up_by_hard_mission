import 'package:flutter/material.dart';
import 'widgets/time_picker.dart';
import 'controllers/time_picker_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MainScreen(),
        '/set_alarm': (context) => AlarmSettingScreen(),
        '/wake_up': (context) => WakeUpScreen(),
        '/qr_scan': (context) => QRScanScreen(),
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
          image: AssetImage('assets/images/main_image.png'),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/set_alarm');
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
  final _controller = TimePickerController();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimePicker(controller: _controller),
            IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: resetTime,
            ),
            ElevatedButton(
              child: Text('Set Alarm'),
              onPressed: () => setAlarm(context),
            ),
            ElevatedButton(
              child: Text('Stop Alarm'),
              onPressed: () => stopAlarm(context),
            ),
          ],
        ),
      ),
    );
  }

  void resetTime() {
    _controller.setTime(DateTime.now());
  }

  Future<void> setAlarm(BuildContext context) async {
    final now = DateTime.now();
    final selectedHour = _controller.hour;
    final selectedMinute = _controller.minute;
    final dateTime = DateTime(now.year, now.month, now.day, selectedHour, selectedMinute);

    final alarmSettings = AlarmSettings(
      id: 0,
      dateTime: dateTime,
      assetAudioPath: 'assets/musics/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      fadeDuration: 3.0,
      notificationTitle: 'Alarm',
      notificationBody: 'Wake Up!',
      enableNotificationOnKill: true,
    );

    try {
      await Alarm.set(alarmSettings: alarmSettings);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarm set for $selectedHour:$selectedMinute')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set alarm: $e')),
      );
    }
  }

  Future<void> stopAlarm(BuildContext context) async {
    try {
      await Alarm.stop(0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarm stopped')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop alarm: $e')),
      );
    }
  }
}

class WakeUpScreen extends StatelessWidget {
  final _controller = TimePickerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1826),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                'Scan QR Code',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/qr_scan');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFD4E9E4),
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        fit: BoxFit.contain,
        controller: MobileScannerController(
          // facing: CameraFacing.back,
          // torchEnabled: false,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) =>
                  Image(image: MemoryImage(image)),
            );
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.pop(context);
            });
          }
        },
      ),
    );
  }
}

