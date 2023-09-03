// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'registration_index_page.dart';
import 'registration_index_page_item.dart';

///
///
/// See https://learn.microsoft.com/en-us/nuget/api/registration-base-url-resource#registration-page
final class RegistrationPageResponse extends RegistrationIndexPage {
  RegistrationPageResponse({
    required super.registrationPageUrl,
    required super.count,
    required super.items,
    required super.lower,
    required super.parent,
    required super.upper,
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
