import 'package:flutter_cms/models/fields.dart';

class CmsCrossDatasetReferencePreviewSelect {
  final String title;
  final String? subtitle;
  final String? media;

  const CmsCrossDatasetReferencePreviewSelect({
    required this.title,
    this.subtitle,
    this.media,
  });
}

class CmsCrossDatasetReferenceTo {
  final String type;
  final CmsCrossDatasetReferencePreviewSelect? preview;

  const CmsCrossDatasetReferenceTo({
    required this.type,
    this.preview,
  });
}

class CmsCrossDatasetReferenceOption extends CmsOption {
  final String dataset;
  final List<CmsCrossDatasetReferenceTo> to;

  const CmsCrossDatasetReferenceOption({
    required this.dataset,
    required this.to,
    super.hidden,
  });
}

class CmsCrossDatasetReferenceField extends CmsField {
  const CmsCrossDatasetReferenceField({
    required super.name,
    required super.title,
    required CmsCrossDatasetReferenceOption super.option,
  });

  @override
  CmsCrossDatasetReferenceOption get option =>
      super.option as CmsCrossDatasetReferenceOption;
}

class CmsCrossDatasetReferenceFieldConfig extends CmsFieldConfig {
  const CmsCrossDatasetReferenceFieldConfig({
    super.name,
    super.title,
    CmsCrossDatasetReferenceOption super.option = const CmsCrossDatasetReferenceOption(dataset: '', to: []), // Default empty
  });

  @override
  List<Type> get supportedFieldTypes => [Object]; // Represents a reference to another dataset
}
