import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/reference_field.dart';

@Preview(name: 'CmsReferenceInput')
Widget preview() => ShadApp(
      home: CmsReferenceInput(
        field: const CmsReferenceField(
          name: 'author',
          title: 'Author',
          option: CmsReferenceOption(
            to: CmsReferenceTo(type: 'author'),
          ),
        ),
      ),
    );

class CmsReferenceInput extends StatefulWidget {
  final CmsReferenceField field;
  final CmsData? data;
  final ValueChanged<String?>? onChanged;

  const CmsReferenceInput({super.key, required this.field, this.data, this.onChanged});

  @override
  State<CmsReferenceInput> createState() => _CmsReferenceInputState();
}

class _CmsReferenceInputState extends State<CmsReferenceInput> {
  List<Map<String, String>> _references = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  Future<void> _loadReferences() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual reference loading
    // For now, showing empty state until backend implementation

    setState(() {
      _references = [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.title,
          style: theme.textTheme.small,
        ),
        const SizedBox(height: 8),
        _isLoading
            ? const CircularProgressIndicator()
            : ShadSelect<String>(
                placeholder: Text('Select ${widget.field.option.to.type}...'),
                options: _references
                    .map(
                      (ref) => ShadOption(
                        value: ref['id']!,
                        child: Text(ref['title']!),
                      ),
                    )
                    .toList(),
                selectedOptionBuilder: (context, value) {
                  final ref = _references.firstWhere(
                    (r) => r['id'] == value,
                    orElse: () => {'id': '', 'title': ''},
                  );
                  return Text(ref['title'] ?? '');
                },
                onChanged: (value) {
                  widget.onChanged?.call(value);
                },
              ),
        const SizedBox(height: 8),
        Text(
          'Reference type: ${widget.field.option.to.type}',
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
