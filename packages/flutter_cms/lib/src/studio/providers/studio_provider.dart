import 'package:disco/disco.dart';
import 'package:flutter/material.dart';

import '../../../flutter_cms.dart';
import '../../../studio.dart';
import '../core/view_models/cms_document_view_model.dart';

class StudioProvider extends StatelessWidget {
  const StudioProvider({
    super.key,
    required this.child,
    required this.dataSource,
  });

  final Widget child;
  final CmsDataSource dataSource;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [documentViewModelProvider(dataSource)],
      child: ProviderScope(
        providers: [cmsViewModelProvider(dataSource)],
        child: child,
      ),
    );
  }
}

final documentViewModelProvider = Provider.withArgument(
  (context, CmsDataSource dataSource) => CmsDocumentViewModel(dataSource),
);

final cmsViewModelProvider = Provider.withArgument(
  (context, CmsDataSource dataSource) => CmsViewModel(
    dataSource: dataSource,
    documentViewModel: documentViewModelProvider.of(context),
  ),
);
