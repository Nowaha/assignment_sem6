import 'package:flutter/material.dart';

class Shakeable extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double intensity;

  const Shakeable({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.intensity = 8,
  });

  @override
  ShakeableState createState() => ShakeableState();
}

class ShakeableState extends State<Shakeable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0, end: -widget.intensity),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.intensity, end: widget.intensity),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.intensity, end: -widget.intensity),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.intensity, end: widget.intensity),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.intensity, end: 0),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  void shake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
