import 'dart:math' as math;

import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class FabRadialMenu extends StatefulWidget {
  const FabRadialMenu({Key? key}) : super(key: key);

  @override
  State<FabRadialMenu> createState() => _FabRadialMenuState();
}

class _FabRadialMenuState extends State<FabRadialMenu> {
  bool _open = false;

  static const _items = <(IconData, Color)>[
    (Icons.edit, Colors.teal),
    (Icons.share, Colors.orange),
    (Icons.delete, Colors.redAccent),
    (Icons.favorite, Colors.pink),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = 92.0;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Cue.onToggle(
        toggled: _open,
        motion: const CueMotion.smooth(),
        reverseMotion: const CueMotion.smooth(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < _items.length; i++)
              _miniButton(theme, i, radius),
            Actor(
              acts: const [Act.rotate(to: 135)],
              child: FloatingActionButton(
                heroTag: 'cue_radial_main',
                onPressed: () => setState(() => _open = !_open),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniButton(ThemeData theme, int index, double radius) {
    // Leque de -150° a -30° (acima do botão principal).
    final angle = math.pi + (index + 1) * (math.pi / (_items.length + 1));
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);

    return Actor(
      delay: Duration(milliseconds: 40 * index),
      acts: [
        Act.translate(to: Offset(dx, dy)),
        const Act.scale(from: 0.0),
        const Act.fadeIn(motion: CueMotion.smooth()),
        // const Act.rotate(to: 20, motion: CueMotion.effectSlow()),
      ],
      child: FloatingActionButton.small(
        heroTag: 'cue_radial_$index',
        backgroundColor: _items[index].$2,
        foregroundColor: Colors.white,
        onPressed: () => setState(() => _open = false),
        child: Icon(_items[index].$1),
      ),
    );
  }
}
