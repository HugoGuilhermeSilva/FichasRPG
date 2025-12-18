import 'package:flutter/material.dart';

class AdvantagesCards extends StatelessWidget {
  final String name;
  final String description;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  const AdvantagesCards({
    required this.name,
    required this.description,
    required this.selected,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 300,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: selected ? Colors.yellowAccent : Colors.purpleAccent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Checkbox(
                  value: selected,
                  onChanged: onChanged,
                  activeColor: Colors.yellowAccent,
                  checkColor: Colors.black,
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Advantage {
  String name;
  String description;
  bool selected;

  Advantage({
    required this.name,
    required this.description,
    this.selected = false
  });
}