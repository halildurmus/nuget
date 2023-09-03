import 'dart:convert';
import 'dart:typed_data';

import '../../exceptions/exceptions.dart';
import '../nuget_resource.dart';

final class PackageContentResource extends NuGetResource {
  PackageContentResource({super.httpClient, required super.resourceUri});

  /// Returns the package content (`.nupkg`) for the [packageId] and [version]
  /// as a [Uint8List].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
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
      _ => throw NuGetProtocolException('Failed to download package content: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }

  /// Returns the package manifest (`.nuspec`) for the [packageId] and [version]
  /// as a [Uint8List].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
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
      _ => throw NuGetProtocolException('Failed to download package manifest: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }

  /// Gets the all versions of the [packageId].
  ///
  /// Note: This list contains both *listed* and *unlisted* package versions.
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<List<String>> getPackageVersions(String packageId) async {
    final id = packageId.toLowerCase();
    final uri = resourceUri
        .replace(pathSegments: [...resourceUri.pathSegments, id, 'index.json']);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      404 => throw PackageNotFoundException(packageId),
      200 => (json.decode(response.body)['versions'] as List<dynamic>)
          .cast<String>(),
      _ => throw NuGetProtocolException('Failed to get package versions: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }
}
