import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stopwatch/ui/elapsed_time_text.dart';

class Stopwatch extends StatefulWidget {
  const Stopwatch({Key? key}) : super(key: key);

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  late DateTime _intialTime;
  Duration _elapsed = Duration.zero;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _intialTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final now = DateTime.now();
      setState(() {
        _elapsed = now.difference(_intialTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElapsedTimeText(
      elapsed: _elapsed,
    );
  }
}
