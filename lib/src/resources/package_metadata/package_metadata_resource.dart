// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

import '../../exception.dart';
import '../resource.dart';
import 'models/registration_index_response.dart';
import 'models/registration_leaf_response.dart';
import 'models/registration_page_response.dart';

/// The NuGet Package Metadata resource, used to retrieve metadata about
/// packages.
///
/// See https://learn.microsoft.com/nuget/api/registration-base-url-resource
final class PackageMetadataResource extends NuGetResource {
  PackageMetadataResource({super.httpClient, required super.resourceUri});

  /// Retrieves the registration index for the package with the [packageId].
  ///
  /// Throws a [PackageNotFoundException] if the package does not exist.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<RegistrationIndexResponse> getRegistrationIndex(
    String packageId,
  ) async {
    final id = packageId.toLowerCase();
    final uri = resourceUri
        .replace(pathSegments: [...resourceUri.pathSegments, id, 'index.json']);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      404 => throw PackageNotFoundException(packageId),
      200 => RegistrationIndexResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetServerException('Failed to get registration index: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }

  /// Retrieves the registration page for the specified [pageUrl].
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<RegistrationPageResponse> getRegistrationPage(String pageUrl) async {
    final uri = Uri.parse(pageUrl);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      200 => RegistrationPageResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetServerException('Failed to get registration page: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }

  /// Retrieves the registration leaf for the specified [leafUrl].
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<RegistrationLeafResponse> getRegistrationLeaf(String leafUrl) async {
    final uri = Uri.parse(leafUrl);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      200 => RegistrationLeafResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetServerException('Failed to get registration leaf: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }
}
