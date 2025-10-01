import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/pages/custom_card_modal.dart';
import 'package:loyalty_cards_app/services/shared_preferences_service.dart';
import 'package:loyalty_cards_app/theme.dart';
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

  // selected region (from saved preference or default to 'all')
  String _selectedRegion = SharedPrefs.getString('preferred_region') ?? 'all';
  late final ValueNotifier<String?> _regionValue;

  // regions list
  late final List<String> _regionOptions;

  static const double _flagSize = 20.0;
  static const double _buttonSize = 36.0;
  static const double _menuWidth = 46.0;

  @override
  void initState() {
    super.initState();
    _regionOptions = _computeRegions(widget.brands);
    _regionValue = ValueNotifier<String?>(_selectedRegion);
  }

  @override
  void dispose() {
    _regionValue.dispose();
    super.dispose();
  }

  // compute unique regions from all brands
  List<String> _computeRegions(List<Brand> brands) {
    final set = <String>{};
    for (final b in brands) {
      for (final r in (b.regions ?? const <String>[])) {
        final code = r.trim().toLowerCase();
        if (code.isNotEmpty) set.add(code);
      }
    }
    final list = set.toList()..sort();
    return ['all', ...list];
  }

  // filtered and sorted brands
  List<Brand> get _filteredBrands {
    final q = _search.trim().toLowerCase();
    final region = _selectedRegion.toLowerCase();

    bool brandInRegion(Brand b) {
      final regs = b.regions ?? const <String>[];
      return regs.map((e) => e.toLowerCase()).contains(region);
    }

    bool isPopularInRegion(Brand b, String r) {
      final pops = b.popularRegions ?? const <String>[];
      return pops.map((e) => e.toLowerCase()).contains(r);
    }

    int compareAlpha(Brand a, Brand b) {
      String key(Brand x) {
        final name = x.name?.trim();
        if (name != null && name.isNotEmpty) return name.toLowerCase();
        final id = x.id?.trim();
        return (id == null || id.isEmpty) ? '' : id.toLowerCase();
      }

      return key(a).compareTo(key(b));
    }

    final list = widget.brands.where((b) {
      final nameLower = (b.name ?? '').toLowerCase();
      final matchesSearch = q.isEmpty ? true : nameLower.contains(q);
      final matchesRegion = region == 'all' ? true : brandInRegion(b);
      return matchesSearch && matchesRegion;
    }).toList();

    if (region == 'all') {
      list.sort(compareAlpha);
    } else {
      list.sort((a, b) {
        final aPop = isPopularInRegion(a, region);
        final bPop = isPopularInRegion(b, region);
        if (aPop != bPop) return aPop ? -1 : 1; // popular first
        return compareAlpha(a, b); // then alpha
      });
    }

    return list;
  }

  // map to ISO 3166-1 alpha-2 for country_flags
  String _toFlagCode(String code) {
    final c = code.trim().toLowerCase();
    return c.toUpperCase();
  }

  // flag icon
  Widget _flagIcon(String code, {double size = _flagSize}) {
    return CountryFlag.fromCountryCode(
      _toFlagCode(code),
      theme: ImageTheme(shape: const Circle(), width: size, height: size),
    );
  }

  // earth icon for "all"
  Widget _earthIcon({double size = _flagSize}) {
    return ClipOval(
      child: Image.asset(
        'assets/icons/earth-icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: Text(S.of(context).add_card),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20.0,
            children: [
              PlatformElevatedButton(
                onPressed: () {
                  // navigate to custom card modal
                  Navigator.of(context).push(
                    platformPageRoute(
                      context: context,
                      builder: (_) => const CustomCardModal(),
                    ),
                  );
                },
                // add custom card button
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(context.platformIcons.add, color: onSeed),
                    Text(
                      S.of(context).add_custom_card,
                      style: TextStyle(color: onSeed),
                    ),
                    const Icon(Icons.add_card, color: onSeed),
                  ],
                ),
                material: (_, __) => MaterialElevatedButtonData(
                  style: ElevatedButton.styleFrom(backgroundColor: seed),
                ),
                cupertino: (_, __) {
                  return CupertinoElevatedButtonData(
                    color: seed,
                    sizeStyle: CupertinoButtonSize.small,
                  );
                },
              ),
              // search widget
              _buildSearchField(context),
              // filtered brands list
              Expanded(child: BrandsList(brands: _filteredBrands)),
            ],
          ),
        ),
      ),
    );
  }

  // search field
  Widget _buildSearchField(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return PlatformWidget(
      material: (_, __) => SearchBar(
        hintText: 'Aa...',
        elevation: WidgetStateProperty.all(0),
        leading: const Icon(Icons.search),
        trailing: [_buildRegionDropdown(context)], // region dropdown
        onChanged: (value) => setState(() => _search = value),
      ),
      cupertino: (_, __) => CupertinoTextField(
        placeholder: 'Aa...',
        padding: const EdgeInsets.all(8.0),
        onChanged: (value) => setState(() => _search = value),
        prefix: const Padding(
          padding: EdgeInsetsDirectional.only(start: 6.0),
          child: Icon(CupertinoIcons.search),
        ),
        suffix: Padding(
          padding: const EdgeInsetsDirectional.only(end: 6.0),
          child: _buildRegionDropdown(context), // region dropdown
        ),
        decoration: BoxDecoration(
          color: cupertinoTheme.barBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: CupertinoColors.systemGrey4, width: 1.0),
        ),
      ),
    );
  }

  // dropdown button
  Widget _buildRegionDropdown(BuildContext context) {
    Widget buildIcon(String r) => r == 'all'
        ? _earthIcon(size: _flagSize)
        : _flagIcon(r, size: _flagSize);

    final String selected = _regionValue.value ?? 'all';

    return DropdownButtonHideUnderline(
      child: Material(
        color: Colors.transparent,
        child: DropdownButton2<String>(
          valueListenable: _regionValue,
          onChanged: (val) async {
            if (val == null) return;
            // update notifier
            _regionValue.value = val;
            setState(() => _selectedRegion = val);
            // save preference
            await SharedPrefs.setString('preferred_region', val);
          },

          // closed button
          customButton: Container(
            height: _buttonSize,
            width: _menuWidth,
            decoration: BoxDecoration(color: Colors.transparent),
            child: Center(child: buildIcon(selected)),
          ),

          // items
          items: _regionOptions
              .map(
                (r) => DropdownItem<String>(
                  value: r,
                  height: _buttonSize + 6,
                  alignment: Alignment.center,
                  child: buildIcon(r), // icon
                ),
              )
              .toList(),

          // hide chevron
          iconStyleData: const IconStyleData(icon: SizedBox.shrink()),

          // button style
          buttonStyleData: const ButtonStyleData(
            height: _buttonSize,
            width: _menuWidth,
            padding: EdgeInsets.zero,
          ),

          // dropdown (menu) style
          dropdownStyleData: DropdownStyleData(
            width: _menuWidth,
            padding: EdgeInsets.zero,
            elevation: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent),
            ),
            offset: const Offset(0, -6), // small gap below the button
            direction: DropdownDirection.textDirection,
          ),

          // menu items style (no inner padding so icons are perfectly centered)
          menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.zero),
        ),
      ),
    );
  }
}
