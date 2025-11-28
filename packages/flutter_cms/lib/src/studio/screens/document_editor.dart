import 'package:flutter/material.dart';
import 'package:flutter_cms_annotation/flutter_cms_annotation.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../components/forms/cms_form.dart';
import '../core/signals/cms_signals.dart';

/// Document editor widget that dynamically generates forms based on fields
class CmsDocumentEditor extends StatefulWidget {
  final List<CmsField> fields;
  final String? title;
  final String? description;
  final String documentId;

  const CmsDocumentEditor({
    super.key,
    required this.fields,
    this.title,
    this.description,
    required this.documentId,
  });

  @override
  State<CmsDocumentEditor> createState() => _CmsDocumentEditorState();
}

class _CmsDocumentEditorState extends State<CmsDocumentEditor> {
  Future<void> _saveDocument() async {
    try {
      // Save the current document using the signal's save functionality
      selectedDocumentSignal.saveCurrentDocument();

      if (mounted) {
        ShadToaster.of(context).show(
          const ShadToast(description: Text('Document saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(
          context,
        ).show(ShadToast(description: Text('Failed to save: $e')));
      }
    }
  }

  Future<void> _discardDocument() async {
    try {
      // Reset document to its original state by reloading it
      final selectedDoc = selectedDocumentSignal.value;
      if (selectedDoc?.defaultValue != null) {
        // Reset to default values
        final defaultInstance = selectedDoc!.defaultValue!;
        documentDataSignal.value = defaultInstance.toMap();
      } else {
        // Clear document data
        documentDataSignal.clear();
      }

      if (mounted) {
        ShadToaster.of(
          context,
        ).show(const ShadToast(description: Text('Changes discarded')));
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(
          context,
        ).show(ShadToast(description: Text('Failed to discard: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context, child) {
        final documentData = documentDataSignal.value;
        return CmsForm(
          fields: widget.fields,
          data: Map<String, dynamic>.from(documentData),
          title: widget.title,
          description: widget.description,
          onSave: _saveDocument,
          onDiscard: _discardDocument,
        );
      },
    );
  }
}
