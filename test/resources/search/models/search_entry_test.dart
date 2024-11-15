import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('SearchEntry', () {
    const json = {
      'registration':
          'https://api.nuget.org/v3/registration-sample/nuget.versioning/index.json',
      'id': 'NuGet.Versioning',
      'version': '4.4.0',
      'description': "NuGet's implementation of Semantic Versioning.",
      'summary': '',
      'title': 'NuGet.Versioning',
      'licenseUrl':
          'https://raw.githubusercontent.com/NuGet/NuGet.Client/dev/LICENSE.txt',
      'tags': ['semver', 'semantic', 'versioning'],
      'authors': ['NuGet'],
      'totalDownloads': 141896,
      'verified': true,
      'packageTypes': [
        {'name': 'Dependency'}
      ],
      'versions': [
        {
          'version': '3.3.0',
          'downloads': 50343,
          '@id':
              'https://api.nuget.org/v3/registration-sample/nuget.versioning/3.3.0.json'
        },
        {
          'version': '3.4.3',
          'downloads': 27932,
          '@id':
              'https://api.nuget.org/v3/registration-sample/nuget.versioning/3.4.3.json'
        },
        {
          'version': '4.0.0',
          'downloads': 63004,
          '@id':
              'https://api.nuget.org/v3/registration-sample/nuget.versioning/4.0.0.json'
        },
        {
          'version': '4.4.0',
          'downloads': 617,
          '@id':
              'https://api.nuget.org/v3/registration-sample/nuget.versioning/4.4.0.json'
        }
      ]
    };

    test('fromJson creates SearchEntry successfully', () {
      final entry = SearchEntry.fromJson(json);
      check(entry)
        ..has((e) => e.packageId, 'packageId').equals('NuGet.Versioning')
        ..has((e) => e.version, 'version').equals('4.4.0')
        ..has((e) => e.versions, 'versions').isNotEmpty()
        ..has((e) => e.description, 'description')
            .equals("NuGet's implementation of Semantic Versioning.")
        ..has((e) => e.authors, 'authors').equals('NuGet')
        ..has((e) => e.iconUrl, 'iconUrl').isNull()
        ..has((e) => e.verified, 'verified').isNotNull().isTrue();
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'id': null};
      check(() => SearchEntry.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {id: null}');
    });

    test('toString', () {
      final entry = SearchEntry.fromJson(json);
      check(entry.toString()).equals(
        "SearchEntry(packageId: NuGet.Versioning, version: 4.4.0, versions: [VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/3.3.0.json, version: 3.3.0, downloads: 50343), VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/3.4.3.json, version: 3.4.3, downloads: 27932), VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/4.0.0.json, version: 4.0.0, downloads: 63004), VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/4.4.0.json, version: 4.4.0, downloads: 617)], description: NuGet's implementation of Semantic Versioning., authors: NuGet, iconUrl: null, licenseUrl: https://raw.githubusercontent.com/NuGet/NuGet.Client/dev/LICENSE.txt, owners: null, projectUrl: null, registration: https://api.nuget.org/v3/registration-sample/nuget.versioning/index.json, summary: , tags: semver,semantic,versioning, title: NuGet.Versioning, totalDownloads: 141896, verified: true)",
      );
    });
  });
}
