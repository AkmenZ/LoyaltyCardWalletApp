import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  final List<String> assetPaths;
  final String? selectedAssetPath;
  final ValueChanged<String> onIconSelected;
  final double boxSize;

  const IconPicker({
    super.key,
    required this.assetPaths,
    required this.onIconSelected,
    this.selectedAssetPath,
    this.boxSize = 44,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final path in assetPaths) ...[
            GestureDetector(
              onTap: () => onIconSelected(path),
              child: Container(
                width: boxSize,
                height: boxSize,
                margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: path == selectedAssetPath
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                    width: path == selectedAssetPath ? 3 : 1,
                  ),
                ),
                child: Center(
                  // icon image
                  child: Image.asset(
                    path,
                    width: boxSize * 0.7,
                    height: boxSize * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
