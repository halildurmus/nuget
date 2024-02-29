// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:version/version.dart';

import '../../exception.dart';
import '../resource.dart';
import 'models/autocomplete_package_ids_response.dart';

/// The NuGet Autocomplete resource, used to retrieve package IDs and versions
/// that match a query.
///
/// See also:
/// https://learn.microsoft.com/nuget/api/search-autocomplete-service-resource
final class AutocompleteResource extends NuGetResource {
  AutocompleteResource({super.httpClient, required super.resourceUri});

  /// Retrieves the package IDs that match the [query].
  ///
  /// [includePrerelease] indicates whether to include *pre-release* packages in
  /// the results. Defaults to `false`.
  ///
  /// [skip] represents the number of results to skip, for pagination. It must
  /// be greater than or equal to `0`.
  ///
  /// [take] represents the number of results to return, for pagination. It must
  /// be greater than `0`.
  ///
  /// Note: A package with only *unlisted* versions will not appear in the
  /// results.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<AutocompletePackageIdsResponse> autocompletePackageIds(
    String? query, {
    bool includePrerelease = false,
    bool includeSemVer2 = true,
    int? skip,
    int? take,
  }) async {
    if (skip != null) RangeError.checkNotNegative(skip, 'skip');

    if (take != null && take <= 0) {
      throw RangeError.value(take, 'take', 'Must be greater than 0');
    }

    final uri = resourceUri.replace(
      queryParameters: {
        if (query != null) 'q': query,
        if (skip != null) 'skip': '$skip',
        if (take != null) 'take': '$take',
        'prerelease': '$includePrerelease',
        if (includeSemVer2) 'semVerLevel': Version(2, 0, 0).toString(),
      },
    );
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      200 => AutocompletePackageIdsResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetServerException(
          'Failed to get autocomplete package IDs results: '
          '${response.statusCode} ${response.reasonPhrase}',
        ),
    };
  }

  /// Retrieves the package versions for the [packageId].
  ///
  /// [includePrerelease] indicates whether to include *pre-release* versions in
  /// the results. Defaults to `false`.
  ///
  /// Note: A package version that is *unlisted* will not appear in the results.
  ///
  /// Returns an empty list if the package does not exist.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<List<String>> autocompletePackageVersions(
    String packageId, {
    bool includePrerelease = false,
    bool includeSemVer2 = true,
  }) async {
    final id = packageId.toLowerCase();
    final uri = resourceUri.replace(
      queryParameters: {
        'id': id,
        'prerelease': '$includePrerelease',
        if (includeSemVer2) 'semVerLevel': Version(2, 0, 0).toString(),
      },
    );
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      200 =>
        (json.decode(response.body)['data'] as List<dynamic>).cast<String>(),
      _ => throw NuGetServerException(
          'Failed to get autocomplete package versions results: '
          '${response.statusCode} ${response.reasonPhrase}',
        ),
    };
  }
}
