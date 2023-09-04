// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('ServiceIndexItem', () {
    const json = {
      '@id': 'https://azuresearch-usnc.nuget.org/query',
      '@type': 'SearchQueryService',
      'comment': 'Query endpoint of NuGet Search service (primary)',
    };

    test('fromJson creates ServiceIndexItem successfully', () {
      final item = ServiceIndexItem.fromJson(json);
      check(item)
        ..has((e) => e.resourceUrl, 'resourceUrl')
            .equals('https://azuresearch-usnc.nuget.org/query')
        ..has((e) => e.type, 'type').equals('SearchQueryService')
        ..has((e) => e.comment, 'comment')
            .isNotNull()
            .equals('Query endpoint of NuGet Search service (primary)');
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'@id': null};
      check(() => ServiceIndexItem.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals("Invalid JSON: {@id: null}");
    });

    test('toString', () {
      final item = ServiceIndexItem.fromJson(json);
      check(item.toString()).equals(
        'ServiceIndexItem(resourceUrl: https://azuresearch-usnc.nuget.org/query, type: SearchQueryService, comment: Query endpoint of NuGet Search service (primary))',
      );
    });
  });
}
