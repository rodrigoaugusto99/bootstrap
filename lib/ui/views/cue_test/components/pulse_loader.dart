import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class PulseLoader extends StatelessWidget {
  const PulseLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Cue.onMount(
              repeat: true,
              reverseOnRepeat: true,
              motion: const CueMotion.gentle(),
              child: Actor(
                delay: Duration(milliseconds: 180 * i),
                acts: const [
                  Act.scale(from: 0.5, to: 1.0),
                  Act.fadeIn(from: 0.3, motion: CueMotion.smooth()),
                ],
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
