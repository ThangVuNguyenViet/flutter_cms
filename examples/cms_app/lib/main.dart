import 'package:example_data/example_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/studio.dart';
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
      ),
      radius: BorderRadius.circular(8.0),
    );
  }
}
