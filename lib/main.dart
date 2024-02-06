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
        '/qr_scan': (context) => QRScanPage(),
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'welcome to sleep!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/title_image.png'),
                  ),
                ),
              ),
              Text(
                'Sleep Better\nWake up Happier',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'もう2度寝して後悔する生活はやめよう',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 36),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/set_alarm');
                },
                child: Text(
                  'Get Start!',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA630),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 5.0,
                  shadowColor: Colors.black,
                ),
              ),
              SizedBox(height: 32),
            ],
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
    final dateTime =
        DateTime(now.year, now.month, now.day, selectedHour, selectedMinute);

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
    var size = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // 背景画像
          // Positioned.fill(
          //   child: Image.asset(
          //     // 'assets/your_image.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // ヘッダー部分

          Positioned(
            top: 48, // ステータスバーの高さに応じて調整
            left: 16,
            child: SafeArea(
              child: Text(
                'Wake up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // QRコードスキャン部分
          Positioned(
            top: 200, // 位置は必要に応じて調整
            left: 16,
            right: 16,
            child: Column(
              children: [
                Text(
                  'Scan QR Code',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MobileScanner(
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
                ),
              ],
            ),
          ),
          // フッター部分
          Positioned(
            bottom: 48,
            left: 16,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Have a beautiful day!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    var hight_screen = MediaQuery.of(context).size.height;
    var width_screen = MediaQuery.of(context).size.width;

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

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (barcode) {
              final code = barcode.barcodes;
              if (code != null) {
                debugPrint('Barcode found! $code');
                cameraController.stop();
                stopAlarm(context);
                Navigator.pushNamed(context, '/set_alarm');
              }
            },
          ),
          Positioned(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: width_screen,
                    height: hight_screen / 2 - 150,
                    color: Colors.black.withOpacity(0.62),
                  ),
                ),
                Positioned(
                  top: hight_screen / 2 + 150,
                  left: 0,
                  child: Container(
                    width: width_screen,
                    height: hight_screen / 2 - 150,
                    color: Colors.black.withOpacity(0.62),
                  ),
                ),
                Positioned(
                  top: hight_screen / 2 - 150,
                  left: 0,
                  child: Container(
                    width: (width_screen - 300) / 2,
                    height: 300,
                    color: Colors.black.withOpacity(0.62),
                  ),
                ),
                Positioned(
                  top: hight_screen / 2 - 150,
                  left: width_screen / 2 + 150,
                  child: Container(
                    width: (width_screen - 300) / 2,
                    height: 300,
                    color: Colors.black.withOpacity(0.62),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, -0.65),
            child: Text(
              'Scan QR Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              // width: 300,
              // height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // 垂直方向に中央揃え
                crossAxisAlignment: CrossAxisAlignment.center, // 水平方向に中央揃え
                children: [
                  Container(
                    height: 50,
                    child: Text(
                      'Good Morning',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: hight_screen * 0.2,
                    child: Text(
                      'Have a beautiful day!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: hight_screen * 0.03, // ステータスバーの高さを加味
            left: 0,
            child: SafeArea(
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
                onPressed: () => Navigator.of(context).pop(), // 画面を閉じて前の画面に戻る
              ),
            ),
          ),
        ],
      ),
    );
  }
}
