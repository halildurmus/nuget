import 'version_item.dart';

/// A resource in the `data` List from the `SearchResponse` class.
///
/// See https://learn.microsoft.com/nuget/api/search-query-service-resource#search-result
final class SearchEntry {
  const SearchEntry({
    required this.packageId,
    required this.version,
    required this.versions,
    required this.authors,
    required this.tags,
    this.description,
    this.iconUrl,
    this.licenseUrl,
    this.owners,
    this.projectUrl,
    this.registration,
    this.summary,
    this.title,
    this.totalDownloads,
    this.verified,
  });

  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': final String packageId,
          'version': final String version,
          'versions': final List<dynamic> versionsVal,
        }) {
      final versions = versionsVal
          .map((e) => VersionItem.fromJson(e as Map<String, dynamic>))
          .toList();
      final description = json['description'] as String?;
      final authors = json['authors'] is String
          ? json['authors'] as String
          : (json['authors'] as List<dynamic>).cast<String>().join(',');
      final iconUrl = json['iconUrl'] as String?;
      final licenseUrl = json['licenseUrl'] as String?;
      final owners = json['owners'] == null
          ? null
          : json['owners'] is String
              ? json['owners'] as String
              : (json['owners'] as List<dynamic>).cast<String>().join(',');
      final projectUrl = json['projectUrl'] as String?;
      final registration = json['registration'] as String?;
      final summary = json['summary'] as String?;
      final tags = json['tags'] is String
          ? json['tags'] as String
          : (json['tags'] as List<dynamic>).cast<String>().join(',');
      final title = json['title'] as String?;
      final totalDownloads = json['totalDownloads'] as int?;
      final verified = json['verified'] as bool?;
      return SearchEntry(
        packageId: packageId,
        version: version,
        versions: versions,
        description: description,
        authors: authors,
        iconUrl: iconUrl,
        licenseUrl: licenseUrl,
        owners: owners,
        projectUrl: projectUrl,
        registration: registration,
        summary: summary,
        tags: tags,
        title: title,
        totalDownloads: totalDownloads,
        verified: verified,
      );
    }
    throw FormatException('Invalid JSON: $json');
  }

  /// The ID of the package.
  final String packageId;

  /// The full NuGet version after normalization, including any SemVer 2.0.0
  /// build metadata.
  final String version;

  /// All of the versions of the package matching the prerelease parameter.
  final List<VersionItem> versions;

  /// The package's description.
  final String? description;

  /// The package's authors.
  final String authors;

  /// The URL to the package's icon.
  final String? iconUrl;

  /// The URL to the package's license.
  final String? licenseUrl;

  final String? owners;

  /// The URL for the package's home page.
  final String? projectUrl;

  /// The absolute URL to the associated registration index.
  final String? registration;

  /// The package's summary.
  final String? summary;

  /// The package's tags.
  final String tags;

  /// The package's title.
  final String? title;

  /// This value can be inferred by the sum of downloads in the [versions] List.
  final int? totalDownloads;

  /// Whether the package is verified.
  final bool? verified;

  @override
  String toString() => 'SearchEntry(packageId: $packageId, version: $version, '
      'versions: $versions, description: $description, authors: $authors, '
      'iconUrl: $iconUrl, licenseUrl: $licenseUrl, owners: $owners, '
      'projectUrl: $projectUrl, registration: $registration, '
      'summary: $summary, tags: $tags, title: $title, '
      'totalDownloads: $totalDownloads, verified: $verified)';
}
