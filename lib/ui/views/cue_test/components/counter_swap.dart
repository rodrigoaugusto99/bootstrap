import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class CounterSwap extends StatefulWidget {
  const CounterSwap({Key? key}) : super(key: key);

  @override
  State<CounterSwap> createState() => _CounterSwapState();
}

class _CounterSwapState extends State<CounterSwap> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filledTonal(
          onPressed: () => setState(() => _count--),
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 80,
          child: Center(
            child: Cue.onChange(
              value: _count,
              motion: const CueMotion.spatialFast(),
              acts: const [Act.fadeIn(), Act.slideY(from: 0.6)],
              child: Text(
                '$_count',
                key: ValueKey(_count),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () => setState(() => _count++),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
