import 'package:flutter/widgets.dart';

class CmsData<T> {
  final T value;
  final String path;

  const CmsData({required this.value, required this.path});
}

class CmsDataBuilder<T> extends StatelessWidget {
  const CmsDataBuilder({super.key, required this.builder, required this.data});

  final Widget Function(T value) builder;
  final CmsData<T> data;

  @override
  Widget build(BuildContext context) {
    return builder(data.value);
  }
}
