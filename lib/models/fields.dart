abstract class CmsOption {
  // Abstract class for options, can be extended later for specific option types
  const CmsOption({this.hidden = false});

  final bool hidden;
}

abstract class CmsField {
  final String name;
  final String title;
  final CmsOption option;

  const CmsField({
    required this.name,
    required this.title,
    required this.option,
  });
}

abstract class CmsFieldConfig {
  // Abstract class for field configurations, can be extended later
  const CmsFieldConfig({this.name, this.title, this.option});

  final String? name;
  final String? title;
  final CmsOption? option;

  List<Type> get supportedFieldTypes;
}