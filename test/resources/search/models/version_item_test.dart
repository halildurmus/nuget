import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('VersionItem', () {
    const json = {
      '@id':
          'https://api.nuget.org/v3/registration-sample/nuget.versioning/3.3.0.json',
      'version': '3.3.0',
      'downloads': 50343,
    };

    test('fromJson creates VersionItem successfully', () {
      final item = VersionItem.fromJson(json);
      check(item)
        ..has((e) => e.registrationLeafUrl, 'registrationLeafUrl').equals(
            'https://api.nuget.org/v3/registration-sample/nuget.versioning/3.3.0.json')
        ..has((e) => e.version, 'version').equals('3.3.0')
        ..has((e) => e.downloads, 'downloads').equals(50343);
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'@id': null};
      check(() => VersionItem.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {@id: null}');
    });

    test('toString', () {
      final item = VersionItem.fromJson(json);
      check(item.toString()).equals(
        'VersionItem(registrationLeafUrl: https://api.nuget.org/v3/registration-sample/nuget.versioning/3.3.0.json, version: 3.3.0, downloads: 50343)',
      );
    });
  });
}
