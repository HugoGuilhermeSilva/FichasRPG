import 'package:flutter/material.dart';

class ArchetypeHeader extends StatelessWidget {
  final String? title;
  final String? level;
  final String? archetypeDescription;

  const ArchetypeHeader({
    super.key,
    this.title,
    this.level,
    this.archetypeDescription,
  });

  @override
  Widget build(BuildContext context) {
    if (title == null && level == null && archetypeDescription == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 300,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black,
      ),
      child: Column(
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          if (level != null)
            Text(
              'Nível: $level',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          if (archetypeDescription != null)
            Text(
              archetypeDescription!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
class ArchetypeCard extends StatelessWidget {
  final String name;
  final String description;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  const ArchetypeCard({
    super.key,
    required this.name,
    required this.description,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Checkbox(value: selected, onChanged: onChanged)
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style:
            const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
