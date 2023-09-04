// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('CatalogEntry', () {
    const json = {
      "@id":
          "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json",
      "@type": ["PackageDetails", "catalog:Permalink"],
      "authors": "James Newton-King",
      "description":
          "Json.NET is a popular high-performance JSON framework for .NET",
      "iconFile": "packageIcon.png",
      "iconUrl": "https://www.newtonsoft.com/content/images/nugeticon.png",
      "id": "Newtonsoft.Json",
      "licenseExpression": "MIT",
      "licenseUrl": "https://licenses.nuget.org/MIT",
      "listed": true,
      "minClientVersion": "2.12",
      "projectUrl": "https://www.newtonsoft.com/json",
      "published": "2023-03-08T07:42:54.647Z",
      "title": "Json.NET",
      "version": "13.0.3",
      "dependencyGroups": [
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netframework2.0",
          "@type": "PackageDependencyGroup",
          "targetFramework": ".NETFramework2.0"
        },
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netframework3.5",
          "@type": "PackageDependencyGroup",
          "targetFramework": ".NETFramework3.5"
        },
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netframework4.0",
          "@type": "PackageDependencyGroup",
          "targetFramework": ".NETFramework4.0"
        },
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netframework4.5",
          "@type": "PackageDependencyGroup",
          "targetFramework": ".NETFramework4.5"
        },
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.0",
          "@type": "PackageDependencyGroup",
          "dependencies": [
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.0/microsoft.csharp",
              "@type": "PackageDependency",
              "id": "Microsoft.CSharp",
              "range": "[4.3.0, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.0/netstandard.library",
              "@type": "PackageDependency",
              "id": "NETStandard.Library",
              "range": "[1.6.1, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.0/system.componentmodel.typeconverter",
              "@type": "PackageDependency",
              "id": "System.ComponentModel.TypeConverter",
              "range": "[4.3.0, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.0/system.runtime.serialization.primitives",
              "@type": "PackageDependency",
              "id": "System.Runtime.Serialization.Primitives",
              "range": "[4.3.0, )"
            }
          ],
          "targetFramework": ".NETStandard1.0"
        },
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.3",
          "@type": "PackageDependencyGroup",
          "dependencies": [
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.3/microsoft.csharp",
              "@type": "PackageDependency",
              "id": "Microsoft.CSharp",
              "range": "[4.3.0, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.3/netstandard.library",
              "@type": "PackageDependency",
              "id": "NETStandard.Library",
              "range": "[1.6.1, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.3/system.componentmodel.typeconverter",
              "@type": "PackageDependency",
              "id": "System.ComponentModel.TypeConverter",
              "range": "[4.3.0, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.3/system.runtime.serialization.formatters",
              "@type": "PackageDependency",
              "id": "System.Runtime.Serialization.Formatters",
              "range": "[4.3.0, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.3/system.runtime.serialization.primitives",
              "@type": "PackageDependency",
              "id": "System.Runtime.Serialization.Primitives",
              "range": "[4.3.0, )"
            },
            {
              "@id":
                  "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard1.3/system.xml.xmldocument",
              "@type": "PackageDependency",
              "id": "System.Xml.XmlDocument",
              "range": "[4.3.0, )"
            }
          ],
          "targetFramework": ".NETStandard1.3"
        },
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/net6.0",
          "@type": "PackageDependencyGroup",
          "targetFramework": "net6.0"
        },
        {
          "@id":
              "https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json#dependencygroup/.netstandard2.0",
          "@type": "PackageDependencyGroup",
          "targetFramework": ".NETStandard2.0"
        }
      ],
      "tags": ["json"],
    };

    test('fromJson creates CatalogEntry successfully', () {
      final catalogEntry = CatalogEntry.fromJson(json);
      check(catalogEntry)
        ..has((e) => e.packageId, 'packageId').equals('Newtonsoft.Json')
        ..has((e) => e.version, 'version').equals('13.0.3')
        ..has((e) => e.authors, 'authors').equals('James Newton-King')
        ..has((e) => e.tags, 'tags').equals('json')
        ..has((e) => e.description, 'description').isNotNull().equals(
            'Json.NET is a popular high-performance JSON framework for .NET')
        ..has((e) => e.iconUrl, 'iconUrl')
            .isNotNull()
            .equals('https://www.newtonsoft.com/content/images/nugeticon.png')
        ..has((e) => e.licenseUrl, 'licenseUrl')
            .isNotNull()
            .equals('https://licenses.nuget.org/MIT')
        ..has((e) => e.listed, 'listed').isNotNull().equals(true)
        ..has((e) => e.minClientVersion, 'minClientVersion')
            .isNotNull()
            .equals('2.12')
        ..has((e) => e.projectUrl, 'projectUrl')
            .isNotNull()
            .equals('https://www.newtonsoft.com/json')
        ..has((e) => e.published, 'published')
            .isNotNull()
            .equals(DateTime.parse('2023-03-08T07:42:54.647Z'))
        ..has((e) => e.title, 'title').isNotNull().equals('Json.NET')
        ..has((e) => e.dependencyGroups, 'dependencyGroups')
            .isNotNull()
            .isNotEmpty();
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'@id': null};
      check(() => CatalogEntry.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {@id: null}');
    });

    test('toString', () {
      final response = CatalogEntry.fromJson(json);
      check(response.toString()).equals(
        'PackageMetadata(catalogLeafUrl: https://api.nuget.org/v3/catalog0/data/2023.03.08.07.46.17/newtonsoft.json.13.0.3.json, packageId: Newtonsoft.Json, version: 13.0.3, authors: James Newton-King, dependencyGroups: [DependencyGroupItem(targetFramework: .NETFramework2.0, dependencies: null), DependencyGroupItem(targetFramework: .NETFramework3.5, dependencies: null), DependencyGroupItem(targetFramework: .NETFramework4.0, dependencies: null), DependencyGroupItem(targetFramework: .NETFramework4.5, dependencies: null), DependencyGroupItem(targetFramework: .NETStandard1.0, dependencies: [DependencyItem(id: Microsoft.CSharp, range: [4.3.0, ), registration: null), DependencyItem(id: NETStandard.Library, range: [1.6.1, ), registration: null), DependencyItem(id: System.ComponentModel.TypeConverter, range: [4.3.0, ), registration: null), DependencyItem(id: System.Runtime.Serialization.Primitives, range: [4.3.0, ), registration: null)]), DependencyGroupItem(targetFramework: .NETStandard1.3, dependencies: [DependencyItem(id: Microsoft.CSharp, range: [4.3.0, ), registration: null), DependencyItem(id: NETStandard.Library, range: [1.6.1, ), registration: null), DependencyItem(id: System.ComponentModel.TypeConverter, range: [4.3.0, ), registration: null), DependencyItem(id: System.Runtime.Serialization.Formatters, range: [4.3.0, ), registration: null), DependencyItem(id: System.Runtime.Serialization.Primitives, range: [4.3.0, ), registration: null), DependencyItem(id: System.Xml.XmlDocument, range: [4.3.0, ), registration: null)]), DependencyGroupItem(targetFramework: net6.0, dependencies: null), DependencyGroupItem(targetFramework: .NETStandard2.0, dependencies: null)], deprecation: null, description: Json.NET is a popular high-performance JSON framework for .NET, iconUrl: https://www.newtonsoft.com/content/images/nugeticon.png, language: null, licenseUrl: https://licenses.nuget.org/MIT, listed: true, minClientVersion: 2.12, packageContentUrl: null, projectUrl: https://www.newtonsoft.com/json, published: 2023-03-08 07:42:54.647Z, requireLicenseAcceptance: null, summary: null, tags: json, title: Json.NET)',
      );
    });
  });
}
