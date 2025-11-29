import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../core/cms_provider.dart';
import '../common/cms_document_type_decoration.dart';
import '../common/cms_document_type_item.dart';

/// A sidebar widget that displays a list of CmsDocumentTypeDecoration navigation items
class CmsDocumentTypeSidebar extends StatefulWidget {
  final List<CmsDocumentTypeDecoration> documentTypeDecorations;
  final EdgeInsets? padding;
  final Widget? header;
  final Widget? footer;

  const CmsDocumentTypeSidebar({
    super.key,
    required this.documentTypeDecorations,
    this.padding,
    this.header,
    this.footer,
  });

  @override
  State<CmsDocumentTypeSidebar> createState() => _CmsDocumentTypeSidebarState();
}

class _CmsDocumentTypeSidebarState extends State<CmsDocumentTypeSidebar> {
  @override
  void initState() {
    super.initState();
    // Auto-select the first document type if none is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = CmsProvider.of(context);
      if (widget.documentTypeDecorations.isNotEmpty &&
          viewModel.selectedDocumentType.value == null) {
        viewModel.selectDocumentType(
          widget.documentTypeDecorations.first.documentType,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = CmsProvider.of(context);

    return Watch((context) {
      final selectedDocument = viewModel.selectedDocumentType.value;
      return Column(
          children: [
            if (widget.header != null) widget.header!,
            Expanded(
              child: ListView(
                padding: widget.padding ?? const EdgeInsets.all(8),
                children: [
                  ...widget.documentTypeDecorations.map((decoration) {
                    final isSelected =
                        selectedDocument?.name == decoration.documentType.name;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: CmsDocumentTypeItem(
                        documentType: decoration.documentType,
                        isSelected: isSelected,
                        icon: decoration.icon,
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (widget.footer != null) widget.footer!,
          ],
        );
    });
  }
}
