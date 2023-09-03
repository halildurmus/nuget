// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Represents the JSON response from the Autocomplete Resource's
/// `Search for package IDs` API.
///
/// See https://learn.microsoft.com/en-us/nuget/api/search-autocomplete-service-resource#response
final class AutocompletePackageIdsResponse {
  const AutocompletePackageIdsResponse({
    required this.totalHits,
    required this.data,
  });

  /// The total number of matches, disregarding `skip` and `take`.
  final int totalHits;

  /// The package IDs matched by the request.
  final List<String> data;

  factory AutocompletePackageIdsResponse.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'totalHits': final int totalHits,
          'data': final List<dynamic> data
        }) {
      return AutocompletePackageIdsResponse(
          totalHits: totalHits, data: data.cast());
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() =>
      'AutocompletePackageIdsResponse(totalHits: $totalHits, data: $data)';
}
