import 'package:flutter/widgets.dart';

import 'signals/cms_signals.dart';

/// InheritedWidget that provides [CmsViewModel] to descendant widgets.
///
/// Wrap your CMS studio widgets with this provider to give them access
/// to the ViewModel:
///
/// ```dart
/// CmsProvider(
///   viewModel: myViewModel,
///   child: CmsStudio(...),
/// )
/// ```
class CmsProvider extends InheritedWidget {
  /// The CMS view model instance to provide.
  final CmsViewModel viewModel;

  const CmsProvider({
    super.key,
    required this.viewModel,
    required super.child,
  });

  /// Gets the [CmsViewModel] from the closest [CmsProvider] ancestor.
  ///
  /// Returns null if no [CmsProvider] is found in the widget tree.
  static CmsViewModel? maybeOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CmsProvider>();
    return provider?.viewModel;
  }

  /// Gets the [CmsViewModel] from the closest [CmsProvider] ancestor.
  ///
  /// Throws if no [CmsProvider] is found in the widget tree.
  static CmsViewModel of(BuildContext context) {
    final viewModel = maybeOf(context);
    assert(viewModel != null, 'No CmsProvider found in widget tree');
    return viewModel!;
  }

  @override
  bool updateShouldNotify(CmsProvider oldWidget) {
    return viewModel != oldWidget.viewModel;
  }
}
