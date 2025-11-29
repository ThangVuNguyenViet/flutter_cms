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
    option: CmsStringOption(),
  ),
  CmsTextField(
    name: 'heroSubtitle',
    title: 'Hero Subtitle',
    option: CmsTextOption(rows: 3),
  ),
  CmsImageField(
    name: 'backgroundImageUrl',
    title: 'Background Image Url',
    option: CmsImageOption(hotspot: false),
  ),
  CmsBooleanField(
    name: 'enableDarkOverlay',
    title: 'Enable Dark Overlay',
    option: CmsBooleanOption(),
  ),
  CmsColorField(
    name: 'primaryColor',
    title: 'Primary Color',
    option: CmsColorOption(),
  ),
  CmsArrayField(
    name: 'featuredItems',
    title: 'Featured Items',
    option: FeaturedItemsArrayOption(),
  ),
  CmsNumberField(
    name: 'maxFeaturedItems',
    title: 'Max Featured Items',
    option: CmsNumberOption(min: 0, max: 10),
  ),
  CmsDateTimeField(
    name: 'lastUpdated',
    title: 'Last Updated',
    option: CmsDateTimeOption(),
  ),
  CmsUrlField(
    name: 'externalLink',
    title: 'External Link',
    option: CmsUrlOption(),
  ),
  CmsBooleanField(
    name: 'showPromotionalBanner',
    title: 'Show Promotional Banner',
    option: CmsBooleanOption(),
  ),
  CmsStringField(
    name: 'primaryButtonLabel',
    title: 'Primary Button Label',
    option: CmsStringOption(),
  ),
  CmsStringField(
    name: 'secondaryButtonLabel',
    title: 'Secondary Button Label',
    option: CmsStringOption(),
  ),
  CmsDropdownField<String>(
    name: 'layoutStyle',
    title: 'Layout Style',
    option: LayoutStyleDropdownOption(),
  ),
  CmsNumberField(
    name: 'contentPadding',
    title: 'Content Padding',
    option: CmsNumberOption(min: 8.0, max: 32.0),
  ),
];

/// Generated document type for HomeScreenConfig
final homeScreenConfigDocumentType = CmsDocumentType<HomeScreenConfig>(
  name: 'homeScreenConfig',
  title: 'Home Screen',
  description:
      'Configuration for the mobile app home screen with hero section, features, and actions',
  fields: homeScreenConfigFields,
  builder: HomeScreenConfig.configBuilder,
  defaultValue: HomeScreenConfig.defaultValue,
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
