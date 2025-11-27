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
/// import 'package:flutter_cms/studio.dart';
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return ShadApp(
///       home: CmsStudio(
///         header: DefaultCmsHeader(
///           name: 'my-cms',
///           title: 'My CMS',
///         ),
///         sidebar: CmsDocumentTypeSidebar(
///           documentTypeDecorations: [
///             // Your document type decorations
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
library;

export 'src/studio/studio.dart';