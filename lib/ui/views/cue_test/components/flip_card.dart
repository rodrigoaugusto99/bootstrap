import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({Key? key}) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _flipped = !_flipped),
      child: Cue.onToggle(
        toggled: _flipped,
        motion: const CueMotion.smooth(),
        acts: const [Act.flipY()],
        child: Container(
          width: 160,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.tertiary,
              ],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.style, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
