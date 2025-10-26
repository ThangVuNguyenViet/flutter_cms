import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/cross_dataset_reference_field.dart';

@Preview(name: 'CmsCrossDatasetReferenceInput')
Widget preview() => ShadApp(
      home: CmsCrossDatasetReferenceInput(
        field: const CmsCrossDatasetReferenceField(
          name: 'externalAuthor',
          title: 'External Author',
          option: CmsCrossDatasetReferenceOption(
            dataset: 'production',
            to: [
              CmsCrossDatasetReferenceTo(
                type: 'author',
                preview: CmsCrossDatasetReferencePreviewSelect(
                  title: 'name',
                  subtitle: 'email',
                  media: 'avatar',
                ),
              ),
            ],
          ),
        ),
      ),
    );

class CmsCrossDatasetReferenceInput extends StatefulWidget {
  final CmsCrossDatasetReferenceField field;
  final CmsData? data;
  final ValueChanged<String?>? onChanged;

  const CmsCrossDatasetReferenceInput({
    super.key,
    required this.field,
    this.data,
    this.onChanged,
  });

  @override
  State<CmsCrossDatasetReferenceInput> createState() =>
      _CmsCrossDatasetReferenceInputState();
}

class _CmsCrossDatasetReferenceInputState
    extends State<CmsCrossDatasetReferenceInput> {
  String? _selectedType;
  Map<String, List<Map<String, String>>> _dataByType = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.field.option.to.isNotEmpty) {
      _selectedType = widget.field.option.to.first.type;
    }
    _loadReferences();
  }

  Future<void> _loadReferences() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual cross-dataset reference loading
    // For now, showing empty state until backend implementation

    setState(() {
      _dataByType = {};
      _isLoading = false;
    });
  }

  List<Map<String, String>> get _currentReferences {
    return _dataByType[_selectedType] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.title,
            style: theme.textTheme.large.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dataset: ${widget.field.option.dataset}',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          // Type selector if multiple types available
          if (widget.field.option.to.length > 1) ...[
            Text(
              'Reference Type',
              style: theme.textTheme.small,
            ),
            const SizedBox(height: 8),
            ShadSelect<String>(
              placeholder: const Text('Select type...'),
              options: widget.field.option.to
                  .map(
                    (refTo) => ShadOption(
                      value: refTo.type,
                      child: Text(refTo.type),
                    ),
                  )
                  .toList(),
              selectedOptionBuilder: (context, value) => Text(value),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
                widget.onChanged?.call(null);
              },
            ),
            const SizedBox(height: 16),
          ],
          // Reference selector
          Text(
            'Select Reference',
            style: theme.textTheme.small,
          ),
          const SizedBox(height: 8),
          _isLoading
              ? const CircularProgressIndicator()
              : ShadSelect<String>(
                  placeholder: const Text('Select reference...'),
                  options: _currentReferences
                      .map(
                        (ref) => ShadOption(
                          value: ref['id']!,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ref['title']!,
                                style: theme.textTheme.small.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (ref['subtitle'] != null)
                                Text(
                                  ref['subtitle']!,
                                  style: theme.textTheme.small.copyWith(
                                    color: theme.colorScheme.mutedForeground,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  selectedOptionBuilder: (context, value) {
                    final ref = _currentReferences.firstWhere(
                      (r) => r['id'] == value,
                      orElse: () => {'id': '', 'title': ''},
                    );
                    return Text(ref['title'] ?? '');
                  },
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                  },
                ),
        ],
      ),
    );
  }
}
