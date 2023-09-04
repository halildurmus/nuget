// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('RegistrationIndexPageItem', () {
    const json = {
      "@id":
          "https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.6.json",
      "@type": "Package",
      "commitId": "10679b1d-437b-4d5d-b3cf-1a026cdbbb92",
      "commitTimeStamp": "2020-02-08T11:22:10.3850027+00:00",
      "catalogEntry": {
        "@id":
            "https://api.nuget.org/v3/catalog0/data/2018.10.15.02.05.02/serilog.0.1.6.json",
        "@type": "PackageDetails",
        "authors": "Nicholas Blumhardt",
        "description": "A no-nonsense logging library for the NoSQL era.",
        "iconUrl": "",
        "id": "Serilog",
        "language": "en-US",
        "licenseExpression": "",
        "licenseUrl": "http://www.apache.org/licenses/LICENSE-2.0",
        "listed": true,
        "minClientVersion": "",
        "packageContent":
            "https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg",
        "projectUrl": "http://serilog.net",
        "published": "2013-03-23T06:36:30.573+00:00",
        "requireLicenseAcceptance": false,
        "summary": "",
        "tags": [""],
        "title": "",
        "version": "0.1.6"
      },
      "packageContent":
          "https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg",
      "registration":
          "https://api.nuget.org/v3/registration5-gz-semver2/serilog/index.json"
    };

    test('fromJson creates RegistrationIndexPageItem successfully', () {
      final item = RegistrationIndexPageItem.fromJson(json);
      check(item)
        ..has((e) => e.registrationLeafUrl, 'registrationLeafUrl').equals(
            'https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.6.json')
        ..has((e) => e.packageContent, 'packageContent').equals(
            'https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg');
      check(item.catalogEntry)
        ..has((e) => e.packageId, 'packageId').equals('Serilog')
        ..has((e) => e.version, 'version').equals('0.1.6');
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'@id': null};
      check(() => RegistrationIndexPageItem.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals("Invalid JSON: {@id: null}");
    });

    test('toString', () {
      final item = RegistrationIndexPageItem.fromJson(json);
      check(item.toString()).equals(
        'RegistrationIndexPageItem(registrationLeafUrl: https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.6.json, catalogEntry: PackageMetadata(catalogLeafUrl: https://api.nuget.org/v3/catalog0/data/2018.10.15.02.05.02/serilog.0.1.6.json, packageId: Serilog, version: 0.1.6, authors: Nicholas Blumhardt, dependencyGroups: null, deprecation: null, description: A no-nonsense logging library for the NoSQL era., iconUrl: , language: en-US, licenseUrl: http://www.apache.org/licenses/LICENSE-2.0, listed: true, minClientVersion: , packageContentUrl: https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg, projectUrl: http://serilog.net, published: 2013-03-23 06:36:30.573Z, requireLicenseAcceptance: false, summary: , tags: , title: ), packageContent: https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg)',
      );
    });
  });
}
