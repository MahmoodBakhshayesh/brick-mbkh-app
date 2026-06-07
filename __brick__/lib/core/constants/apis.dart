class Apis {
  Apis._();

  /// Configured at project generation via Mason `base_url`.
  static const String _origin = '{{base_url}}';

  static const String baseUrl = '$_origin/api/';
  static const String photoBaseUr = _origin;
}
