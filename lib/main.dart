import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // for bluetooth

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLE POC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EpochAndBluetooth(),
    );
  }
}

class EpochAndBluetooth extends StatefulWidget {
  const EpochAndBluetooth({super.key});

  @override
  _EpochAndBluetooth createState() => _EpochAndBluetooth();
}

class _EpochAndBluetooth extends State<EpochAndBluetooth> {

  // initialise global variables
  int _epochTimestamp = 0;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  bool isBluetoothOn = false;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;


  Timer? _timer;

  @override


  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });

    _startTimer();
  }

  @override


  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _startTimer() async {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_adapterState == BluetoothAdapterState.on) {
          setState(() {
            _epochTimestamp = DateTime.now().millisecondsSinceEpoch;
          });
        }
      });
  }


  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(_epochTimestamp);

    Widget screen = _adapterState == BluetoothAdapterState.on
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          _epochTimestamp.toString(),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          dateTime.toString(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    )
        : Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'OFF',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Status'),
        ),
        body: screen,
      ),
    );
  }


}


