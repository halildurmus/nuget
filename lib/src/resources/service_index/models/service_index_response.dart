import 'package:version/version.dart';

import '../../../exception.dart';
import 'service_index_item.dart';

/// Represents the response from the Service Index resource.
///
/// See https://learn.microsoft.com/nuget/api/service-index
final class ServiceIndexResponse {
  const ServiceIndexResponse({required this.version, required this.resources});

  factory ServiceIndexResponse.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'version': final String version,
          'resources': final List<dynamic> resourcesVal
        }) {
      final resources = resourcesVal
          .map((e) => ServiceIndexItem.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      return ServiceIndexResponse(version: version, resources: resources);
    }
    throw FormatException('Invalid JSON: $json');
  }

  /// The schema version of the service index.
  final String version;

  /// The endpoints or capabilities of the package source.
  final List<ServiceIndexItem> resources;

  @override
  String toString() =>
      'ServiceIndexResponse(version: $version, resources: $resources)';
}

extension ServiceIndexResponseHelpers on ServiceIndexResponse {
  static final version300beta = Version(3, 0, 0, preRelease: ['beta']);
  static final version300 = Version(3, 0, 0);
  static final version340 = Version(3, 4, 0);
  static final version350 = Version(3, 5, 0);
  static final version360 = Version(3, 6, 0);

  static final catalogTypes = <String>['Catalog/$version300'];
  static final packageBaseAddressTypes = <String>[
    'PackageBaseAddress/$version300'
  ];
  static final registrationsBaseUrlTypes = <String>[
    'RegistrationsBaseUrl/$version360',
    'RegistrationsBaseUrl/$version340',
    'RegistrationsBaseUrl/$version300beta',
    'RegistrationsBaseUrl'
  ];
  static final searchAutocompleteServiceTypes = <String>[
    'SearchAutocompleteService/$version350',
    'SearchAutocompleteService/$version300beta',
    'SearchAutocompleteService'
  ];
  static final searchQueryServiceTypes = <String>[
    'SearchQueryService/$version350',
    'SearchQueryService/$version300beta',
    'SearchQueryService'
  ];

  /// The resource [Uri] for the *Catalog* resource.
  Uri? get catalogResourceUri => getResourceUri(catalogTypes);

  /// The resource [Uri] for the *Package Content* resource.
  Uri get packageContentResourceUri =>
      getRequiredResourceUri(packageBaseAddressTypes);

  /// The resource [Uri] for the *Package Metadata* resource.
  Uri get packageMetadataResourceUri =>
      getRequiredResourceUri(registrationsBaseUrlTypes);

  /// The resource [Uri] for the *Autocomplete* resource.
  Uri? get searchAutocompleteResourceUri =>
      getResourceUri(searchAutocompleteServiceTypes);

  /// The resource [Uri] for the *Search* resource.
  Uri get searchQueryResourceUri =>
      getRequiredResourceUri(searchQueryServiceTypes);

  /// Retrieves the required resource [Uri] for the specified resource [types].
  ///
  /// For more information on required resources,
  /// see https://learn.microsoft.com/nuget/api/overview#resources-and-schema
  Uri getRequiredResourceUri(List<String> types) {
    final resourceUri = getResourceUri(types);
    if (resourceUri == null) {
      throw NuGetServerException(
          'The service index does not have a resource named `${types.last}`.');
    }

    return resourceUri;
  }

  /// Retrieves the resource [Uri] for the specified resource [types].
  Uri? getResourceUri(List<String> types) {
    for (final type in types) {
      final resource = resources.where((r) => r.type == type).firstOrNull;
      if (resource == null) continue;

      final resourceUrl = switch (resource.resourceUrl) {
        final url when url.endsWith('/') => url.substring(0, url.length - 1),
        _ => resource.resourceUrl
      };
      return Uri.parse(resourceUrl);
    }

    return null;
  }
}
