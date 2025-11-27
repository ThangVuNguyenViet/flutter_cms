/// Flutter CMS Annotations
///
/// This file exports all CMS field configuration annotations and related types
/// for use in user code. Import this to access all @Cms*FieldConfig annotations.
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

// Core annotations and data types
export 'src/core/annotations.dart';
export 'src/core/cms_data.dart';
// Base field abstractions
export 'src/fields/base/field.dart';
export 'src/fields/complex/array_field.dart';
export 'src/fields/complex/block_field.dart';
export 'src/fields/complex/dropdown_field.dart';
export 'src/fields/complex/geopoint_field.dart';
export 'src/fields/complex/object_field.dart';
export 'src/fields/complex/reference_field.dart';
export 'src/fields/media/color_field.dart';
export 'src/fields/media/file_field.dart';
export 'src/fields/media/image_field.dart';
// All field configurations for annotations
export 'src/fields/primitive/boolean_field.dart';
export 'src/fields/primitive/checkbox_field.dart';
export 'src/fields/primitive/date_field.dart';
export 'src/fields/primitive/datetime_field.dart';
export 'src/fields/primitive/number_field.dart';
export 'src/fields/primitive/slug_field.dart';
export 'src/fields/primitive/string_field.dart';
export 'src/fields/primitive/text_field.dart';
export 'src/fields/primitive/url_field.dart';
// Validation
export 'src/validators/validators.dart';
