// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('DependencyItem', () {
    const json = {
      'id': 'NuGet.Core',
      'range': '[2.14.0, )',
      'registration':
          'https://api.nuget.org/v3/registration-sample/nuget.core/index.json',
    };

    test('fromJson creates DependencyItem successfully', () {
      final item = DependencyItem.fromJson(json);
      check(item)
        ..has((e) => e.id, 'id').equals('NuGet.Core')
        ..has((e) => e.range, 'range').isNotNull().equals('[2.14.0, )')
        ..has((e) => e.registration, 'registration').isNotNull().equals(
              'https://api.nuget.org/v3/registration-sample/nuget.core/index.json',
            );
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'id': null};
      check(() => DependencyItem.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {id: null}');
    });

    test('toString', () {
      final item = DependencyItem.fromJson(json);
      check(item.toString()).equals(
        'DependencyItem(id: NuGet.Core, range: [2.14.0, ), registration: https://api.nuget.org/v3/registration-sample/nuget.core/index.json)',
      );
    });
  });
}
