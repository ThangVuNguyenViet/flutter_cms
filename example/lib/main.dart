import 'package:example/configs/home_screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/studio/cms_document_type_decoration.dart';
import 'package:flutter_cms/studio/cms_document_type_sidebar.dart';
import 'package:flutter_cms/studio/cms_studio.dart';
import 'package:flutter_cms/studio/default_cms_header.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: _buildCmsTheme(),
      // darkTheme: _buildCmsDarkTheme(),
      home: Scaffold(
        body: CmsStudio(
          header: const DefaultCmsHeader(
            name: 'example-cms',
            title: 'Example CMS',
            subtitle: 'Content Management',
            icon: Icons.dashboard,
          ),
          sidebar: CmsDocumentTypeSidebar(
            documentTypeDecorations: [
              CmsDocumentTypeDecoration(
                documentType: homeScreenConfigDocumentType,
                icon: Icons.home,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a professional light theme suitable for a CMS interface
  static ShadThemeData _buildCmsTheme() {
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadSlateColorScheme.light(),
      textTheme: ShadTextTheme(
        family: 'Inter', // Professional, readable font for CMS interfaces
        h1Large: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02,
          height: 1.1,
        ),
        h1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          height: 1.2,
        ),
        h2: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          height: 1.3,
        ),
        h3: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
        h4: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
        p: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.01,
        ),
        small: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: 0.01,
        ),
        muted: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: 0.01,
        ),
      ),
      radius: BorderRadius.circular(
        8.0,
      ), // Slightly larger radius for a more modern look
      // Professional spacing for CMS interfaces
      // These values create consistent spacing throughout the interface
    );
  }

  /// Creates a professional dark theme suitable for a CMS interface
  static ShadThemeData _buildCmsDarkTheme() {
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadSlateColorScheme.dark(),
      textTheme: ShadTextTheme(
        family: 'Inter', // Consistent font family across themes
        h1Large: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02,
          height: 1.1,
        ),
        h1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          height: 1.2,
        ),
        h2: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          height: 1.3,
        ),
        h3: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
        h4: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
        p: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.01,
        ),
        small: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: 0.01,
        ),
        muted: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: 0.01,
        ),
      ),
      radius: BorderRadius.circular(8.0), // Consistent radius across themes
      // Dark theme optimized for reduced eye strain during long CMS sessions
    );
  }
}
