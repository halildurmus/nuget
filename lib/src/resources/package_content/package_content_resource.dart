import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../exception.dart';
import '../resource.dart';

/// The NuGet Package Content resource, used to retrieve the contents of a
/// package.
///
/// See https://learn.microsoft.com/nuget/api/package-base-address-resource
final class PackageContentResource extends NuGetResource {
  PackageContentResource({required super.resourceUri, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  /// The underlying HTTP client used to make requests.
  final http.Client httpClient;

  /// Closes the underlying HTTP client.
  void close() => httpClient.close();

  /// Returns the contents of the package content (`.nupkg`) file for the
  /// package with the [packageId] and [version].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<Uint8List> downloadPackageContent(
    String packageId, {
    required String version,
  }) async {
    final id = packageId.toLowerCase();
    final uri = resourceUri.replace(pathSegments: [
      ...resourceUri.pathSegments,
      id,
      version,
      '$id.$version.nupkg'
    ]);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      404 => throw PackageNotFoundException(packageId),
      200 => response.bodyBytes,
      _ => throw NuGetServerException(
          'Failed to download package content: '
          '${response.statusCode} ${response.reasonPhrase}',
        ),
    };
  }

  /// Returns the contents of the package manifest (`.nuspec`) file for the
  /// package with the [packageId] and [version].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<Uint8List> downloadPackageManifest(
    String packageId, {
    required String version,
  }) async {
    final id = packageId.toLowerCase();
    final uri = resourceUri.replace(
        pathSegments: [...resourceUri.pathSegments, id, version, '$id.nuspec']);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      404 => throw PackageNotFoundException(packageId),
      200 => response.bodyBytes,
      _ => throw NuGetServerException(
          'Failed to download package manifest: '
          '${response.statusCode} ${response.reasonPhrase}',
        ),
    };
  }

  /// Retrieves the all versions of the [packageId].
  ///
  /// Note: This list contains both *listed* and *unlisted* package versions.
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<List<String>> getPackageVersions(String packageId) async {
    final id = packageId.toLowerCase();
    final uri = resourceUri
        .replace(pathSegments: [...resourceUri.pathSegments, id, 'index.json']);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      404 => throw PackageNotFoundException(packageId),
      200 => ((json.decode(response.body) as Map<dynamic, dynamic>)['versions']
              as List<dynamic>)
          .cast<String>(),
      _ => throw NuGetServerException(
          'Failed to get package versions: '
          '${response.statusCode} ${response.reasonPhrase}',
        ),
    };
  }
}
