/// Flutter CMS Studio Theme
///
/// Provides theme configuration for the CMS studio interface
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Default theme for the CMS studio
ShadThemeData get cmsStudioTheme => ShadThemeData(
  brightness: Brightness.light,
  colorScheme: const ShadSlateColorScheme.light(),
);

/// Dark theme for the CMS studio
ShadThemeData get cmsStudioDarkTheme => ShadThemeData(
  brightness: Brightness.dark,
  colorScheme: const ShadSlateColorScheme.dark(),
);
