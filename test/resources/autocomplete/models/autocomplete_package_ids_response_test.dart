// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('AutocompletePackageIdsResponse', () {
    const json = {
      'totalHits': 2,
      'data': [
        'Newtonsoft.Json',
        'Newtonsoft.Json.Schema',
      ]
    };

    test('fromJson creates AutocompletePackageIdsResponse successfully', () {
      final response = AutocompletePackageIdsResponse.fromJson(json);
      check(response.totalHits).equals(2);
      check(response.data).which((it) => it
        ..length.equals(2)
        ..contains('Newtonsoft.Json')
        ..contains('Newtonsoft.Json.Schema'));
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'totalHits': null};
      check(() => AutocompletePackageIdsResponse.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {totalHits: null}');
    });

    test('toString', () {
      final response = AutocompletePackageIdsResponse.fromJson(json);
      check(response.toString()).equals(
        'AutocompletePackageIdsResponse(totalHits: 2, data: [Newtonsoft.Json, Newtonsoft.Json.Schema])',
      );
    });
  });
}
