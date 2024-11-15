import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('RegistrationIndexResponse', () {
    const json = {
      '@id':
          'https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/index.json',
      '@type': [
        'catalog:CatalogRoot',
        'PackageRegistration',
        'catalog:Permalink'
      ],
      'commitId': '5ee02ce6-ebb4-4082-a53e-970ae44706fe',
      'commitTimeStamp': '2023-04-12T05:19:09.2263596+00:00',
      'count': 1,
      'items': [
        {
          '@id':
              'https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/index.json#page/3.5.8/12.0.1-beta2',
          '@type': 'catalog:CatalogPage',
          'commitId': '5ee02ce6-ebb4-4082-a53e-970ae44706fe',
          'commitTimeStamp': '2023-04-12T05:19:09.2263596+00:00',
          'count': 2,
          'items': [
            {
              '@id':
                  'https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/3.5.8.json',
              '@type': 'Package',
              'commitId': '29803214-bbd1-4347-bdbf-bc4906742ca2',
              'commitTimeStamp': '2022-12-08T16:44:02.0217374+00:00',
              'catalogEntry': {
                '@id':
                    'https://api.nuget.org/v3/catalog0/data/2022.12.08.16.43.03/newtonsoft.json.3.5.8.json',
                '@type': 'PackageDetails',
                'authors': 'James Newton-King',
                'description':
                    'Json.NET is a popular high-performance JSON framework for .NET',
                'iconUrl': '',
                'id': 'Newtonsoft.Json',
                'language': 'en-US',
                'licenseExpression': '',
                'licenseUrl': '',
                'listed': true,
                'minClientVersion': '',
                'packageContent':
                    'https://api.nuget.org/v3-flatcontainer/newtonsoft.json/3.5.8/newtonsoft.json.3.5.8.nupkg',
                'projectUrl': '',
                'published': '2011-01-08T22:12:57.713+00:00',
                'requireLicenseAcceptance': false,
                'summary':
                    'Json.NET is a popular high-performance JSON framework for .NET',
                'tags': [''],
                'title': '',
                'version': '3.5.8',
                'vulnerabilities': [
                  {
                    'advisoryUrl':
                        'https://github.com/advisories/GHSA-5crp-9r3c-p9vr',
                    'severity': '2'
                  }
                ]
              },
              'packageContent':
                  'https://api.nuget.org/v3-flatcontainer/newtonsoft.json/3.5.8/newtonsoft.json.3.5.8.nupkg',
              'registration':
                  'https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/index.json'
            },
            {
              '@id':
                  'https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/4.0.1.json',
              '@type': 'Package',
              'commitId': '29803214-bbd1-4347-bdbf-bc4906742ca2',
              'commitTimeStamp': '2022-12-08T16:44:02.0217374+00:00',
              'catalogEntry': {
                '@id':
                    'https://api.nuget.org/v3/catalog0/data/2022.12.08.16.43.03/newtonsoft.json.4.0.1.json',
                '@type': 'PackageDetails',
                'authors': 'James Newton-King',
                'description':
                    'Json.NET is a popular high-performance JSON framework for .NET',
                'iconUrl': '',
                'id': 'Newtonsoft.Json',
                'language': 'en-US',
                'licenseExpression': '',
                'licenseUrl': '',
                'listed': true,
                'minClientVersion': '',
                'packageContent':
                    'https://api.nuget.org/v3-flatcontainer/newtonsoft.json/4.0.1/newtonsoft.json.4.0.1.nupkg',
                'projectUrl':
                    'http://james.newtonking.com/projects/json-net.aspx',
                'published': '2011-04-22T01:18:06.287+00:00',
                'requireLicenseAcceptance': false,
                'summary': '',
                'tags': ['json'],
                'title': 'Json.NET',
                'version': '4.0.1',
                'vulnerabilities': [
                  {
                    'advisoryUrl':
                        'https://github.com/advisories/GHSA-5crp-9r3c-p9vr',
                    'severity': '2'
                  }
                ]
              },
              'packageContent':
                  'https://api.nuget.org/v3-flatcontainer/newtonsoft.json/4.0.1/newtonsoft.json.4.0.1.nupkg',
              'registration':
                  'https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/index.json'
            },
          ],
          'parent':
              'https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/index.json',
          'lower': '3.5.8',
          'upper': '4.0.1'
        },
      ]
    };

    test('fromJson creates RegistrationIndexResponse successfully', () {
      final response = RegistrationIndexResponse.fromJson(json);
      check(response)
        ..has((e) => e.count, 'count').equals(1)
        ..has((e) => e.items, 'items').isNotEmpty();

      final [first, second] = response.items.first.items!;
      check(first.catalogEntry)
        ..has((e) => e.packageId, 'packageId').equals('Newtonsoft.Json')
        ..has((e) => e.version, 'version').equals('3.5.8');
      check(second.catalogEntry)
        ..has((e) => e.packageId, 'packageId').equals('Newtonsoft.Json')
        ..has((e) => e.version, 'version').equals('4.0.1');
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'@id': null};
      check(() => RegistrationIndexResponse.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {@id: null}');
    });

    test('toString', () {
      final response = RegistrationIndexResponse.fromJson(json);
      check(response.toString()).equals(
        'RegistrationIndexResponse(count: 1, items: [RegistrationIndexPage(registrationPageUrl: https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/index.json#page/3.5.8/12.0.1-beta2, count: 2, items: [RegistrationIndexPageItem(registrationLeafUrl: https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/3.5.8.json, catalogEntry: PackageMetadata(catalogLeafUrl: https://api.nuget.org/v3/catalog0/data/2022.12.08.16.43.03/newtonsoft.json.3.5.8.json, packageId: Newtonsoft.Json, version: 3.5.8, authors: James Newton-King, dependencyGroups: null, deprecation: null, description: Json.NET is a popular high-performance JSON framework for .NET, iconUrl: , language: en-US, licenseUrl: , listed: true, minClientVersion: , packageContentUrl: https://api.nuget.org/v3-flatcontainer/newtonsoft.json/3.5.8/newtonsoft.json.3.5.8.nupkg, projectUrl: , published: 2011-01-08 22:12:57.713Z, requireLicenseAcceptance: false, summary: Json.NET is a popular high-performance JSON framework for .NET, tags: , title: ), packageContent: https://api.nuget.org/v3-flatcontainer/newtonsoft.json/3.5.8/newtonsoft.json.3.5.8.nupkg), RegistrationIndexPageItem(registrationLeafUrl: https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/4.0.1.json, catalogEntry: PackageMetadata(catalogLeafUrl: https://api.nuget.org/v3/catalog0/data/2022.12.08.16.43.03/newtonsoft.json.4.0.1.json, packageId: Newtonsoft.Json, version: 4.0.1, authors: James Newton-King, dependencyGroups: null, deprecation: null, description: Json.NET is a popular high-performance JSON framework for .NET, iconUrl: , language: en-US, licenseUrl: , listed: true, minClientVersion: , packageContentUrl: https://api.nuget.org/v3-flatcontainer/newtonsoft.json/4.0.1/newtonsoft.json.4.0.1.nupkg, projectUrl: http://james.newtonking.com/projects/json-net.aspx, published: 2011-04-22 01:18:06.287Z, requireLicenseAcceptance: false, summary: , tags: json, title: Json.NET), packageContent: https://api.nuget.org/v3-flatcontainer/newtonsoft.json/4.0.1/newtonsoft.json.4.0.1.nupkg)], lower: 3.5.8, parent: https://api.nuget.org/v3/registration5-gz-semver2/newtonsoft.json/index.json, upper: 4.0.1)])',
      );
    });
  });
}
