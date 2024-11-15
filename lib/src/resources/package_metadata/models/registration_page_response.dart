import 'registration_index_page.dart';
import 'registration_index_page_item.dart';

/// The response from the registration page.
///
/// See https://learn.microsoft.com/nuget/api/registration-base-url-resource#registration-page-object
final class RegistrationPageResponse extends RegistrationIndexPage {
  RegistrationPageResponse({
    required super.registrationPageUrl,
    required super.count,
    required super.lower,
    required super.upper,
    super.items,
    super.parent,
  });

  factory RegistrationPageResponse.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          '@id': final String registrationPageUrl,
          'count': final int count,
          'items': final List<dynamic> itemsVal,
          'lower': final String lower,
          'parent': final String parent,
          'upper': final String upper
        }) {
      final items = itemsVal
          .map((e) =>
              RegistrationIndexPageItem.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      return RegistrationPageResponse(
        registrationPageUrl: registrationPageUrl,
        count: count,
        items: items,
        lower: lower,
        parent: parent,
        upper: upper,
      );
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() =>
      'RegistrationPageResponse(registrationPageUrl: $registrationPageUrl, '
      'count: $count, items: $items, lower: $lower, parent: $parent, '
      'upper: $upper)';
}
