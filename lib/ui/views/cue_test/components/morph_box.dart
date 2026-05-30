import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class MorphBox extends StatefulWidget {
  const MorphBox({Key? key}) : super(key: key);

  @override
  State<MorphBox> createState() => _MorphBoxState();
}

class _MorphBoxState extends State<MorphBox> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _active = !_active),
      child: Cue.onToggle(
        toggled: _active,
        motion: const CueMotion.smooth(),
        child: Actor(
          acts: [
            Act.decorate(
              color: const AnimatableValue.tween(
                Colors.deepPurple,
                Colors.amber,
              ),
              borderRadius: AnimatableValue.tween(
                BorderRadius.circular(16),
                BorderRadius.circular(60),
              ),
            ),
            const ScaleAct.keyframed(
              frames: Keyframes([
                Keyframe(0.9),
                Keyframe(1.1, motion: CueMotion.bouncy()),
                Keyframe(1.0),
              ], motion: CueMotion.smooth()),
            ),
          ],
          child: const SizedBox(
            width: 120,
            height: 120,
            child: Icon(Icons.bolt, color: Colors.white, size: 44),
          ),
        ),
      ),
    );
  }
}
