import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Duration duration;

  const TimerWidget({Key? key, required this.duration}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late Duration _remainingDuration;

  @override
  void initState() {
    super.initState();
    _remainingDuration = widget.duration;
    _timer = Timer.periodic(Duration(seconds: 1), _decrementDuration);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _decrementDuration(Timer timer) {
    if (_remainingDuration == Duration.zero) {
      timer.cancel();
    } else {
      setState(() {
        _remainingDuration = _remainingDuration - Duration(seconds: 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_remainingDuration.inDays}d:${_remainingDuration.inHours % 24}h:${_remainingDuration.inMinutes % 60}m:${_remainingDuration.inSeconds % 60}s left',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
