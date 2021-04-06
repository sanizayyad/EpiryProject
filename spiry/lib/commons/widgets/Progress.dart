import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  final value;
  final color;

  const Progress({this.value,this.color});

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> with TickerProviderStateMixin{
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _animation = Tween(begin: 0.0, end: widget.value).animate(_controller)
      ..addListener(() {
        setState(() {
        });
      });
    _controller.forward();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value:_animation.value,
      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation<Color>(widget.color),
    );
  }
}
