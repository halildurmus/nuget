// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('RegistrationIndexPage', () {
    const json = {
      "@id":
          "https://api.nuget.org/v3/registration5-gz-semver2/serilog/page/0.1.6/1.2.47.json",
      "@type": "catalog:CatalogPage",
      "commitId": "936e72e5-7a87-4ad6-b535-c13042e3549f",
      "commitTimeStamp": "2020-02-08T11:22:17.578087+00:00",
      "count": 2,
      "items": [
        {
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
        },
        {
          "@id":
              "https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.7.json",
          "@type": "Package",
          "commitId": "10679b1d-437b-4d5d-b3cf-1a026cdbbb92",
          "commitTimeStamp": "2020-02-08T11:22:10.3850027+00:00",
          "catalogEntry": {
            "@id":
                "https://api.nuget.org/v3/catalog0/data/2018.10.15.02.04.22/serilog.0.1.7.json",
            "@type": "PackageDetails",
            "authors": "Nicholas Blumhardt",
            "description": "A no-nonsense logging library for the NoSQL era.",
            "iconUrl":
                "https://api.nuget.org/v3-flatcontainer/serilog/0.1.7/icon",
            "id": "Serilog",
            "language": "en-US",
            "licenseExpression": "",
            "licenseUrl": "http://www.apache.org/licenses/LICENSE-2.0",
            "listed": true,
            "minClientVersion": "",
            "packageContent":
                "https://api.nuget.org/v3-flatcontainer/serilog/0.1.7/serilog.0.1.7.nupkg",
            "projectUrl": "http://serilog.net",
            "published": "2013-03-23T11:38:52.21+00:00",
            "requireLicenseAcceptance": false,
            "summary": "",
            "tags": [""],
            "title": "",
            "version": "0.1.7"
          },
          "packageContent":
              "https://api.nuget.org/v3-flatcontainer/serilog/0.1.7/serilog.0.1.7.nupkg",
          "registration":
              "https://api.nuget.org/v3/registration5-gz-semver2/serilog/index.json"
        }
      ],
      "parent":
          "https://api.nuget.org/v3/registration5-gz-semver2/serilog/index.json",
      "lower": "0.1.6",
      "upper": "0.1.7",
    };

    test('fromJson creates RegistrationIndexPage successfully', () {
      final page = RegistrationIndexPage.fromJson(json);
      check(page)
        ..has((e) => e.registrationPageUrl, 'registrationPageUrl').equals(
            'https://api.nuget.org/v3/registration5-gz-semver2/serilog/page/0.1.6/1.2.47.json')
        ..has((e) => e.count, 'count').equals(2)
        ..has((e) => e.items, 'items').isNotNull()
        ..has((e) => e.lower, 'lower').equals('0.1.6')
        ..has((e) => e.upper, 'upper').equals('0.1.7');

      final [first, second] = page.items!;
      check(first.catalogEntry)
        ..has((e) => e.packageId, 'packageId').equals('Serilog')
        ..has((e) => e.version, 'version').equals('0.1.6');
      check(second.catalogEntry)
        ..has((e) => e.packageId, 'packageId').equals('Serilog')
        ..has((e) => e.version, 'version').equals('0.1.7');
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'@id': null};
      check(() => RegistrationIndexPage.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals("Invalid JSON: {@id: null}");
    });

    test('toString', () {
      final page = RegistrationIndexPage.fromJson(json);
      check(page.toString()).equals(
        'RegistrationIndexPage(registrationPageUrl: https://api.nuget.org/v3/registration5-gz-semver2/serilog/page/0.1.6/1.2.47.json, count: 2, items: [RegistrationIndexPageItem(registrationLeafUrl: https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.6.json, catalogEntry: PackageMetadata(catalogLeafUrl: https://api.nuget.org/v3/catalog0/data/2018.10.15.02.05.02/serilog.0.1.6.json, packageId: Serilog, version: 0.1.6, authors: Nicholas Blumhardt, dependencyGroups: null, deprecation: null, description: A no-nonsense logging library for the NoSQL era., iconUrl: , language: en-US, licenseUrl: http://www.apache.org/licenses/LICENSE-2.0, listed: true, minClientVersion: , packageContentUrl: https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg, projectUrl: http://serilog.net, published: 2013-03-23 06:36:30.573Z, requireLicenseAcceptance: false, summary: , tags: , title: ), packageContent: https://api.nuget.org/v3-flatcontainer/serilog/0.1.6/serilog.0.1.6.nupkg), RegistrationIndexPageItem(registrationLeafUrl: https://api.nuget.org/v3/registration5-gz-semver2/serilog/0.1.7.json, catalogEntry: PackageMetadata(catalogLeafUrl: https://api.nuget.org/v3/catalog0/data/2018.10.15.02.04.22/serilog.0.1.7.json, packageId: Serilog, version: 0.1.7, authors: Nicholas Blumhardt, dependencyGroups: null, deprecation: null, description: A no-nonsense logging library for the NoSQL era., iconUrl: https://api.nuget.org/v3-flatcontainer/serilog/0.1.7/icon, language: en-US, licenseUrl: http://www.apache.org/licenses/LICENSE-2.0, listed: true, minClientVersion: , packageContentUrl: https://api.nuget.org/v3-flatcontainer/serilog/0.1.7/serilog.0.1.7.nupkg, projectUrl: http://serilog.net, published: 2013-03-23 11:38:52.210Z, requireLicenseAcceptance: false, summary: , tags: , title: ), packageContent: https://api.nuget.org/v3-flatcontainer/serilog/0.1.7/serilog.0.1.7.nupkg)], lower: 0.1.6, parent: https://api.nuget.org/v3/registration5-gz-semver2/serilog/index.json, upper: 0.1.7)',
      );
    });
  });
}
