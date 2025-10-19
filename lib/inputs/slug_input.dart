import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/slug_field.dart';

@Preview(name: 'CmsSlugInput')
Widget preview() => ShadApp(
      home: CmsSlugInput(
        field: const CmsSlugField(
          name: 'slug',
          title: 'URL Slug',
          option: CmsSlugOption(source: 'title', maxLength: 96),
        ),
      ),
    );

class CmsSlugInput extends StatefulWidget {
  final CmsSlugField field;
  final CmsData? data;

  const CmsSlugInput({super.key, required this.field, this.data});

  @override
  State<CmsSlugInput> createState() => _CmsSlugInputState();
}

class _CmsSlugInputState extends State<CmsSlugInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data?.value?.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _slugify(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShadInputFormField(
          controller: _controller,
          label: Text(widget.field.title),
          placeholder: const Text('url-friendly-slug'),
          description: Text(
            'Source: ${widget.field.option.source}. Max length: ${widget.field.option.maxLength}',
          ),
          maxLength: widget.field.option.maxLength,
          onChanged: (value) {
            final slugified = _slugify(value);
            if (value != slugified) {
              _controller.value = TextEditingValue(
                text: slugified,
                selection: TextSelection.collapsed(offset: slugified.length),
              );
            }
          },
          validator: (value) {
            if (value.isEmpty) {
              return null;
            }
            if (value.length > widget.field.option.maxLength) {
              return 'Slug must be ${widget.field.option.maxLength} characters or less';
            }
            if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
              return 'Slug must contain only lowercase letters, numbers, and hyphens';
            }
            return null;
          },
        ),
      ],
    );
  }
}
