// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('SearchResponse', () {
    const json = {
      "totalHits": 2,
      "data": [
        {
          "registration":
              "https://api.nuget.org/v3/registration-sample/nuget.versioning/index.json",
          "id": "NuGet.Versioning",
          "version": "4.4.0",
          "description": "NuGet's implementation of Semantic Versioning.",
          "summary": "",
          "title": "NuGet.Versioning",
          "licenseUrl":
              "https://raw.githubusercontent.com/NuGet/NuGet.Client/dev/LICENSE.txt",
          "tags": ["semver", "semantic", "versioning"],
          "authors": ["NuGet"],
          "totalDownloads": 141896,
          "verified": true,
          "packageTypes": [
            {"name": "Dependency"}
          ],
          "versions": [
            {
              "version": "3.3.0",
              "downloads": 50343,
              "@id":
                  "https://api.nuget.org/v3/registration-sample/nuget.versioning/3.3.0.json"
            },
            {
              "version": "3.4.3",
              "downloads": 27932,
              "@id":
                  "https://api.nuget.org/v3/registration-sample/nuget.versioning/3.4.3.json"
            },
            {
              "version": "4.0.0",
              "downloads": 63004,
              "@id":
                  "https://api.nuget.org/v3/registration-sample/nuget.versioning/4.0.0.json"
            },
            {
              "version": "4.4.0",
              "downloads": 617,
              "@id":
                  "https://api.nuget.org/v3/registration-sample/nuget.versioning/4.4.0.json"
            }
          ]
        },
        {
          "@id":
              "https://api.nuget.org/v3/registration-sample/nerdbank.gitversioning/index.json",
          "@type": "Package",
          "registration":
              "https://api.nuget.org/v3/registration-sample/nerdbank.gitversioning/index.json",
          "id": "Nerdbank.GitVersioning",
          "version": "2.0.41",
          "description":
              "Stamps your assemblies with semver 2.0 compliant git commit specific version information and provides NuGet versioning information as well.",
          "summary":
              "Stamps your assemblies with semver 2.0 compliant git commit specific version information and provides NuGet versioning information as well.",
          "title": "Nerdbank.GitVersioning",
          "licenseUrl":
              "https://raw.githubusercontent.com/AArnott/Nerdbank.GitVersioning/ed547462f7/LICENSE.txt",
          "projectUrl": "http://github.com/aarnott/Nerdbank.GitVersioning",
          "tags": ["git", "commit", "versioning", "version", "assemblyinfo"],
          "authors": ["Andrew Arnott"],
          "totalDownloads": 11906,
          "verified": false,
          "versions": [
            {
              "version": "1.6.35",
              "downloads": 10229,
              "@id":
                  "https://api.nuget.org/v3/registration-sample/nerdbank.gitversioning/1.6.35.json"
            },
            {
              "version": "2.0.41",
              "downloads": 1677,
              "@id":
                  "https://api.nuget.org/v3/registration-sample/nerdbank.gitversioning/2.0.41.json"
            }
          ]
        }
      ]
    };

    test('fromJson creates SearchResponse successfully', () {
      final response = SearchResponse.fromJson(json);
      check(response.totalHits).equals(2);
      check(response.data.length).equals(2);

      final [first, second] = response.data;
      check(first)
        ..has((e) => e.packageId, 'packageId').equals('NuGet.Versioning')
        ..has((e) => e.version, 'version').equals('4.4.0')
        ..has((e) => e.versions, 'versions').isNotEmpty()
        ..has((e) => e.description, 'description')
            .equals("NuGet's implementation of Semantic Versioning.")
        ..has((e) => e.authors, 'authors').equals('NuGet')
        ..has((e) => e.iconUrl, 'iconUrl').isNull()
        ..has((e) => e.verified, 'verified').isNotNull().isTrue();
      check(second)
        ..has((e) => e.packageId, 'packageId').equals('Nerdbank.GitVersioning')
        ..has((e) => e.version, 'version').equals('2.0.41')
        ..has((e) => e.versions, 'versions').isNotEmpty()
        ..has((e) => e.description, 'description').equals(
            "Stamps your assemblies with semver 2.0 compliant git commit specific version information and provides NuGet versioning information as well.")
        ..has((e) => e.authors, 'authors').equals('Andrew Arnott')
        ..has((e) => e.iconUrl, 'iconUrl').isNull()
        ..has((e) => e.verified, 'verified').isNotNull().isFalse();
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'data': null};
      check(() => SearchResponse.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals("Invalid JSON: {data: null}");
    });

    test('toString', () {
      final response = SearchResponse.fromJson(json);
      check(response.toString()).equals(
        'SearchResponse(totalHits: 2, data: [SearchEntry(packageId: NuGet.Versioning, version: 4.4.0, versions: [VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/3.3.0.json, version: 3.3.0, downloads: 50343), VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/3.4.3.json, version: 3.4.3, downloads: 27932), VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/4.0.0.json, version: 4.0.0, downloads: 63004), VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/4.4.0.json, version: 4.4.0, downloads: 617)], description: NuGet\'s implementation of Semantic Versioning., authors: NuGet, iconUrl: null, licenseUrl: https://raw.githubusercontent.com/NuGet/NuGet.Client/dev/LICENSE.txt, owners: null, projectUrl: null, registration: https://api.nuget.org/v3/registration-sample/nuget.versioning/index.json, summary: , tags: semver,semantic,versioning, title: NuGet.Versioning, totalDownloads: 141896, verified: true), SearchEntry(packageId: Nerdbank.GitVersioning, version: 2.0.41, versions: [VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nerdbank.gitversioning/1.6.35.json, version: 1.6.35, downloads: 10229), VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nerdbank.gitversioning/2.0.41.json, version: 2.0.41, downloads: 1677)], description: Stamps your assemblies with semver 2.0 compliant git commit specific version information and provides NuGet versioning information as well., authors: Andrew Arnott, iconUrl: null, licenseUrl: https://raw.githubusercontent.com/AArnott/Nerdbank.GitVersioning/ed547462f7/LICENSE.txt, owners: null, projectUrl: http://github.com/aarnott/Nerdbank.GitVersioning, registration: https://api.nuget.org/v3/registration-sample/nerdbank.gitversioning/index.json, summary: Stamps your assemblies with semver 2.0 compliant git commit specific version information and provides NuGet versioning information as well., tags: git,commit,versioning,version,assemblyinfo, title: Nerdbank.GitVersioning, totalDownloads: 11906, verified: false)])',
      );
    });
  });
}
