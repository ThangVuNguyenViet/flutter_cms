import 'package:flutter/material.dart';

import '../../studio.dart';
import '../data/cms_data_source.dart';
import 'providers/studio_provider.dart';

class CmsStudioApp extends StatelessWidget {
  const CmsStudioApp({
    super.key,
    required this.header,
    required this.sidebar,
    required this.dataSource,
  });

  final Widget header;
  final Widget sidebar;

  final CmsDataSource dataSource;

  @override
  Widget build(BuildContext context) {
    return StudioProvider(
      dataSource: dataSource,
      child: CmsStudio(header: header, sidebar: sidebar),
    );
  }
}
