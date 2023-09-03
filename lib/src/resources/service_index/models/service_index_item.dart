/// A resource in the `resources` List from `ServiceIndexResponse` class.
///
/// See https://docs.microsoft.com/en-us/nuget/api/service-index#resources
final class ServiceIndexItem {
  const ServiceIndexItem({
    required this.resourceUrl,
    required this.type,
    required this.comment,
  });

  /// The URL to the resource.
  final String resourceUrl;

  /// A string constant representing the resource type.
  final String type;

  /// A human readable description of the resource.
  final String? comment;

  factory ServiceIndexItem.fromJson(Map<String, dynamic> json) {
    if (json
        case {'@id': final String resourceUrl, '@type': final String type}) {
      final comment = json['comment'] as String?;
      return ServiceIndexItem(
          resourceUrl: resourceUrl, type: type, comment: comment);
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() =>
      'ServiceIndexItem(resourceUrl: $resourceUrl, type: $type, '
      'comment: $comment)';
}
