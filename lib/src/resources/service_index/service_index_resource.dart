import 'dart:convert';

import '../../exceptions/exceptions.dart';
import '../nuget_resource.dart';
import 'models/service_index_response.dart';

/// The NuGet Service Index client, used to discover other resources.
///
/// See https://docs.microsoft.com/en-us/nuget/api/service-index
final class ServiceIndexResource extends NuGetResource {
  /// Creates a new [ServiceIndexResource] instance.
  ///
  /// [resourceUri] defaults to [nugetOrgServiceIndex], which is the official
  /// `NuGet.org` service index.
  ServiceIndexResource({super.httpClient, required super.resourceUri});

  /// The official `NuGet.org` service index.
  static final nugetOrgServiceIndex =
      Uri.https('api.nuget.org', '/v3/index.json');

  /// Gets the resources available on this package feed.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<ServiceIndexResponse> get() async {
    final response = await httpClient.get(resourceUri);
    return switch (response.statusCode) {
      200 => ServiceIndexResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>),
      _ => throw NuGetProtocolException('Failed to get service index: '
          '${response.statusCode} ${response.reasonPhrase}'),
    };
  }
}
