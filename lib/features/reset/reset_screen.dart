import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets.dart';
import '../../core/theme.dart';

enum _Exercise { breathing, grounding, bodyPause }

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  _Exercise _exercise = _Exercise.breathing;
  bool _running = false;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _running && !_paused) {
        HapticFeedback.lightImpact();
        _controller.reverse();
      }
      if (status == AnimationStatus.dismissed && _running && !_paused) {
        HapticFeedback.lightImpact();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectExercise(_Exercise exercise) {
    HapticFeedback.selectionClick();
    setState(() {
      _exercise = exercise;
      _running = false;
      _paused = false;
    });
    _controller.stop();
    _controller.reset();
  }

  void _startOrResume() {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    HapticFeedback.mediumImpact();
    setState(() {
      _running = true;
      _paused = false;
    });
    if (!reduceMotion && _exercise == _Exercise.breathing) {
      if (_controller.value == 0) {
        _controller.forward();
      } else {
        _controller.forward();
      }
    } else {
      _controller.stop();
    }
  }

  void _pause() {
    HapticFeedback.lightImpact();
    _controller.stop();
    setState(() => _paused = true);
  }

  void _stop() {
    HapticFeedback.lightImpact();
    _controller.stop();
    _controller.reset();
    setState(() {
      _running = false;
      _paused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final isBreathing = _exercise == _Exercise.breathing;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      children: [
        const PageHeading(
          eyebrow: 'A SMALL PAUSE',
          title: 'Find a slower\nrhythm.',
          subtitle: 'Choose a simple exercise, follow it only if it feels comfortable, and stop whenever you like.',
        ),
        const SizedBox(height: 24),
        Text('Choose an exercise', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _ExerciseChip(
              label: 'Breathing',
              selected: _exercise == _Exercise.breathing,
              onSelected: (_) => _selectExercise(_Exercise.breathing),
            ),
            _ExerciseChip(
              label: 'Grounding',
              selected: _exercise == _Exercise.grounding,
              onSelected: (_) => _selectExercise(_Exercise.grounding),
            ),
            _ExerciseChip(
              label: 'Body pause',
              selected: _exercise == _Exercise.bodyPause,
              onSelected: (_) => _selectExercise(_Exercise.bodyPause),
            ),
          ],
        ),
        const SizedBox(height: 32),
        if (isBreathing) ...[
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final animVal = CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeInOutSine,
                  ).value;

                  final scale = reduceMotion ? 1.0 : 0.80 + (animVal * 0.20);
                  final auraScale = reduceMotion ? 1.0 : 0.85 + (animVal * 0.28);
                  final phase = reduceMotion
                      ? 'breathe at\nyour own pace'
                      : (!_running
                          ? 'take a\npause'
                          : (_paused
                              ? 'paused'
                              : (_controller.value < .5 ? 'breathe\nin' : 'breathe\nout')));

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Calming outer atmospheric aura ring
                      if (!reduceMotion && _running && !_paused)
                        Transform.scale(
                          scale: auraScale,
                          child: Container(
                            width: 230,
                            height: 230,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MindBridgeTheme.forest.withValues(alpha: 0.08),
                              border: Border.all(
                                color: MindBridgeTheme.forest.withValues(alpha: 0.18),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      // Tactile neo-brutalist inner breathing core
                      Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE8EDE5),
                            border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
                            boxShadow: [
                              BoxShadow(
                                color: MindBridgeTheme.ink,
                                offset: Offset(3.5 + (animVal * 1.5), 3.5 + (animVal * 1.5)),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              phase,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.25,
                                fontWeight: FontWeight.w800,
                                color: MindBridgeTheme.forest,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            reduceMotion
                ? 'Reduced motion is on. The circle stays still; use the words as a gentle prompt, or ignore them and breathe naturally.'
                : 'Let the circle guide a comfortable pace. There is no need to take deep breaths or match it exactly.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ] else if (_exercise == _Exercise.grounding) ...[
          Text('Notice what is around you', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Move through these prompts at your own pace. You can skip any of them.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          const _PromptCard(number: '5', prompt: 'things you can see'),
          const _PromptCard(number: '4', prompt: 'things you can feel'),
          const _PromptCard(number: '3', prompt: 'things you can hear'),
          const _PromptCard(number: '2', prompt: 'things you can smell'),
          const _PromptCard(number: '1', prompt: 'thing you can taste, or a taste you remember'),
        ] else ...[
          Text('A moment to notice your body', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('There is no need to change anything. Simply notice, and leave out any prompt that does not feel right.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          const _PromptCard(number: '01', prompt: 'Notice where your feet meet the floor, or where your body is supported'),
          const _PromptCard(number: '02', prompt: 'Notice your shoulders. Let them rest if that feels comfortable'),
          const _PromptCard(number: '03', prompt: 'Notice your hands and the sensations around them'),
          const _PromptCard(number: '04', prompt: 'Look around and notice one thing that feels familiar'),
        ],
        const SizedBox(height: 24),
        if (isBreathing)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: [
              if (!_running)
                FilledButton.icon(
                  onPressed: _startOrResume,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Begin gently'),
                )
              else ...[
                OutlinedButton.icon(
                  onPressed: _paused ? _startOrResume : _pause,
                  icon: Icon(_paused ? Icons.play_arrow_rounded : Icons.pause_rounded),
                  label: Text(_paused ? 'Resume' : 'Pause'),
                ),
                FilledButton.icon(
                  onPressed: _stop,
                  icon: const Icon(Icons.stop_rounded),
                  label: const Text('Stop exercise'),
                ),
              ],
            ],
          )
        else
          Center(
            child: OutlinedButton.icon(
              onPressed: _stop,
              icon: const Icon(Icons.stop_rounded),
              label: const Text('Finish exercise'),
            ),
          ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MindBridgeTheme.paper,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
            boxShadow: MindBridgeTheme.neoShadowSmall,
          ),
          child: const Text(
            'These are optional self-guided pauses, not treatment or crisis support. If focusing inward or on your breathing feels uncomfortable, stop and return to an activity that feels comfortable for you.',
            style: TextStyle(fontSize: 12, height: 1.6, color: MindBridgeTheme.muted),
          ),
        ),
        const SizedBox(height: 16),
        const SafetyNote(compact: true),
      ],
    );
  }
}

class _ExerciseChip extends StatelessWidget {
  const _ExerciseChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: selected ? MindBridgeTheme.paper : MindBridgeTheme.ink,
        ),
      ),
      selected: selected,
      selectedColor: MindBridgeTheme.forest,
      backgroundColor: MindBridgeTheme.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: MindBridgeTheme.ink, width: 1.6),
      ),
      showCheckmark: false,
      onSelected: onSelected,
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.number, required this.prompt});

  final String number;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Container(
        decoration: BoxDecoration(
          color: MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
          boxShadow: MindBridgeTheme.neoShadowSmall,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF0E3D9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
              ),
              child: Text(
                number,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: MindBridgeTheme.clay),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                prompt,
                style: const TextStyle(fontSize: 13, height: 1.5, fontWeight: FontWeight.w600, color: MindBridgeTheme.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
