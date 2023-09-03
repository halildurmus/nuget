// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:version/version.dart';

import '../../exceptions/exceptions.dart';
import '../nuget_resource.dart';
import 'models/search_response.dart';

/// The NuGet Search resource, used to search for packages.
///
/// See https://learn.microsoft.com/en-us/nuget/api/search-query-service-resource
final class SearchResource extends NuGetResource {
  SearchResource({super.httpClient, required super.resourceUri});

  /// Retrieves the packages that match the [query].
  ///
  /// [includePrerelease] indicates whether to include pre-release packages in
  /// the results. Defaults to `false`.
  ///
  /// [skip] and [take] parameters are used for pagination. [skip] must be
  /// greater than or equal to `0`. [take] must be greater than `0`.
  ///
  /// Note: `NuGet.org` limits the [skip] parameter to *3,000* and the [take]
  /// parameter to *1,000*.
  ///
  /// Note: An *unlisted* package should never appear in search results.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<SearchResponse> searchPackages(
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
      200 => SearchResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetServerException('Failed to get search packages response: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }
}
