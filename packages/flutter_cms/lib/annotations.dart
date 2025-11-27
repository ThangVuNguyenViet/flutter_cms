/// Flutter CMS Annotations
///
/// This file re-exports all CMS annotations from flutter_cms_annotation
/// for backward compatibility. New code should import from
/// flutter_cms_annotation directly.
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_cms/annotations.dart';
///
/// @CmsConfig()
/// class MyConfig {
///   @CmsStringFieldConfig()
///   final String title;
///
///   @CmsDateTimeFieldConfig()
///   final DateTime createdAt;
/// }
/// ```
library;

// Re-export all annotations from flutter_cms_annotation
export 'package:flutter_cms_annotation/flutter_cms_annotation.dart';

// Flutter CMS specific exports
export 'src/core/cms_data.dart';
