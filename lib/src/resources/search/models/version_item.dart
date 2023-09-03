/// A resource in the `versions` List from `SearchEntry` class.
///
/// See https://learn.microsoft.com/en-us/nuget/api/search-query-service-resource#search-result
final class VersionItem {
  const VersionItem({
    required this.registrationLeafUrl,
    required this.version,
    required this.downloads,
  });

  /// The absolute URL to the associated registration leaf
  final String registrationLeafUrl;

  /// The full SemVer 2.0.0 version string of the package (could contain build
  /// metadata).
  final String version;

  /// The number of downloads for this specific package version.
  final int downloads;

  factory VersionItem.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          '@id': final String registrationLeafUrl,
          'version': final String version,
          'downloads': final int downloads
        }) {
      return VersionItem(
        registrationLeafUrl: registrationLeafUrl,
        version: version,
        downloads: downloads,
      );
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() => 'VersionItem(registrationLeafUrl: $registrationLeafUrl, '
      'version: $version, downloads: $downloads)';
}
