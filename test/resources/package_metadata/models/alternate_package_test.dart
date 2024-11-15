import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('AlternatePackage', () {
    const json = {'id': 'Z.EntityFramework.Extensions', 'range': '*'};

    test('fromJson creates AlternatePackage successfully', () {
      final package = AlternatePackage.fromJson(json);
      check(package)
        ..has((e) => e.id, 'id').equals('Z.EntityFramework.Extensions')
        ..has((e) => e.range, 'range').equals('*');
    });

    test('fromJson throws FormatException if provided json is invalid', () {
      const invalidJson = {'id': null};
      check(() => AlternatePackage.fromJson(invalidJson))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .equals('Invalid JSON: {id: null}');
    });

    test('toString', () {
      final package = AlternatePackage.fromJson(json);
      check(package.toString()).equals(
        'AlternatePackage(id: Z.EntityFramework.Extensions, range: *)',
      );
    });
  });
}
