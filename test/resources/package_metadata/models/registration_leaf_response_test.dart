// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('RegistrationLeafResponse', () {
    const json = {
      "@id":
          "https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.6.json",
      "@type": ["Package", "http://schema.nuget.org/catalog#Permalink"],
      "catalogEntry":
          "https://api.nuget.org/v3/catalog0/data/2018.10.15.02.05.02/serilog.0.1.6.json",
      "listed": true,
      "packageContent":
          "https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg",
      "published": "2013-03-23T06:36:30.573+00:00",
      "registration":
          "https://api.nuget.org/v3/registration5-gz-semver2/serilog/index.json"
    };

    test('fromJson creates RegistrationLeafResponse successfully', () {
      final response = RegistrationLeafResponse.fromJson(json);
      check(response)
        ..has((e) => e.catalogEntry, 'catalogEntry').equals(
            'https://api.nuget.org/v3/catalog0/data/2018.10.15.02.05.02/serilog.0.1.6.json')
        ..has((e) => e.listed, 'listed').equals(true)
        ..has((e) => e.packageContent, 'packageContent').equals(
            'https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg')
        ..has((e) => e.published, 'published')
            .equals(DateTime.parse('2013-03-23T06:36:30.573+00:00'))
        ..has((e) => e.registration, 'registration').equals(
            'https://api.nuget.org/v3/registration5-gz-semver2/serilog/index.json');
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'@id': null};
      check(() => RegistrationLeafResponse.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals("Invalid JSON: {@id: null}");
    });

    test('toString', () {
      final response = RegistrationLeafResponse.fromJson(json);
      check(response.toString()).equals(
        'RegistrationLeafResponse(registrationLeafUrl: https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.6.json, catalogEntry: https://api.nuget.org/v3/catalog0/data/2018.10.15.02.05.02/serilog.0.1.6.json, listed: true, packageContent: https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg, published: 2013-03-23 06:36:30.573Z, registration: https://api.nuget.org/v3/registration5-gz-semver2/serilog/index.json)',
      );
    });
  });
}
