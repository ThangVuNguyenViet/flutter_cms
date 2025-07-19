import 'dart:ui';

import 'package:flutter_cms/models/cms_annotations.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:flutter_cms/models/fields/string_field.dart';

part 'home_screen_config.cms.g.dart';

@CmsConfig()
class HomeScreenConfig {
  @CmsStringFieldConfig()
  final String title;
  final String backgroundImageAsset;
  final DateTime dateTime;
  final double number;
  final HomeScreenButtonConfig buttonConfig;

  HomeScreenConfig({
    required this.title,
    required this.backgroundImageAsset,
    required this.dateTime,
    required this.number,
    required this.buttonConfig,
  });

  static HomeScreenConfig get defaultHomeConfig => HomeScreenConfig(
    title: 'Welcome to Flutter CMS',
    backgroundImageAsset:
        'assets/background.jpg', // Placeholder, you'll need to add this asset
    dateTime: DateTime.now(),
    number: 42.0, // Example number
    buttonConfig: HomeScreenButtonConfig(
      label: 'Get Started',
      backgroundColor: const Color(0xFF6200EE), // Default color
    ),
  );
}

@CmsConfig()
class HomeScreenButtonConfig {
  final String label;
  final Color backgroundColor;

  HomeScreenButtonConfig({required this.label, required this.backgroundColor});
}
