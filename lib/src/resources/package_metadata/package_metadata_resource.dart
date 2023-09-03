import 'dart:convert';

import '../../exceptions/exceptions.dart';
import '../nuget_resource.dart';
import 'models/registration_index_response.dart';
import 'models/registration_leaf_response.dart';
import 'models/registration_page_response.dart';

///
///
/// Note: [PackageMetadataResource] does not contain all metadata for packages.
/// Use the `SearchResource` to find packages' owners, downloads, or prefix
/// reservation status.
final class PackageMetadataResource extends NuGetResource {
  PackageMetadataResource({super.httpClient, required super.resourceUri});

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
      _ => throw NuGetProtocolException('Failed to get registration index: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }

  Future<RegistrationPageResponse> getRegistrationPage(String pageUrl) async {
    final uri = Uri.parse(pageUrl);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      200 => RegistrationPageResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetProtocolException('Failed to get registration page: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }

  Future<RegistrationLeafResponse> getRegistrationLeaf(String leafUrl) async {
    final uri = Uri.parse(leafUrl);
    final response = await httpClient.get(uri);
    return switch (response.statusCode) {
      200 => RegistrationLeafResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetProtocolException('Failed to get registration leaf: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }
}
