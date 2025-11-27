import 'package:flutter/widgets.dart';
import 'package:flutter_cms_annotation/flutter_cms_annotation.dart';

/// A Flutter widget builder for CMS data.
///
/// [CmsDataBuilder] provides a convenient way to build widgets
/// from [CmsData] values.
class CmsDataBuilder<T> extends StatelessWidget {
  const CmsDataBuilder({super.key, required this.builder, required this.data});
  final Widget Function(T value) builder;
  final CmsData<T> data;
  @override
  Widget build(BuildContext context) {
    return builder(data.value);
  }
}
