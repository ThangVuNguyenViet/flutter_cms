import 'package:flutter/material.dart';
import 'package:flutter_cms/models/fields.dart';

class CmsArrayOption extends CmsOption {
  const CmsArrayOption({super.hidden});
}

class CmsArrayField extends CmsField {
  const CmsArrayField({
    required super.name,
    required super.title,
    super.description,
    CmsArrayOption? super.option,
    required this.itemBuilder,
  });

  final CmsArrayFieldItemBuilder<dynamic> itemBuilder;

  @override
  CmsArrayOption get option => super.option as CmsArrayOption;
}

class CmsArrayFieldConfig<T extends Object?> extends CmsFieldConfig {
  const CmsArrayFieldConfig({
    super.name,
    super.title,
    super.description,
    CmsArrayOption? super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [List];
}

typedef CmsArrayFieldItemBuilder<T> =
    Widget Function(BuildContext context, T value);
