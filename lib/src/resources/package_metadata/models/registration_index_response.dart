import 'registration_index_page.dart';

///
///
/// See https://learn.microsoft.com/en-us/nuget/api/registration-base-url-resource#response
class RegistrationIndexResponse {
  RegistrationIndexResponse({required this.count, required this.items});

  /// The number of registration pages.
  final int count;

  /// The pages that contain all of the versions of the package, ordered by the
  /// package's version.
  final List<RegistrationIndexPage> items;

  factory RegistrationIndexResponse.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'count': final int count,
          'items': final List<dynamic> itemsVal
        }) {
      final items = itemsVal
          .map((e) => RegistrationIndexPage.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      return RegistrationIndexResponse(count: count, items: items);
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() =>
      'RegistrationIndexResponse(count: $count, items: $items)';
}
