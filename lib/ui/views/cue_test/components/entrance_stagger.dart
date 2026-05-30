import 'package:cue/cue.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

class EntranceStagger extends StatefulWidget {
  const EntranceStagger({Key? key}) : super(key: key);

  @override
  State<EntranceStagger> createState() => _EntranceStaggerState();
}

class _EntranceStaggerState extends State<EntranceStagger> {
  Key _key = UniqueKey();

  void _replay() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = [
      Colors.indigo,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];

    Widget entrance = Cue.onMount(
      key: _key,
      motion: const CueMotion.smooth(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < colors.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Actor(
                delay: Duration(milliseconds: 90 * i),
                acts: const [
                  Act.fadeIn(),
                  //Act.blur(from: 2),
                  //Act.colorTint(from: Colors.green, to: Colors.blue),
                  // Act.sizedClip(
                  //     from: NSize(w: 0, h: 48), to: NSize(w: 48, h: 48)),
                  Act.slideY(from: 0.6),
                  Act.scale(from: 0.6),
                ],
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: colors[i],
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // Scrubber de debug: aparece quando a animação completa.
    // O overlay é inserido no Overlay do app (canto inferior direito).
    if (kDebugMode) {
      entrance = CueDebugTools(
        alignment: Alignment.bottomRight,
        child: entrance,
      );
    }

    return Column(
      children: [
        entrance,
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _replay,
          icon: const Icon(Icons.replay),
          label: const Text('Repetir'),
          style:
              TextButton.styleFrom(foregroundColor: theme.colorScheme.primary),
        ),
      ],
    );
  }
}
