// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('DependencyGroupItem', () {
    const json = {
      'dependencies': [
        {
          'id': 'NuGet.Core',
          'range': '[2.14.0, )',
          'registration':
              'https://api.nuget.org/v3/registration-sample/nuget.core/index.json',
        }
      ]
    };

    test('fromJson creates DependencyGroupItem successfully', () {
      final item = DependencyGroupItem.fromJson(json);
      check(item.targetFramework).isNull();
      check(item.dependencies).isNotNull().which(it()..length.equals(1));
      final dependency = item.dependencies!.first;
      check(dependency)
        ..has((e) => e.id, 'id').equals('NuGet.Core')
        ..has((e) => e.range, 'range').isNotNull().equals('[2.14.0, )')
        ..has((e) => e.registration, 'registration').isNotNull().equals(
              'https://api.nuget.org/v3/registration-sample/nuget.core/index.json',
            );
    });

    test('toString', () {
      final item = DependencyGroupItem.fromJson(json);
      check(item.toString()).equals(
        'DependencyGroupItem(targetFramework: null, dependencies: [DependencyItem(id: NuGet.Core, range: [2.14.0, ), registration: https://api.nuget.org/v3/registration-sample/nuget.core/index.json)])',
      );
    });
  });
}
