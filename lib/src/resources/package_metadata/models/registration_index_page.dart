// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'registration_index_page_item.dart';

/// A resource in the `items` List from the `RegistrationIndexResponse` class.
///
/// See https://learn.microsoft.com/en-us/nuget/api/registration-base-url-resource#registration-page-object
class RegistrationIndexPage {
  RegistrationIndexPage({
    required this.registrationPageUrl,
    required this.count,
    required this.items,
    required this.lower,
    required this.parent,
    required this.upper,
  });

  /// The URL to the registration page.
  final String registrationPageUrl;

  /// The number of registration leaves in the page.
  final int count;

  /// The List of registration leaves and their associate metadata.
  final List<RegistrationIndexPageItem>? items;

  /// The lowest SemVer 2.0.0 version in the page (inclusive).
  final String lower;

  /// The URL to the registration index
  final String? parent;

  /// The highest SemVer 2.0.0 version in the page (inclusive).
  final String upper;

  factory RegistrationIndexPage.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          '@id': final String registrationPageUrl,
          'count': final int count,
          'lower': final String lower,
          'upper': final String upper
        }) {
      final items = (json['items'] as List<dynamic>?)
          ?.map((e) =>
              RegistrationIndexPageItem.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      final parent = json['parent'] as String?;
      return RegistrationIndexPage(
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
      'RegistrationIndexPage(registrationPageUrl: $registrationPageUrl, '
      'count: $count, items: $items, lower: $lower, parent: $parent, '
      'upper: $upper)';
}
