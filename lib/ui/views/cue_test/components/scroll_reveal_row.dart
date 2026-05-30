import 'package:cue/cue.dart';
import 'package:flutter/material.dart';

class ScrollRevealRow extends StatelessWidget {
  const ScrollRevealRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labels = ['Roll', 'Scroll', 'Reveal', 'Magic', 'Cue'];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Cue.onScrollVisible(
            key: ValueKey(index),
            acts: const [
              Act.slideX(from: 0.5),
              Act.scale(from: 0.7),
              Act.fadeIn(),
            ],
            child: Container(
              width: 110,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                labels[index],
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
