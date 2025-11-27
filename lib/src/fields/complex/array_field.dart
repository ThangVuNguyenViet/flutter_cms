import 'package:flutter/material.dart';

import '../base/field.dart';

abstract class CmsArrayOption extends CmsOption {
  const CmsArrayOption({super.hidden});

  CmsArrayFieldItemBuilder get itemBuilder;
  CmsArrayFieldItemEditor get itemEditor;
}

class CmsArrayField extends CmsField {
  const CmsArrayField({
    required super.name,
    required super.title,
    super.description,
    required CmsArrayOption super.option,
  });

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

typedef CmsArrayFieldItemBuilder =
    Widget Function(BuildContext context, dynamic value);
typedef CmsArrayFieldItemEditor =
    Widget Function(
      BuildContext context,
      dynamic value,
      ValueChanged<dynamic>? onChanged,
    );
