import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:example/screens/homes_creen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/annotations.dart';
import 'package:flutter_cms/studio.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_editor/super_editor.dart';

part 'home_screen_config.cms.g.dart';
part 'home_screen_config.mapper.dart';

@CmsConfig(
  title: 'Home Screen',
  description:
      'Configuration for the mobile app home screen with hero section, features, and actions',
)
@MappableClass(ignoreNull: false, includeCustomMappers: [ColorMapper()])
class HomeScreenConfig extends CmsConfigToDocument<HomeScreenConfig>
    with HomeScreenConfigMappable {
  // Hero Section
  @CmsStringFieldConfig(
    description: 'Title text displayed prominently in the hero section',
    option: CmsStringOption(),
  )
  final String heroTitle;

  @CmsTextFieldConfig(
    description: 'Descriptive text shown below the hero title',
    option: CmsTextOption(rows: 3),
  )
  final String heroSubtitle;

  @CmsImageFieldConfig(
    description: 'Background image for the hero section',
    option: CmsImageOption(hotspot: false),
  )
  final String backgroundImageUrl;

  @CmsBooleanFieldConfig(
    description: 'Enable dark overlay on background image',
    option: CmsBooleanOption(),
  )
  final bool enableDarkOverlay;

  @CmsColorFieldConfig(
    description: 'Primary theme color used throughout the screen',
    option: CmsColorOption(),
  )
  final Color primaryColor;

  // Content Configuration
  @CmsArrayFieldConfig<String>(
    description: 'List of features to highlight on the home screen',
    option: FeaturedItemsArrayOption(),
  )
  final List<String> featuredItems;

  @CmsNumberFieldConfig(
    description: 'Maximum number of items to display in featured section',
    option: CmsNumberOption(min: 0, max: 10),
  )
  final int maxFeaturedItems;

  @CmsDateTimeFieldConfig(
    description: 'Last updated timestamp for the configuration',
    option: CmsDateTimeOption(),
  )
  final DateTime lastUpdated;

  @CmsUrlFieldConfig(
    description: 'External link for more information',
    option: CmsUrlOption(),
  )
  final String? externalLink;

  @CmsBooleanFieldConfig(
    description: 'Show promotional banner at the top',
    option: CmsBooleanOption(),
  )
  final bool showPromotionalBanner;

  // Action Buttons - simplified as strings for now
  @CmsStringFieldConfig(
    description: 'Label text for the primary action button',
    option: CmsStringOption(),
  )
  final String primaryButtonLabel;

  @CmsStringFieldConfig(
    description: 'Label text for the secondary action button',
    option: CmsStringOption(),
  )
  final String secondaryButtonLabel;

  // Layout Configuration
  @CmsDropdownFieldConfig<String>(
    description: 'Layout style for the content area',
    option: LayoutStyleDropdownOption(),
  )
  final String layoutStyle;

  @CmsNumberFieldConfig(
    description: 'Padding around the main content area in pixels',
    option: CmsNumberOption(min: 8.0, max: 32.0),
  )
  final double contentPadding;

  const HomeScreenConfig({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.backgroundImageUrl,
    required this.enableDarkOverlay,
    required this.primaryColor,
    required this.featuredItems,
    required this.maxFeaturedItems,
    required this.lastUpdated,
    this.externalLink,
    required this.showPromotionalBanner,
    required this.primaryButtonLabel,
    required this.secondaryButtonLabel,
    required this.layoutStyle,
    required this.contentPadding,
  });

  factory HomeScreenConfig.defaultValue() => HomeScreenConfig(
    heroTitle: 'Welcome to Our App',
    heroSubtitle:
        'Discover amazing features and capabilities that will enhance your daily workflow and productivity.',
    backgroundImageUrl:
        'https://images.unsplash.com/photo-1557804506-669a67965ba0',
    enableDarkOverlay: true,
    primaryColor: Colors.deepPurple,
    featuredItems: [
      'Advanced Analytics',
      'Real-time Collaboration',
      'Cloud Synchronization',
      'Smart Notifications',
      'Cross-platform Support',
    ],
    maxFeaturedItems: 4,
    lastUpdated: DateTime.now(),
    externalLink: 'https://example.com/learn-more',
    showPromotionalBanner: true,
    primaryButtonLabel: 'Get Started',
    secondaryButtonLabel: 'Learn More',
    layoutStyle: 'grid',
    contentPadding: 16.0,
  );
}

Widget $homeScreenConfigBuilder(Map<String, dynamic> config) {
  final homeScreenConfig = HomeScreenConfigMapper.fromMap(config);

  return HomeScreen(config: homeScreenConfig);
}

class ColorMapper extends SimpleMapper<Color> {
  const ColorMapper();

  @override
  Color decode(Object value) {
    if (value is String) {
      final hexColor = value.replaceFirst('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      } else if (hexColor.length == 8) {
        return Color(int.parse(hexColor, radix: 16));
      }
    }
    throw Exception('Cannot decode Color from $value');
  }

  @override
  Object? encode(Color self) {
    return '#${self.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}

class LayoutStyleDropdownOption extends CmsDropdownOption<String> {
  const LayoutStyleDropdownOption({super.hidden});

  @override
  bool get allowNull => false;

  @override
  FutureOr<String?>? get defaultValue async {
    return (await options).firstOrNull?.value;
  }

  @override
  FutureOr<List<DropdownOption<String>>> get options => Future.value([
    DropdownOption(value: 'grid', label: 'Grid Layout'),
    DropdownOption(value: 'list', label: 'List Layout'),
    DropdownOption(value: 'masonry', label: 'Masonry Layout'),
  ]);

  @override
  String? get placeholder => 'Select a layout style';
}

class FeaturedItemsArrayOption extends CmsArrayOption {
  const FeaturedItemsArrayOption({super.hidden});

  @override
  CmsArrayFieldItemBuilder get itemBuilder =>
      (BuildContext context, dynamic value) {
        return ListTile(title: Text(value as String));
      };

  @override
  CmsArrayFieldItemEditor get itemEditor =>
      (
        BuildContext context,
        dynamic value,
        Widget saveButton,
        ValueChanged<dynamic>? onChanged,
      ) {
        return FeaturedItemEditor(
          initialValue: value as String? ?? '',
          onChanged: onChanged,
          saveButton: saveButton,
        );
      };
}

class FeaturedItemEditor extends StatefulWidget {
  final String initialValue;
  final ValueChanged<dynamic>? onChanged;
  final Widget saveButton;

  const FeaturedItemEditor({
    super.key,
    required this.initialValue,
    this.onChanged,
    required this.saveButton,
  });

  @override
  State<FeaturedItemEditor> createState() => _FeaturedItemEditorState();
}

class _FeaturedItemEditorState extends State<FeaturedItemEditor> {
  late final AttributedTextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = AttributedTextEditingController(
      text: AttributedText(widget.initialValue),
    );

    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _textController.text.toPlainText();
    widget.onChanged?.call(text);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Edit Featured Item',
                style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Item Title',
            style: theme.textTheme.small.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: SuperTextField(
              textController: _textController,
              focusNode: _focusNode,
              minLines: 1,
              maxLines: 3,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintBehavior: HintBehavior.displayHintUntilTextEntered,
              hintBuilder: (context) => Text(
                'Enter featured item title...',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This item will appear in the featured section of the home screen.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShadButton.ghost(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              widget.saveButton,
            ],
          ),
        ],
      ),
    );
  }
}
