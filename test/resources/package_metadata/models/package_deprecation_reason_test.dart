import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('PackageDeprecationReason', () {
    group('fromString', () {
      test('returns the appropriate enum value', () {
        check(PackageDeprecationReason.fromString('CriticalBugs'))
            .equals(PackageDeprecationReason.criticalBugs);
        check(PackageDeprecationReason.fromString('criticalbugs'))
            .equals(PackageDeprecationReason.criticalBugs);
        check(PackageDeprecationReason.fromString('Legacy'))
            .equals(PackageDeprecationReason.legacy);
        check(PackageDeprecationReason.fromString('legacy'))
            .equals(PackageDeprecationReason.legacy);
        check(PackageDeprecationReason.fromString('Other'))
            .equals(PackageDeprecationReason.other);
        check(PackageDeprecationReason.fromString('other'))
            .equals(PackageDeprecationReason.other);
      });

      test('throws ArgumentError on invalid value', () {
        check(() => PackageDeprecationReason.fromString('Unknown'))
            .throws<ArgumentError>()
            .has((e) => e.message, 'message')
            .equals('No enum value.');
      });
    });
  });
}
