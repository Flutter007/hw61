import 'package:flutter/material.dart';

class RingScreen extends StatefulWidget {
  const RingScreen({super.key});

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int count = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      reverseDuration: Duration(seconds: 1),
      value: 0.5,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && count < 6) {
        count++;
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed && count < 6) {
        count++;
        _animationController.forward();
      } else if (count == 6) {
        _animationController.stop();
        _animationController.value = 0.5;
      }
    });
  }

  void runAnimation() {
    count = 0;
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ring Notification'),
        backgroundColor: theme.colorScheme.errorContainer,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          child: IconButton(
            onPressed: runAnimation,
            icon: Icon(
              Icons.notifications_active,
              size: 160,
              color: theme.colorScheme.error,
            ),
          ),
          builder:
              (ctx, child) => RotationTransition(
                alignment: Alignment.topCenter,
                turns: Tween<double>(begin: -0.09, end: 0.09).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.linear,
                    reverseCurve: Curves.linear.flipped,
                  ),
                ),
                child: child,
              ),
        ),
      ),
    );
  }
}
