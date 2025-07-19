// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_screen_config.dart';

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
