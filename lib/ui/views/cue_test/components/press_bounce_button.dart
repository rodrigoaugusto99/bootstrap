import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class PressBounceButton extends StatefulWidget {
  const PressBounceButton({Key? key}) : super(key: key);

  @override
  State<PressBounceButton> createState() => _PressBounceButtonState();
}

class _PressBounceButtonState extends State<PressBounceButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: Cue.onToggle(
        toggled: _pressed,
        motion: const CueMotion.snappy(),
        reverseMotion: const CueMotion.bouncy(),
        acts: const [Act.scale(to: 0.88)],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            'Segure aqui',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
