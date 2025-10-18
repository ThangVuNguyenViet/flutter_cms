import 'package:example/screens/homes_creen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/models/cms_annotations.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:flutter_cms/models/fields/datetime_field.dart';
import 'package:flutter_cms/models/fields/image_field.dart';
import 'package:flutter_cms/models/fields/number_field.dart';
import 'package:flutter_cms/models/fields/object_field.dart';
import 'package:flutter_cms/models/fields/string_field.dart';
import 'package:flutter_cms/models/fields/text_field.dart';
import 'package:flutter_cms/studio/cms_config.dart';

part 'home_screen_config.cms.g.dart';

@CmsConfig(
  title: 'Home Screen',
  description: 'Configuration for the home screen',
)
class HomeScreenConfig {
  @CmsTextFieldConfig(
    option: CmsTextOption(rows: 1, description: 'Title of the home screen'),
  )
  final String title;
  @CmsImageFieldConfig()
  final String backgroundImageAsset;
  @CmsDateTimeFieldConfig()
  final DateTime dateTime;
  @CmsNumberFieldConfig()
  final double number;
  final HomeScreenButtonConfig buttonConfig;

  const HomeScreenConfig({
    required this.title,
    required this.backgroundImageAsset,
    required this.dateTime,
    required this.number,
    required this.buttonConfig,
  });
}

Widget $homeScreenBuilder(HomeScreenConfigCmsConfig config) {
  return HomeScreen(config: config);
}

@CmsConfig(
  title: 'Button Configuration',
  description: 'Configuration for home screen button',
)
class HomeScreenButtonConfig {
  @CmsStringFieldConfig()
  final String label;
  @CmsStringFieldConfig() // Assuming Color is represented as a String (e.g., hex code)
  final Color backgroundColor;

  const HomeScreenButtonConfig({
    required this.label,
    required this.backgroundColor,
  });
}
