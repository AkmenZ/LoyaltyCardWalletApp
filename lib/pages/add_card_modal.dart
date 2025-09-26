import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:country_flags/country_flags.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/widgets/brands_list.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class AddCardModal extends StatefulWidget {
  const AddCardModal({super.key, required this.brands});

  final List<Brand> brands;

  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> {
  String _search = '';
  String _selectedRegion = 'all';
  late final List<String>
  _regionOptions; // e.g. ['all', 'cz', 'de', 'ee', 'ie', 'lt', 'lv', 'pl', 'sk', 'uk']

  @override
  void initState() {
    super.initState();
    _regionOptions = _computeRegions(widget.brands);
  }

  List<String> _computeRegions(List<Brand> brands) {
    final set = <String>{};
    for (final b in brands) {
      final regs = (b.regions ?? <String>[]);
      for (final r in regs) {
        final code = r.trim().toLowerCase();
        if (code.isNotEmpty) set.add(code);
      }
    }
    final list = set.toList()..sort();
    return ['all', ...list];
  }

  List<Brand> get _filteredBrands {
    final q = _search.trim().toLowerCase();
    return widget.brands.where((b) {
      final matchesSearch = q.isEmpty
          ? true
          : (b.name ?? '').toLowerCase().contains(q);
      final matchesRegion = _selectedRegion == 'all'
          ? true
          : (b.regions ?? <String>[])
                .map((e) => e.toLowerCase())
                .contains(_selectedRegion);
      return matchesSearch && matchesRegion;
    }).toList();
  }

  // Map input to ISO 3166-1 alpha-2 for the flag widget.
  // country_flags expects 'GB' instead of 'UK'.
  String _toFlagCode(String code) {
    final c = code.trim().toLowerCase();
    if (c == 'uk') return 'GB';
    return c.toUpperCase();
  }

  Widget _flagIcon(String code, {double size = 20}) {
    return CountryFlag.fromCountryCode(
      _toFlagCode(code),
      theme: ImageTheme(shape: const Circle(), width: size, height: size),
    );
  }

  String _displayText(String code) =>
      code == 'all' ? 'ALL' : code.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: const Text('Add New Card'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.0,
          children: [
            PlatformElevatedButton(
              onPressed: () {
                // navigate to scanner modal
                // Navigator.of(context).push(
                //   platformPageRoute(
                //     context: context,
                //     builder: (_) => const ScannerModal(),
                //   ),
                // );
              },
              child: const Text('Add Custom Card'),
              material: (_, __) => MaterialElevatedButtonData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              cupertino: (_, __) => CupertinoElevatedButtonData(
                color: CupertinoColors.activeBlue,
              ),
            ),
            // Search + Region row
            Row(
              children: [
                Expanded(flex: 4, child: _buildSearchField(context)),
                const SizedBox(width: 12),
                Expanded(flex: 1, child: _buildRegionDropdown(context)),
              ],
            ),
            // Filtered brands list
            Expanded(child: BrandsList(brands: _filteredBrands)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => SearchBar(
        hintText: 'Search for popular merchants',
        elevation: WidgetStateProperty.all(0),
        onChanged: (value) => setState(() => _search = value),
      ),
      cupertino: (_, __) => CupertinoSearchTextField(
        padding: const EdgeInsets.all(8.0),
        placeholder: 'Search for popular merchants',
        autofocus: true,
        onChanged: (value) => setState(() => _search = value),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: CupertinoColors.systemGrey4, width: 1.0),
        ),
      ),
    );
  }

  Widget _buildRegionDropdown(BuildContext context) {
    return PlatformWidget(
      // Material dropdown with flags (uses full width of its Expanded)
      material: (_, __) => DropdownButtonFormField<String>(
        initialValue: _selectedRegion,
        isDense: true,
        isExpanded: false,
        items: _regionOptions.map((r) {
          final isAll = r == 'all';
          return DropdownMenuItem(
            value: r,
            child: Row(
              children: [
                if (!isAll)
                  _flagIcon(r, size: 18)
                else
                  const Icon(Icons.public, size: 18),
                if (!isAll)
                  const SizedBox(width: 8)
                else
                  const SizedBox(width: 8),
                // If you want no text for "all", comment the next line out.
                if (!isAll) Text(_displayText(r)),
                if (isAll) const SizedBox.shrink(),
              ],
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val == null) return;
          setState(() => _selectedRegion = val);
        },
        decoration: const InputDecoration(
          labelText: '',
          border: null,
          isDense: true,
          icon: null,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
      ),
      // Cupertino button + action sheet with flags (button fills its Expanded width)
      cupertino: (_, __) => SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(8),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoActionSheet(
                title: const Text('Select Region'),
                actions: _regionOptions.map((r) {
                  final isAll = r == 'all';
                  return CupertinoActionSheetAction(
                    onPressed: () {
                      setState(() => _selectedRegion = r);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isAll)
                          _flagIcon(r, size: 20)
                        else
                          const Icon(CupertinoIcons.globe, size: 20),
                        const SizedBox(width: 8),
                        // If you want no text for "all", comment the next line out.
                        if (!isAll)
                          Text(_displayText(r))
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  );
                }).toList(),
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop(),
                  isDefaultAction: true,
                  child: const Text('Cancel'),
                ),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedRegion != 'all')
                _flagIcon(_selectedRegion, size: 18)
              else
                const Icon(CupertinoIcons.globe, size: 18),
              const SizedBox(width: 6),
              // If you want to hide text when "all" is selected, comment next line:
              if (_selectedRegion != 'all') Text(_displayText(_selectedRegion)),
              const SizedBox(width: 4),
              const Icon(CupertinoIcons.chevron_down, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
