import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/pages/scanner_modal.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:loyalty_cards_app/widgets/color_picker.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/widgets/icon_picker.dart';

class CustomCardModal extends ConsumerStatefulWidget {
  const CustomCardModal({super.key});

  @override
  ConsumerState<CustomCardModal> createState() => _CustomCardModalState();
}

class _CustomCardModalState extends ConsumerState<CustomCardModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  Color? currentColor;
  String? selectedIcon;
  Brand? brand;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: '');
    currentColor = myColors[0];
    selectedIcon = icons[0];

    _nameCtrl.addListener(() {
      setState(() {}); // rebuild whenever text changes
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  // colors list
  final List<Color> myColors = [
    Colors.red.shade800,
    Colors.orange.shade800,
    Colors.yellow.shade800,
    Colors.green.shade800,
    Colors.cyan.shade800,
    Colors.blue.shade800,
    Colors.purple.shade800,
    Colors.pink.shade800,
    Colors.brown.shade800,
    Colors.grey.shade800,
  ];

  // icons list
  final icons = [
    'assets/images/grocery.png',
    'assets/images/shopping.png',
    'assets/images/restaurant.png',
    'assets/images/gym.png',
    'assets/images/spa.png',
    'assets/images/sports.png',
    'assets/images/coffee.png',
    'assets/images/pharmacy.png',
    'assets/images/burger.png',
    'assets/images/pizza.png',
    'assets/images/train.png',
    'assets/images/star.png',
  ];

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      resizeToAvoidBottomInset: true,
      appBar: CustomPlatformAppBar(
        title: Text(S.of(context).add_custom_card),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // card preview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: currentColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        spacing: 4.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            selectedIcon!,
                            width: MediaQuery.of(context).size.width * 0.20,
                            height: MediaQuery.of(context).size.width * 0.20,
                            fit: BoxFit.contain,
                          ),
                          AutoSizeText(
                            _nameCtrl.text,
                            style: const TextStyle(
                              color: onSeed,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // card color picker
                ColorPicker(
                  colors: myColors,
                  selectedColor: currentColor,
                  onColorSelected: (color) {
                    setState(() => currentColor = color);
                  },
                ),
                // icon picker
                IconPicker(
                  assetPaths: icons,
                  selectedAssetPath: selectedIcon,
                  onIconSelected: (icon) => setState(() => selectedIcon = icon),
                ),
                const SizedBox(height: 16),
                // name input
                Form(
                  key: _formKey,
                  child: PlatformTextFormField(
                    controller: _nameCtrl,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLength: 30,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) =>
                        setState(() {}), // rebuild to update preview
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).please_enter_name;
                      }
                      return null;
                    },
                    material: (_, __) => MaterialTextFormFieldData(
                      decoration: InputDecoration(
                        labelText: S.of(context).name,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    cupertino: (_, __) => CupertinoTextFormFieldData(
                      placeholder: S.of(context).name,
                      decoration: BoxDecoration(
                        color: cupertinoTheme.barBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // bottom buttons
          SafeArea(
            minimum: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: PlatformElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // brand for custom cards
                    brand = Brand(
                      name: _nameCtrl.text.isEmpty
                          ? 'Custom Card'
                          : _nameCtrl.text,
                      colorHex: currentColor!
                          .toARGB32()
                          .toRadixString(16)
                          .padLeft(8, '0'),
                      logo: selectedIcon!,
                      isCustom: true,
                    );
                    // navigate to scanner modal
                    Navigator.of(context).push(
                      platformPageRoute(
                        context: context,
                        builder: (_) => ScannerModal(brand: brand!),
                      ),
                    );
                  }
                },
                child: Text(
                  S.of(context).continue_to_scan,
                  style: TextStyle(color: onSeed),
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
            ),
          ),
        ],
      ),
    );
  }
}
