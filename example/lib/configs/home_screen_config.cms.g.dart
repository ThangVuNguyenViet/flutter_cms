// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'home_screen_config.dart';

// **************************************************************************
// CmsFieldGenerator
// **************************************************************************

/// Generated CmsField list for HomeScreenConfig
final homeScreenConfigFields = [
  CmsStringField(
    name: 'heroTitle',
    title: 'Hero Title',
    option: const CmsStringOption(),
  ),
  CmsTextField(
    name: 'heroSubtitle',
    title: 'Hero Subtitle',
    option: CmsTextOption(rows: 1),
  ),
  CmsImageField(
    name: 'backgroundImageUrl',
    title: 'Background Image Url',
    option: CmsImageOption(hotspot: false),
  ),
  CmsBooleanField(
    name: 'enableDarkOverlay',
    title: 'Enable Dark Overlay',
    option: const CmsBooleanOption(),
  ),
  CmsColorField(
    name: 'primaryColor',
    title: 'Primary Color',
    option: const CmsColorOption(showAlpha: false),
  ),
  CmsArrayField(
    name: 'featuredItems',
    title: 'Featured Items',
    option: const CmsArrayOption(),
    itemBuilder:
        (context, value) =>
            HomeScreenConfig.featuredItemsItemBuilder(context, value as String),
  ),
  CmsNumberField(
    name: 'maxFeaturedItems',
    title: 'Max Featured Items',
    option: CmsNumberOption(),
  ),
  CmsDateTimeField(
    name: 'lastUpdated',
    title: 'Last Updated',
    option: const CmsDateTimeOption(),
  ),
  CmsUrlField(
    name: 'externalLink',
    title: 'External Link',
    option: const CmsUrlOption(),
  ),
  CmsBooleanField(
    name: 'showPromotionalBanner',
    title: 'Show Promotional Banner',
    option: const CmsBooleanOption(),
  ),
  CmsStringField(
    name: 'primaryButtonLabel',
    title: 'Primary Button Label',
    option: const CmsStringOption(),
  ),
  CmsStringField(
    name: 'secondaryButtonLabel',
    title: 'Secondary Button Label',
    option: const CmsStringOption(),
  ),
  CmsDropdownField<String>(
    name: 'layoutStyle',
    title: 'Layout Style',
    option: CmsDropdownOption<String>(options: [], allowNull: true),
  ),
  CmsNumberField(
    name: 'contentPadding',
    title: 'Content Padding',
    option: CmsNumberOption(),
  ),
];

/// Generated document type for HomeScreenConfig
final homeScreenConfigDocumentType = CmsDocumentType<HomeScreenConfig>(
  name: 'homeScreenConfig',
  title: 'Home Screen',
  description:
      'Configuration for the mobile app home screen with hero section, features, and actions',
  fields: homeScreenConfigFields,
  builder: $homeScreenConfigBuilder,
  createDefault: () => HomeScreenConfig.defaultValue(),
);

// **************************************************************************
// CmsConfigGenerator
// **************************************************************************

class HomeScreenConfigCmsConfig {
  HomeScreenConfigCmsConfig({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.backgroundImageUrl,
    required this.enableDarkOverlay,
    required this.primaryColor,
    required this.featuredItems,
    required this.maxFeaturedItems,
    required this.lastUpdated,
    required this.externalLink,
    required this.showPromotionalBanner,
    required this.primaryButtonLabel,
    required this.secondaryButtonLabel,
    required this.layoutStyle,
    required this.contentPadding,
  });

  final CmsData<String> heroTitle;

  final CmsData<String> heroSubtitle;

  final CmsData<String> backgroundImageUrl;

  final CmsData<bool> enableDarkOverlay;

  final CmsData<Color> primaryColor;

  final CmsData<List<String>> featuredItems;

  final CmsData<int> maxFeaturedItems;

  final CmsData<DateTime> lastUpdated;

  final CmsData<String?> externalLink;

  final CmsData<bool> showPromotionalBanner;

  final CmsData<String> primaryButtonLabel;

  final CmsData<String> secondaryButtonLabel;

  final CmsData<String> layoutStyle;

  final CmsData<double> contentPadding;
}
