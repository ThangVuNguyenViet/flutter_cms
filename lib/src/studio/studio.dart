/// Flutter CMS Studio - Complete CMS interface components
///
/// This module provides the full CMS studio UI including:
/// - Document management screens
/// - Form components with reactive state
/// - Navigation and layout components
/// - Theme system integration
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_cms/studio/studio.dart';
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return ShadApp(
///       home: CmsStudioShell(
///         documentTypes: [
///           // Your CMS document types
///         ],
///       ),
///     );
///   }
/// }
/// ```

// Core studio functionality
export 'core/config.dart';
export 'core/registry.dart';
export 'core/serializable.dart';
export 'core/signals/cms_signals.dart';

// UI Components
export 'components/common/cms_document_type_decoration.dart';
export 'components/common/cms_document_type_item.dart';
export 'components/common/default_cms_header.dart';
export 'components/forms/cms_form.dart';
export 'components/layout/three_pane_layout.dart';
export 'components/navigation/cms_document_type_sidebar.dart';

// Main screens
export 'screens/document_editor.dart';
export 'screens/document_list.dart';
export 'screens/studio_shell.dart';

// Theme
export 'theme/theme.dart';
