// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

import '../../exception.dart';
import '../resource.dart';
import 'models/service_index_response.dart';

/// The NuGet Service Index resource, used to discover other resources.
///
/// See https://learn.microsoft.com/nuget/api/service-index
final class ServiceIndexResource extends NuGetResource {
  /// Creates a new instance of the [ServiceIndexResource] class.
  ///
  /// [resourceUri] defaults to [nugetOrgServiceIndex], which is the official
  /// `NuGet.org` service index.
  ServiceIndexResource({super.httpClient, required super.resourceUri});

  /// The official `NuGet.org` service index.
  static final nugetOrgServiceIndex =
      Uri.https('api.nuget.org', '/v3/index.json');

  /// Retrieves the resources available on the package feed defined in
  /// [resourceUri].
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<ServiceIndexResponse> get() async {
    final response = await httpClient.get(resourceUri);
    return switch (response.statusCode) {
      200 => ServiceIndexResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetServerException('Failed to get service index: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }
}
