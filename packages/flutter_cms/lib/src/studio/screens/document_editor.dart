import 'package:flutter/material.dart';
import 'package:flutter_cms_annotation/flutter_cms_annotation.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../data/models/document_version.dart';
import '../components/forms/cms_form.dart';
import '../core/cms_provider.dart';

/// Document editor widget that dynamically generates forms based on fields
class CmsDocumentEditor extends StatefulWidget {
  final List<CmsField> fields;
  final String? title;
  final String? description;

  const CmsDocumentEditor({
    super.key,
    required this.fields,
    this.title,
    this.description,
  });

  @override
  State<CmsDocumentEditor> createState() => _CmsDocumentEditorState();
}

class _CmsDocumentEditorState extends State<CmsDocumentEditor> {
  /// Local state for form data that can be edited
  Map<String, dynamic> _formData = {};

  /// Whether we have unsaved changes
  bool _hasUnsavedChanges = false;

  /// Track the last version ID to detect when we need to reset form data
  int? _lastVersionId;

  Future<void> _saveDocument() async {
    final viewModel = CmsProvider.of(context);
    try {
      final versionId = viewModel.selectedVersionId.value;

      if (versionId != null) {
        // Update existing version
        await viewModel.updateVersion(_formData);
      } else {
        // Create new document with initial version
        // Extract title from form data or use default
        final title = _formData['title']?.toString() ?? 'Untitled Document';
        final slug = _formData['slug']?.toString();
        await viewModel.createDocument(title, _formData, slug: slug);
      }

      setState(() {
        _hasUnsavedChanges = false;
      });

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
      final viewModel = CmsProvider.of(context);
      // Reset form data to the version data or defaults
      final versionState = viewModel.selectedDocumentData.state;
      if (versionState.isReady && versionState.value != null) {
        setState(() {
          _formData = Map<String, dynamic>.from(versionState.value!.data);
          _hasUnsavedChanges = false;
        });
      } else {
        // Reset to default values
        final selectedDoc = viewModel.selectedDocumentType.value;
        if (selectedDoc?.defaultValue != null) {
          final defaultInstance = selectedDoc!.defaultValue!;
          setState(() {
            _formData = defaultInstance.toMap();
            _hasUnsavedChanges = false;
          });
        } else {
          setState(() {
            _formData = {};
            _hasUnsavedChanges = false;
          });
        }
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

  void _onFieldChanged(String fieldName, dynamic value) {
    setState(() {
      _formData[fieldName] = value;
      _hasUnsavedChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = CmsProvider.of(context);

    return SignalBuilder(
      builder: (context, child) {
        final isSaving = viewModel.isSaving.value;
        final versionState = viewModel.selectedDocumentData.state;
        final currentVersionId = viewModel.selectedVersionId.value;

        return versionState.when<Widget>(
          loading: () => const Center(child: ShadProgress()),
          error: (error, stackTrace) => Center(
            child: Text('Error loading document: $error'),
          ),
          ready: (versionData) {
            // Initialize form data from version data when version changes
            if (currentVersionId != _lastVersionId) {
              _lastVersionId = currentVersionId;
              if (versionData != null) {
                // Schedule the state update for after build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _formData = Map<String, dynamic>.from(versionData.data);
                      _hasUnsavedChanges = false;
                    });
                  }
                });
              } else {
                // No version selected - reset to defaults
                final selectedDoc = viewModel.selectedDocumentType.value;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _formData =
                          selectedDoc?.defaultValue?.toMap() ??
                          <String, dynamic>{};
                      _hasUnsavedChanges = false;
                    });
                  }
                });
              }
            }

            return _buildEditor(versionData, isSaving, _hasUnsavedChanges);
          },
        );
      },
    );
  }

  Widget _buildEditor(
    DocumentVersion? versionData,
    bool isSaving,
    bool hasUnsavedChanges,
  ) {
    // Use form data if available, otherwise use version data or empty map
    final displayData =
        _formData.isNotEmpty
            ? _formData
            : (versionData?.data ?? <String, dynamic>{});

    return Stack(
      children: [
        CmsForm(
          fields: widget.fields,
          data: Map<String, dynamic>.from(displayData),
          title: widget.title,
          description: widget.description,
          onSave: isSaving ? null : _saveDocument,
          onDiscard: isSaving || !hasUnsavedChanges ? null : _discardDocument,
          onFieldChanged: _onFieldChanged,
        ),
        if (isSaving)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: ShadProgress()),
            ),
          ),
      ],
    );
  }
}
