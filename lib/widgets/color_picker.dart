import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;
  final double boxSize;
  final double spacing;
  final EdgeInsets padding;

  const ColorPicker({
    super.key,
    required this.colors,
    required this.onColorSelected,
    this.selectedColor,
    this.boxSize = 44,
    this.spacing = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4.0,
        children: [
          for (final color in colors) ...[
            GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color == selectedColor
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                    width: color == selectedColor ? 3 : 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
          ],
        ],
      ),
    );
  }
}
