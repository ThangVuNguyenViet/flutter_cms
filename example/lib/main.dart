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
              CmsDocumentTypeDecoration(
                documentType: homeScreenButtonConfigDocumentType,
                icon: Icons.smart_button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
