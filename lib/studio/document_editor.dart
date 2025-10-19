import 'package:flutter/material.dart';

import '../models/fields.dart';
import 'cms_form.dart';

/// Document editor widget that dynamically generates forms based on field configurations
class CmsDocumentEditor extends StatefulWidget {
  final List<CmsFieldConfig> fields;
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
  Map<String, dynamic> _documentData = {};

  @override
  void initState() {
    super.initState();
    // TODO: Load document data from backend
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    // TODO: Implement actual document loading
    setState(() {
      _documentData = {};
    });
  }

  Future<void> _saveDocument() async {
    // TODO: Implement actual document saving
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document saved')),
      );
    }
  }

  Future<void> _discardDocument() async {
    // TODO: Implement actual document discard
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes discarded')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CmsForm(
      fields: widget.fields,
      data: _documentData,
      title: widget.title,
      description: widget.description,
      onSave: _saveDocument,
      onDiscard: _discardDocument,
    );
  }
}
