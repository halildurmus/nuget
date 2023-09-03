// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'catalog_entry.dart';

///
///
/// Note: On `NuGet.org`, the [published] value is set to year `1900` when the
/// package is *unlisted*.
class RegistrationLeafResponse {
  RegistrationLeafResponse({
    required this.registrationLeafUrl,
    required this.catalogEntry,
    required this.listed,
    required this.packageContent,
    required this.published,
    required this.registration,
  });

  /// The URL to the registration leaf.
  final String registrationLeafUrl;

  ///	The URL to the catalog entry that produced these leaf.
  final CatalogEntry? catalogEntry;

  /// Whether the package is listed in search results.
  ///
  /// If `null`, the package should be considered as listed.
  final bool? listed;

  /// The URL to the package content (.nupkg).
  final String? packageContent;

  /// When the package was published.
  final DateTime? published;

  /// The URL to the registration index.
  final String? registration;

  factory RegistrationLeafResponse.fromJson(Map<String, dynamic> json) {
    if (json case {'@id': final String registrationLeafUrl}) {
      final catalogEntry = json['catalogEntry'] != null
          ? CatalogEntry.fromJson(json['catalogEntry'] as Map<String, dynamic>)
          : null;
      final listed = json['listed'] as bool?;
      final packageContent = json['packageContent'] as String?;
      final published = json['published'] != null
          ? DateTime.parse(json['published'] as String)
          : null;
      final registration = json['registration'] as String?;
      return RegistrationLeafResponse(
        registrationLeafUrl: registrationLeafUrl,
        catalogEntry: catalogEntry,
        listed: listed,
        packageContent: packageContent,
        published: published,
        registration: registration,
      );
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() => 'RegistrationLeafResponse('
      'registrationLeafUrl: $registrationLeafUrl, catalogEntry: $catalogEntry, '
      'listed: $listed, packageContent: $packageContent, '
      'published: $published, registration: $registration)';
}
