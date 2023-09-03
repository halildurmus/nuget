import 'catalog_entry.dart';

/// A resource in the `items` List from the `RegistrationIndexPage` class.
///
/// See https://docs.microsoft.com/en-us/nuget/api/registration-base-url-resource#registration-leaf-object-in-a-page
class RegistrationIndexPageItem {
  RegistrationIndexPageItem({
    required this.registrationLeafUrl,
    required this.catalogEntry,
    required this.packageContent,
  });

  /// The URL to the registration leaf.
  final String registrationLeafUrl;

  /// The catalog entry containing the package metadata.
  final CatalogEntry catalogEntry;

  /// The URL to the package content (.nupkg).
  final String packageContent;

  factory RegistrationIndexPageItem.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          '@id': final String registrationLeafUrl,
          'catalogEntry': final Map<String, dynamic> catalogEntryVal,
          'packageContent': final String packageContent
        }) {
      final catalogEntry = CatalogEntry.fromJson(catalogEntryVal);
      return RegistrationIndexPageItem(
        registrationLeafUrl: registrationLeafUrl,
        catalogEntry: catalogEntry,
        packageContent: packageContent,
      );
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() =>
      'RegistrationIndexPageItem(registrationLeafUrl: $registrationLeafUrl, '
      'catalogEntry: $catalogEntry, packageContent: $packageContent)';
}
