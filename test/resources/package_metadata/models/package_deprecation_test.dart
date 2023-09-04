// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('PackageDeprecation', () {
    const json = {
      'alternatePackage': {'id': 'Z.EntityFramework.Extensions', 'range': '*'},
      'reasons': ['Legacy'],
    };

    test('fromJson creates PackageDeprecation successfully', () {
      final deprecation = PackageDeprecation.fromJson(json);
      check(deprecation.reasons).which(it()
        ..length.equals(1)
        ..contains(PackageDeprecationReason.legacy));
      final altenatePackage = deprecation.alternatePackage!;
      check(altenatePackage)
        ..has((e) => e.id, 'id').equals('Z.EntityFramework.Extensions')
        ..has((e) => e.range, 'range').equals('*');
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'id': null};
      check(() => PackageDeprecation.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {id: null}');
    });

    test('toString', () {
      final deprecation = PackageDeprecation.fromJson(json);
      check(deprecation.toString()).equals(
        'PackageDeprecation(reasons: [PackageDeprecationReason.legacy], message: null, alternatePackage: AlternatePackage(id: Z.EntityFramework.Extensions, range: *))',
      );
    });
  });
}
