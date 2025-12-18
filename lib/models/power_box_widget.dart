import 'package:fichas/data/power_model.dart';
import 'package:fichas/state_management/power_provider.dart';
import 'package:flutter/material.dart';

class PowerCard extends StatefulWidget {
  final Power power;
  final PowerProvider powerProvider;

  const PowerCard({
    super.key,
    required this.power,
    required this.powerProvider,
  });

  @override
  State<PowerCard> createState() => _PowerCardState();
}

class _PowerCardState extends State<PowerCard> {
  late final ScrollController _scrollController;
  bool _isSelected = false;
  int _level = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    _syncStateFromProvider();
  }
  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(covariant PowerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncStateFromProvider();
  }
  void _syncStateFromProvider() {
    final newIsSelected = widget.powerProvider.isPowerSelected(widget.power.name);
    final newLevel = widget.powerProvider.getPowerLevel(widget.power.name);
    if (_isSelected != newIsSelected || _level != newLevel) {
      setState(() {
        _isSelected = newIsSelected;
        _level = newLevel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final powerProvider = widget.powerProvider;

    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: _isSelected ? Colors.yellowAccent : Colors.deepPurple,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 300,
          maxHeight: 250,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.power.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          'Custo: ${widget.power.cost} XP',
                          style: const TextStyle(color: Colors.yellowAccent, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: _isSelected,
                    onChanged: (value) {
                      final bool newSelectedState = value ?? false;
                      setState(() {
                        _isSelected = newSelectedState;
                        if (newSelectedState && _level == 0) {
                          _level = 1;
                        }
                      });
                      powerProvider.togglePowerSelection(
                          widget.power.name, newSelectedState);
                      if (newSelectedState &&
                          powerProvider.getPowerLevel(widget.power.name) == 0) {
                        powerProvider.setPowerLevel(widget.power.name, 1);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        widget.power.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      if (_level > 0) {
                        powerProvider.decrementPowerLevel(widget.power.name);
                      }
                    },
                  ),
                  Text('Graus comprados: $_level',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      if (_isSelected) {
                        powerProvider.incrementPowerLevel(widget.power.name);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}