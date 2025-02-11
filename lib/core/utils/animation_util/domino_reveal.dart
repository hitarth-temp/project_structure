import 'dart:async';

import 'package:flutter/material.dart';

// This function increments and returns a Duration
// The delay is reset when no new animations have been added for a short moment
//  (you can change the conditions of this to match your requirements)
Timer? _dominoReset;
Duration _dominoDelay = const Duration();

Duration _getDelay() {
  if (_dominoReset == null || !_dominoReset!.isActive) {
    _dominoReset = Timer(const Duration(milliseconds: 50), () {
      _dominoDelay = const Duration();
    });
  }
  _dominoDelay += const Duration(milliseconds: 50);
  return _dominoDelay;
}

class DominoReveal extends StatelessWidget {
  final Widget child;
  final bool isLeftToRight;
  final bool allowAnimation;

  const DominoReveal({
    super.key,
    required this.child,
    this.isLeftToRight = false,
    this.allowAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return allowAnimation
        ? _DelayedReveal(
            delay: _getDelay(),
            isLeftToRight: isLeftToRight,
            child: child,
          )
        : child;
  }
}

class _DelayedReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final bool isLeftToRight;

  const _DelayedReveal({
    required this.child,
    required this.delay,
    required this.isLeftToRight,
  });

  @override
  _DelayedRevealState createState() => _DelayedRevealState();
}

class _DelayedRevealState extends State<_DelayedReveal>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _timer = Timer(widget.delay, _controller.forward);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: widget.isLeftToRight
                ? // left to right
                Offset(-(1 - _animation.value) * 20.0, 0)
                :
                // bottom to up
                Offset(0.0, (1 - _animation.value) * 20.0),
            child: child,
          ),
        );
      },
    );
  }
}
