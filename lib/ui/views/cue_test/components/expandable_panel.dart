import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class ExpandablePanel extends StatefulWidget {
  const ExpandablePanel({Key? key}) : super(key: key);

  @override
  State<ExpandablePanel> createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Cue.onToggle(
        toggled: _expanded,
        motion: const CueMotion.smooth(),
        reverseMotion: const CueMotion.snappy(),
        child: Column(
          children: [
            ListTile(
              title: const Text('O que é o cue?'),
              trailing: const Actor(
                acts: [Act.rotate(to: 180)],
                child: Icon(Icons.expand_more),
              ),
              onTap: () => setState(() => _expanded = !_expanded),
            ),
            Actor(
              acts: [
                const Act.clipHeight(fromFactor: 0, toFactor: 1),
                Act.fadeIn(delay: 80.ms),
              ],
              child: const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  'Uma biblioteca de animações physics-first com API '
                  'declarativa baseada em timeline. Você descreve o gatilho '
                  '(Cue), o widget (Actor) e o efeito (Act).',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
