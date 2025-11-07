/// Flutter CMS - A code-generation first CMS framework for Flutter
///
/// This package provides annotation-driven CMS functionality with:
/// - Type-safe code generation for fields and configurations
/// - Reactive state management with SolidArt signals
/// - Professional text editing with SuperEditor
/// - Automatic serialization with dart_mappable
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_cms/flutter_cms.dart';
///
/// @CmsConfig()
/// class BlogPost {
///   @CmsStringFieldConfig()
///   final String title;
///
///   @CmsTextFieldConfig()
///   final String content;
///
///   const BlogPost({required this.title, required this.content});
/// }
/// ```
///
/// For a convenience import that includes all annotations, use:
/// ```dart
/// import 'package:flutter_cms/annotations.dart';
/// ```

// Core abstractions and data models
export 'src/core/annotations.dart';
export 'src/core/cms_data.dart';

// Field system
export 'src/fields/base/field.dart';

// Primitive fields
export 'src/fields/primitive/boolean_field.dart';
export 'src/fields/primitive/checkbox_field.dart';
export 'src/fields/primitive/date_field.dart';
export 'src/fields/primitive/datetime_field.dart';
export 'src/fields/primitive/number_field.dart';
export 'src/fields/primitive/slug_field.dart';
export 'src/fields/primitive/string_field.dart';
export 'src/fields/primitive/text_field.dart';
export 'src/fields/primitive/url_field.dart';

// Complex fields
export 'src/fields/complex/array_field.dart';
export 'src/fields/complex/block_field.dart';
export 'src/fields/complex/dropdown_field.dart';
export 'src/fields/complex/geopoint_field.dart';
export 'src/fields/complex/object_field.dart';
export 'src/fields/complex/reference_field.dart';

// Media fields
export 'src/fields/media/color_field.dart';
export 'src/fields/media/file_field.dart';
export 'src/fields/media/image_field.dart';

// Input widgets (hide preview functions to avoid naming conflicts)
export 'src/inputs/array_input.dart';
export 'src/inputs/block_input.dart' hide preview;
export 'src/inputs/boolean_input.dart' hide preview;
export 'src/inputs/checkbox_input.dart' hide preview;
export 'src/inputs/color_input.dart';
export 'src/inputs/date_input.dart' hide preview;
export 'src/inputs/datetime_input.dart' hide preview;
export 'src/inputs/dropdown_input.dart' hide preview;
export 'src/inputs/file_input.dart' hide preview;
export 'src/inputs/geopoint_input.dart' hide preview;
export 'src/inputs/image_input.dart' hide preview;
export 'src/inputs/number_input.dart' hide preview;
export 'src/inputs/object_input.dart' hide preview;
export 'src/inputs/reference_input.dart' hide preview;
export 'src/inputs/slug_input.dart' hide preview;
export 'src/inputs/string_input.dart' hide preview;
export 'src/inputs/text_input.dart' hide preview;
export 'src/inputs/url_input.dart' hide preview;

// Utilities
export 'src/extensions/object_extensions.dart';
export 'src/validators/validators.dart';
