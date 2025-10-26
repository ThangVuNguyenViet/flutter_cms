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
  final ValueChanged<String?>? onChanged;

  const CmsSlugInput({
    super.key,
    required this.field,
    this.data,
    this.onChanged,
  });

  @override
  State<CmsSlugInput> createState() => _CmsSlugInputState();
}

class _CmsSlugInputState extends State<CmsSlugInput> {
  late final TextEditingController _controller;
  late final UndoHistoryController _undoController;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    final initialText = widget.data?.value?.toString() ?? '';
    _controller = TextEditingController(text: initialText);
    _undoController = UndoHistoryController();

    // Listen to text changes
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final value = _controller.text;
    final slugified = _slugify(value);

    // Update controller if slugification changed the text
    if (value != slugified) {
      _controller.text = slugified;
      _controller.selection = TextSelection.collapsed(offset: slugified.length);
    }

    _validateSlug(slugified);
    widget.onChanged?.call(slugified);
  }

  String _slugify(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  void _validateSlug(String value) {
    if (value.isEmpty) {
      setState(() => _validationError = null);
      return;
    }
    if (value.length > widget.field.option.maxLength) {
      setState(() => _validationError = 'Slug must be ${widget.field.option.maxLength} characters or less');
    } else if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
      setState(() => _validationError = 'Slug must contain only lowercase letters, numbers, and hyphens');
    } else {
      setState(() => _validationError = null);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _undoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    return ShadInputFormField(
      controller: _controller,
      undoController: _undoController,
      label: Text(widget.field.title),
      placeholder: const Text('url-friendly-slug'),
      description: Text('Source: ${widget.field.option.source}. Max length: ${widget.field.option.maxLength}'),
      maxLines: 1,
      error: _validationError != null ? (_) => Text(_validationError!) : null,
    );
  }
}
