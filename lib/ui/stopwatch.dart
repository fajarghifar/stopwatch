import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stopwatch/ui/reset_button.dart';
import 'package:stopwatch/ui/start_stop_button.dart';
import 'package:stopwatch/ui/stopwatch_renderer.dart';

class Stopwatch extends StatefulWidget {
  const Stopwatch({Key? key}) : super(key: key);

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch>
    with SingleTickerProviderStateMixin {
  Duration _previousElapsed = Duration.zero;
  Duration _currentElapsed = Duration.zero;
  Duration get _elapsed => _previousElapsed + _currentElapsed;
  bool _isRunning = false;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _currentElapsed = elapsed;
      });
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _ticker.start();
      } else {
        _ticker.stop();
        _previousElapsed += _currentElapsed;
        _currentElapsed = Duration.zero;
      }
    });
  }

  void _reset() {
    _ticker.stop();
    setState(() {
      _isRunning = false;
      _previousElapsed = Duration.zero;
      _currentElapsed = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = constraints.maxWidth / 2;
        return Stack(
          children: [
            StopwatchRenderer(
              elapsed: _elapsed,
              radius: radius,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 80,
                height: 80,
                child: ResetButton(
                  onPressed: _reset,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 80,
                height: 80,
                child: StartStopButton(
                  isRunning: _isRunning,
                  onPressed: _toggleRunning,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
