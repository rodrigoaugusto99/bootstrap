import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class HoverCard extends StatelessWidget {
  const HoverCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Cue.onHover(
      motion: const CueMotion.spatial(),
      child: Actor(
        acts: [
          const Act.scale(to: 1.06),
          Act.colorTint(
            from: Colors.transparent,
            to: theme.colorScheme.primary.withValues(alpha: 0.14),
          ),
        ],
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.mouse, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              const Text('Passe o mouse (desktop/web)'),
            ],
          ),
        ),
      ),
    );
  }
}
