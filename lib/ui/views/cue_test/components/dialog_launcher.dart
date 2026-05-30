import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class DialogLauncher extends StatelessWidget {
  const DialogLauncher({Key? key}) : super(key: key);

  void _open(BuildContext context) {
    showCueDialog(
      context: context,
      motion: const CueMotion.bouncy(),
      reverseMotion: const CueMotion.snappy(),
      builder: (context) => Actor(
        acts: const [
          Act.fadeIn(motion: CueMotion.smooth()),
          Act.slideY(from: 0.15),
          Act.scale(from: 0.85),
        ],
        child: AlertDialog(
          title: const Text('Diálogo animado'),
          content: const Text(
            'Esta entrada foi dirigida por uma rota do cue (showCueDialog).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => _open(context),
      icon: const Icon(Icons.open_in_new),
      label: const Text('Abrir diálogo'),
    );
  }
}
