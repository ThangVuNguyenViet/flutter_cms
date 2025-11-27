/// A generic container for CMS data with metadata.
///
/// [CmsData] wraps a value of type [T] along with its path
/// in the CMS data structure.
class CmsData<T> {
  /// The actual data value.
  final T value;

  /// The path to this data in the CMS structure.
  final String path;

  const CmsData({required this.value, required this.path});
}
