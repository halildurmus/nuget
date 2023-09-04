// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('ServiceIndexResponse', () {
    const json = {
      'version': '3.0.0',
      'resources': [
        {
          '@id': 'https://azuresearch-usnc.nuget.org/query',
          '@type': 'SearchQueryService',
          'comment': 'Query endpoint of NuGet Search service (primary)',
        },
        {
          '@id': 'https://www.nuget.org/api/v2/package',
          '@type': 'PackagePublish/2.0.0',
        }
      ]
    };

    test('fromJson creates ServiceIndexResponse successfully', () {
      final response = ServiceIndexResponse.fromJson(json);
      check(response.version).equals('3.0.0');
      check(response.resources.length).equals(2);

      final [first, second] = response.resources;
      check(first)
        ..has((e) => e.resourceUrl, 'resourceUrl')
            .equals('https://azuresearch-usnc.nuget.org/query')
        ..has((e) => e.type, 'type').equals('SearchQueryService')
        ..has((e) => e.comment, 'comment')
            .isNotNull()
            .equals('Query endpoint of NuGet Search service (primary)');
      check(second)
        ..has((e) => e.resourceUrl, 'resourceUrl')
            .equals('https://www.nuget.org/api/v2/package')
        ..has((e) => e.type, 'type').equals('PackagePublish/2.0.0')
        ..has((e) => e.comment, 'comment').isNull();
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'resources': null};
      check(() => ServiceIndexResponse.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {resources: null}');
    });

    test('toString', () {
      final response = ServiceIndexResponse.fromJson(json);
      check(response.toString()).equals(
        'ServiceIndexResponse(version: 3.0.0, resources: [ServiceIndexItem(resourceUrl: https://azuresearch-usnc.nuget.org/query, type: SearchQueryService, comment: Query endpoint of NuGet Search service (primary)), ServiceIndexItem(resourceUrl: https://www.nuget.org/api/v2/package, type: PackagePublish/2.0.0, comment: null)])',
      );
    });
  });
}
