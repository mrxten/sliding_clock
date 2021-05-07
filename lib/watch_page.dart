import 'dart:async';

import 'package:column_watch/column_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WatchPage extends StatefulWidget {
  WatchPage({Key? key}) : super(key: key);

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> with WidgetsBindingObserver {
  Timer? _timer;
  late DateTime _dateTime;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _dateTime = DateTime.now();
    startTimer();
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        startTimer();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _timer?.cancel();
        _timer = null;
        break;
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (_) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDEDEDE),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              width: constraints.maxWidth,
              child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: constraints.maxHeight / 2 - 60),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      ColumnItem(
                        current: _dateTime.hour ~/ 10,
                        count: 3,
                      ),
                      SizedBox(width: 15),
                      ColumnItem(
                        current: _dateTime.hour % 10,
                        count: 10,
                      ),
                      SizedBox(width: 40),
                      ColumnItem(
                        current: _dateTime.minute ~/ 10,
                        count: 6,
                      ),
                      SizedBox(width: 15),
                      ColumnItem(
                        current: _dateTime.minute % 10,
                        count: 10,
                      ),
                      SizedBox(width: 40),
                      ColumnItem(
                        current: _dateTime.second ~/ 10,
                        count: 6,
                      ),
                      SizedBox(width: 15),
                      ColumnItem(
                        current: _dateTime.second % 10,
                        count: 10,
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
