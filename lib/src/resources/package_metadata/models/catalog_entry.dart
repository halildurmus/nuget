// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dependency_group_item.dart';
import 'package_deprecation.dart';

/// A package's metadata.
///
/// See https://learn.microsoft.com/en-us/nuget/api/registration-base-url-resource#catalog-entry
final class CatalogEntry {
  const CatalogEntry({
    required this.catalogLeafUrl,
    required this.packageId,
    required this.version,
    required this.authors,
    this.dependencyGroups,
    this.deprecation,
    this.description,
    this.iconUrl,
    this.language,
    this.licenseUrl,
    this.listed,
    this.minClientVersion,
    this.packageContentUrl,
    this.projectUrl,
    this.published,
    this.requireLicenseAcceptance,
    this.summary,
    required this.tags,
    this.title,
  });

  /// The URL to the document used to produce this object.
  final String catalogLeafUrl;

  /// The ID of the package.
  final String packageId;

  /// The full NuGet version after normalization, including any SemVer 2.0.0
  /// build metadata.
  final String version;

  /// The package's authors.
  final String authors;

  /// The dependencies of the package, grouped by target framework.
  final List<DependencyGroupItem>? dependencyGroups;

  /// The deprecation associated with the package, if any.
  final PackageDeprecation? deprecation;

  /// The package's description.
  final String? description;

  /// The URL to the package's icon.
  final String? iconUrl;

  /// The package's language.
  final String? language;

  /// The URL to the package's license.
  final String? licenseUrl;

  /// Whether the package is listed in search results.
  ///
  /// If `null`, the package should be considered as listed.
  final bool? listed;

  /// The minimum NuGet client version needed to use this package.
  final String? minClientVersion;

  /// The URL to download the package's content.
  final String? packageContentUrl;

  /// The URL for the package's home page.
  final String? projectUrl;

  /// The package's publish date.
  final DateTime? published;

  /// If true, the package requires its license to be accepted.
  final bool? requireLicenseAcceptance;

  /// The package's summary.
  final String? summary;

  /// The package's tags.
  final String tags;

  /// The package's title.
  final String? title;

  factory CatalogEntry.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          '@id': final String catalogLeafUrl,
          'id': final String packageId,
          'version': final String version,
        }) {
      final authors = json['authors'] is String
          ? json['authors'] as String
          : (json['authors'] as List<dynamic>).cast<String>().join(',');
      final dependencyGroups = (json['dependencyGroups'] as List<dynamic>?)
          ?.map((e) => DependencyGroupItem.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      final deprecation = json['deprecation'] != null
          ? PackageDeprecation.fromJson(
              json['deprecation'] as Map<String, dynamic>)
          : null;
      final description = json['description'] as String?;
      final iconUrl = json['iconUrl'] as String?;
      final language = json['language'] as String?;
      final licenseUrl = json['licenseUrl'] as String?;
      final listed = json['listed'] as bool?;
      final minClientVersion = json['minClientVersion'] as String?;
      final packageContentUrl = json['packageContent'] as String?;
      final projectUrl = json['projectUrl'] as String?;
      final published = json['published'] != null
          ? DateTime.parse(json['published'] as String)
          : null;
      final requireLicenseAcceptance =
          json['requireLicenseAcceptance'] as bool?;
      final summary = json['summary'] as String?;
      final tags = json['tags'] is String
          ? json['tags'] as String
          : (json['tags'] as List<dynamic>).cast<String>().join(',');
      final title = json['title'] as String?;
      return CatalogEntry(
        catalogLeafUrl: catalogLeafUrl,
        packageId: packageId,
        version: version,
        authors: authors,
        dependencyGroups: dependencyGroups,
        deprecation: deprecation,
        description: description,
        iconUrl: iconUrl,
        language: language,
        licenseUrl: licenseUrl,
        listed: listed,
        minClientVersion: minClientVersion,
        packageContentUrl: packageContentUrl,
        projectUrl: projectUrl,
        published: published,
        requireLicenseAcceptance: requireLicenseAcceptance,
        summary: summary,
        tags: tags,
        title: title,
      );
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() => 'PackageMetadata(catalogLeafUrl: $catalogLeafUrl, '
      'packageId: $packageId, version: $version, authors: $authors, '
      'dependencyGroups: $dependencyGroups, deprecation: $deprecation, '
      'description: $description, iconUrl: $iconUrl, language: $language, '
      'licenseUrl: $licenseUrl, listed: $listed, '
      'minClientVersion: $minClientVersion, '
      'packageContentUrl: $packageContentUrl, projectUrl: $projectUrl, '
      'published: $published, '
      'requireLicenseAcceptance: $requireLicenseAcceptance, summary: $summary, '
      'tags: $tags, title: $title)';
}

extension CatalogEntryHelpers on CatalogEntry {
  /// Whether this package metadata represents a listed package.
  bool get isListed {
    if (listed != null) return listed!;

    // A published year of 1900 indicates that this package is unlisted, when
    // the listed property itself is not present (legacy behavior).
    return published?.year != 1900;
  }
}
