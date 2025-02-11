import 'package:flutter/material.dart';

class CustomSlideTransition extends StatefulWidget {
  final Widget child;
  final AnimationType animationType;
  final Duration animationDuration;
  final Curve curve;

  const CustomSlideTransition({
    super.key,
    required this.child,
    required this.animationType,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.curve = Curves.ease,
  });

  @override
  CustomSlideTransitionState createState() => CustomSlideTransitionState();
}

class CustomSlideTransitionState extends State<CustomSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    print('SLIDE INIT');
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _controller.reset();
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
    return _slideTransition(
      _animation,
      widget.child,
      animationType: widget.animationType,
    );
  }
}

/// slider transition
SlideTransition _slideTransition(
  Animation<double> animation,
  Widget child, {
  required AnimationType animationType,
}) {
  Offset begin;

  switch (animationType) {
    case AnimationType.rightToLeft:
      begin = const Offset(1.0, 0.0);
      break;
    case AnimationType.leftToRight:
      begin = const Offset(-1.0, 0.0);
      break;
    case AnimationType.topToBottom:
      begin = const Offset(0.0, -1.0);
      break;
    case AnimationType.bottomToTop:
      begin = const Offset(0.0, 1.0);
  }

  const Offset end = Offset.zero;
  const Cubic curve = Curves.ease;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

enum AnimationType {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}
