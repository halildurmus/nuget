// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'registration_index_page.dart';

/// The response from the registration index.
///
/// See https://learn.microsoft.com/nuget/api/registration-base-url-resource#response
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
