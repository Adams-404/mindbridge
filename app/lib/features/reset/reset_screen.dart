import 'package:flutter/material.dart';

import '../../core/widgets.dart';
import '../../core/theme.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _running) _controller.reverse();
      if (status == AnimationStatus.dismissed && _running) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _running = !_running);
    if (_running) {
      _controller.forward();
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'A SMALL PAUSE',
          title: 'Find a slower\nrhythm.',
          subtitle: 'If it feels comfortable, take a moment to follow the circle. You can stop whenever you like.',
        ),
        const SizedBox(height: 35),
        Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = 0.78 + (_controller.value * .22);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE7EDE4),
                    border: Border.all(color: MindBridgeTheme.forest, width: 1.2),
                    boxShadow: const [BoxShadow(color: Color(0xFFD8D2C4), blurRadius: 0, offset: Offset(6, 6))],
                  ),
                  child: Center(
                    child: Text(
                      !_running ? 'take a\npause' : (_controller.value < .5 ? 'breathe\nin' : 'breathe\nout'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, height: 1.2, fontWeight: FontWeight.w600, color: MindBridgeTheme.forest),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 38),
        Center(
          child: FilledButton.icon(
            onPressed: _toggle,
            icon: Icon(_running ? Icons.stop_rounded : Icons.play_arrow_rounded),
            label: Text(_running ? 'Stop exercise' : 'Begin gently'),
          ),
        ),
        const SizedBox(height: 20),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'There is no target to reach here. If focusing on your breathing feels uncomfortable, stop and return to whatever feels comfortable for you.',
              style: TextStyle(fontSize: 12, height: 1.6, color: MindBridgeTheme.muted),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const SafetyNote(compact: true),
      ],
    );
  }
}
