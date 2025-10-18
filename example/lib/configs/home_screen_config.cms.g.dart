// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'home_screen_config.dart';

// **************************************************************************
// CmsFieldGenerator
// **************************************************************************

/// Generated field configurations for HomeScreenConfig
final homeScreenConfigFields = [
  CmsTextFieldConfig(
    name: 'title',
    title: 'Title',
    option: CmsTextOption(rows: 1),
  ),
  CmsImageFieldConfig(
    name: 'backgroundImageAsset',
    title: 'Background Image Asset',
    option: CmsImageOption(hotspot: false),
  ),
  CmsDateTimeFieldConfig(name: 'dateTime', title: 'Date Time'),
  CmsNumberFieldConfig(name: 'number', title: 'Number'),
  CmsObjectFieldConfig(
    name: 'buttonConfig',
    title: 'Button Config',
    option: CmsObjectOption(fields: homeScreenButtonConfigFields),
  ),
];

/// Generated document type for HomeScreenConfig
final homeScreenConfigDocumentType = CmsDocumentType<HomeScreenConfigCmsConfig>(
  name: 'homeScreenConfig',
  title: 'Home Screen',
  description: 'Configuration for the home screen',
  fields: homeScreenConfigFields,
  builder: $homeScreenBuilder,
);

/// Generated field configurations for HomeScreenButtonConfig
final homeScreenButtonConfigFields = [
  CmsStringFieldConfig(name: 'label', title: 'Label'),
  CmsStringFieldConfig(name: 'backgroundColor', title: 'Background Color'),
];

/// Generated document type for HomeScreenButtonConfig
final homeScreenButtonConfigDocumentType = CmsDocumentType<HomeScreenButtonConfigCmsConfig>(
  name: 'homeScreenButtonConfig',
  title: 'Button Configuration',
  description: 'Configuration for home screen button',
  fields: homeScreenButtonConfigFields,
);

// **************************************************************************
// CmsConfigGenerator
// **************************************************************************

class HomeScreenConfigCmsConfig {
  HomeScreenConfigCmsConfig({
    required this.title,
    required this.backgroundImageAsset,
    required this.dateTime,
    required this.number,
    required this.buttonConfig,
  });

  final CmsData<String> title;

  final CmsData<String> backgroundImageAsset;

  final CmsData<DateTime> dateTime;

  final CmsData<double> number;

  final CmsData<HomeScreenButtonConfigCmsConfig> buttonConfig;
}

class HomeScreenButtonConfigCmsConfig {
  HomeScreenButtonConfigCmsConfig({
    required this.label,
    required this.backgroundColor,
  });

  final CmsData<String> label;

  final CmsData<Color> backgroundColor;
}