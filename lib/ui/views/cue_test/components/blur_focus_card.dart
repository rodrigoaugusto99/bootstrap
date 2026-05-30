import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class BlurFocusCard extends StatefulWidget {
  const BlurFocusCard({Key? key}) : super(key: key);

  @override
  State<BlurFocusCard> createState() => _BlurFocusCardState();
}

class _BlurFocusCardState extends State<BlurFocusCard> {
  bool _blurred = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Cue.onToggle(
          toggled: _blurred,
          motion: const CueMotion.smooth(),
          acts: const [Act.blur(from: 0, to: 9)],
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Conteúdo secreto 👀',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: () => setState(() => _blurred = !_blurred),
          child: Text(_blurred ? 'Revelar' : 'Esconder'),
        ),
      ],
    );
  }
}
