import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('NuGetClient', () {
    late NuGetClient client;

    setUp(() => client = NuGetClient());

    group('autocompletePackageIds', () {
      test('includes pre-release packages in results', () async {
        final response = await client.autocompletePackageIds('win32',
            includePrerelease: true);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which(it()
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..contains('Microsoft.Windows.SDK.Win32Metadata'));
      });

      test('excludes pre-release packages in results', () async {
        final response = await client.autocompletePackageIds('win32',
            includePrerelease: false);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which(it()
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not(it()..contains('Microsoft.Windows.SDK.Win32Metadata')));
      });

      test(
          'pagination with `skip` and `take` parameters (including pre-release packages)',
          () async {
        final response = await client.autocompletePackageIds('win32',
            includePrerelease: true, skip: 1, take: 10);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which(it()
          ..length.equals(10)
          ..not(it()..contains('Win32'))
          ..not(it()..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Microsoft.Win32.Registry'));
      });

      test(
          'pagination with `skip` and `take` parameters (excluding pre-release packages)',
          () async {
        final response = await client.autocompletePackageIds('win32',
            includePrerelease: false, skip: 0, take: 50);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which(it()
          ..length.equals(50)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not(it()..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Win32Interop.Gdi32'));
      });

      test('`skip` parameter must be greater or equal to 0', () async {
        await check(client.autocompletePackageIds(null, skip: -1))
            .throws<RangeError>(
          it()..has((e) => e.message, 'message').equals('Invalid value'),
        );
      });

      test('`take` parameter must be greater than 0', () async {
        await check(client.autocompletePackageIds(null, take: 0))
            .throws<RangeError>(
          it()
            ..has((e) => e.message, 'message').equals('Must be greater than 0'),
        );
      });
    });

    group('autocompletePackageVersions', () {
      test('includes pre-release versions in results', () async {
        final versions = await client.autocompletePackageVersions(
          'Microsoft.Windows.SDK.Contracts',
          includePrerelease: true,
        );
        check(versions).which(it()
          ..length.isGreaterOrEqual(92)
          ..contains('10.0.17134.1000')
          ..contains('10.0.19041.1')
          ..contains('10.0.22621.755')
          ..contains('10.0.22621-preview')
          ..contains('10.0.25931-preview'));
      });

      test('excludes pre-release versions in results (1)', () async {
        final versions = await client.autocompletePackageVersions(
          'Microsoft.Windows.SDK.Contracts',
          includePrerelease: false,
        );
        check(versions).which(it()
          ..length.isGreaterOrEqual(12)
          ..contains('10.0.17134.1000')
          ..contains('10.0.19041.1')
          ..contains('10.0.22621.755')
          ..not(it()..contains('10.0.22621-preview'))
          ..not(it()..contains('10.0.25931-preview')));
      });

      test('excludes pre-release versions in results (2)', () async {
        final versions = await client.autocompletePackageVersions(
          'Microsoft.Windows.SDK.Win32Metadata',
          includePrerelease: false,
        );
        check(versions).isEmpty();
      });
    });

    group('downloadPackageContent', () {
      test('downloads a package', () async {
        // Pick a small package (this one is 346.42KB).
        final bytes = await client.downloadPackageContent(
          'Microsoft.Win32.Registry',
          version: '5.0.0',
        );
        // Perhaps the exact size could vary if it is patched?
        check(bytes.lengthInBytes).isCloseTo(346 * 1024, 100 * 1024);
      });

      test('downloads a package (with a pre-release version)', () async {
        // Pick a small package (this one is 181.46KB).
        final bytes = await client.downloadPackageContent(
          'Microsoft.Win32.Registry',
          version: '6.0.0-preview.5.21301.5',
        );
        // Perhaps the exact size could vary if it is patched?
        check(bytes.lengthInBytes).isCloseTo(181 * 1024, 100 * 1024);
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.downloadPackageContent(
          'Non.Existent.Package',
          version: '1.0.0',
        )).throws<PackageNotFoundException>(
          it()
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.'),
        );
      });
    });

    group('downloadPackageManifest', () {
      test('downloads a package manifest', () async {
        // Pick a small package manifest (this one is 4.88KB).
        final bytes = await client.downloadPackageManifest(
          'Microsoft.Win32.Registry',
          version: '5.0.0',
        );
        // Perhaps the exact size could vary if it is patched?
        check(bytes.lengthInBytes).isCloseTo(4 * 1024, 100 * 1024);
      });

      test('downloads a package manifest (with a pre-release version)',
          () async {
        // Pick a small package manifest (this one is 4.94KB).
        final bytes = await client.downloadPackageManifest(
          'Microsoft.Win32.Registry',
          version: '6.0.0-preview.5.21301.5',
        );
        // Perhaps the exact size could vary if it is patched?
        check(bytes.lengthInBytes).isCloseTo(4 * 1024, 100 * 1024);
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.downloadPackageManifest(
          'Non.Existent.Package',
          version: '1.0.0',
        )).throws<PackageNotFoundException>(
          it()
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.'),
        );
      });
    });

    group('getAllPackageMetadata', () {
      test('returns metadata for all versions of a package', () async {
        final metadata =
            await client.getAllPackageMetadata('Microsoft.Win32.Registry');
        check(metadata.map((m) => m.version)).which(it()
          ..length.isGreaterOrEqual(55)
          ..contains('4.0.0-beta-22231')
          ..contains('4.0.0')
          ..contains('4.3.0')
          ..contains('4.7.0')
          ..contains('5.0.0-preview.1.20120.5')
          ..contains('5.0.0')
          ..contains('6.0.0-preview.1.21102.12'));
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.getAllPackageMetadata('Non.Existent.Package'))
            .throws<PackageNotFoundException>(
          it()
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.'),
        );
      });
    });

    group('getLatestPackageVersion', () {
      test(
          'returns the latest version of a package (including pre-release versions)',
          () async {
        final version = await client.getLatestPackageVersion(
          'Microsoft.Win32.Registry',
          includePrerelease: true,
        );
        check(version).contains('-preview');
      });

      test(
          'returns the latest version of a package (excluding pre-release versions)',
          () async {
        final version = await client.getLatestPackageVersion(
          'Microsoft.Windows.SDK.Contracts',
          includePrerelease: false,
        );
        check(version).not(it()..contains('-preview'));
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.getLatestPackageVersion('Non.Existent.Package'))
            .throws<PackageNotFoundException>(
          it()
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.'),
        );
      });
    });

    group('getPackageMetadata', () {
      test('returns metadata for a package', () async {
        final metadata = await client.getPackageMetadata(
          'Microsoft.Win32.Registry',
          version: '5.0.0',
        );
        check(metadata)
          ..has((m) => m.packageId, 'packageId')
              .equals('Microsoft.Win32.Registry')
          ..has((m) => m.version, 'version').equals('5.0.0')
          ..has((m) => m.authors, 'authors').equals('Microsoft')
          ..has((m) => m.dependencyGroups, 'dependencyGroups')
              .isNotNull()
              .which(it()..length.equals(13))
          ..has((m) => m.deprecation, 'deprecation').isNull()
          ..has((m) => m.description, 'description').isNotNull().contains(
              'Provides support for accessing and modifying the Windows Registry.')
          ..has((m) => m.language, 'language').isNotNull().isEmpty()
          ..has((m) => m.minClientVersion, 'minClientVersion')
              .isNotNull()
              .equals('2.12')
          ..has((m) => m.summary, 'summary').isNotNull().isEmpty()
          ..has((m) => m.tags, 'tags').isNotNull().isEmpty()
          ..has((m) => m.isListed, 'isListed').isTrue()
          ..has((m) => m.title, 'title')
              .isNotNull()
              .equals('Microsoft.Win32.Registry')
          ..has((m) => m.iconUrl, 'iconUrl').equals(
              'https://api.nuget.org/v3-flatcontainer/microsoft.win32.registry/5.0.0/icon')
          ..has((m) => m.licenseUrl, 'licenseUrl').equals(
              'https://www.nuget.org/packages/Microsoft.Win32.Registry/5.0.0/license')
          ..has((m) => m.packageContentUrl, 'packageContentUrl').equals(
              'https://api.nuget.org/v3-flatcontainer/microsoft.win32.registry/5.0.0/microsoft.win32.registry.5.0.0.nupkg')
          ..has((m) => m.projectUrl, 'projectUrl')
              .equals('https://github.com/dotnet/runtime')
          ..has((m) => m.requireLicenseAcceptance, 'requireLicenseAcceptance')
              .isNotNull()
              .isFalse();
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.getPackageMetadata(
          'Non.Existent.Package',
          version: '1.0.0',
        )).throws<PackageNotFoundException>(
          it()
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.'),
        );
      });
    });

    group('getPackageVersions', () {
      test('returns all versions of a package (including pre-release versions)',
          () async {
        final versions = await client.getPackageVersions(
          'Microsoft.Windows.SDK.Contracts',
          includePrerelease: true,
        );
        check(versions).which(it()
          ..length.isGreaterOrEqual(92)
          ..contains('10.0.17134.1000')
          ..contains('10.0.19041.1')
          ..contains('10.0.22621.755')
          ..contains('10.0.22621-preview')
          ..contains('10.0.25931-preview'));
      });

      test('returns all versions of a package (excluding pre-release versions)',
          () async {
        final versions = await client.getPackageVersions(
          'Microsoft.Windows.SDK.Contracts',
          includePrerelease: false,
        );
        check(versions).which(it()
          ..length.isGreaterOrEqual(12)
          ..contains('10.0.17134.1000')
          ..contains('10.0.19041.1')
          ..contains('10.0.22621.755')
          ..not(it()..contains('10.0.22621-preview'))
          ..not(it()..contains('10.0.25931-preview')));
      });

      test('returns an empty List if the package does not exist', () async {
        final versions =
            await client.getPackageVersions('Non.Existent.Package');
        check(versions).isEmpty();
      });
    });

    group('packageExists', () {
      test('returns true if the package exists', () async {
        await check(client.packageExists('Microsoft.Win32.Registry'))
            .completes(it()..isTrue());
      });

      test('returns false if the package does not exist', () async {
        await check(client.packageExists('Non.Existent.Package'))
            .completes(it()..isFalse());
      });
    });

    group('searchPackages', () {
      test('includes pre-release packages in results', () async {
        final response =
            await client.searchPackages('win32', includePrerelease: true);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data.map((pkg) => pkg.packageId)).which(it()
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..contains('Microsoft.Windows.SDK.Win32Metadata'));
      });

      test('excludes pre-release packages in results', () async {
        final response =
            await client.searchPackages('win32', includePrerelease: false);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data.map((pkg) => pkg.packageId)).which(it()
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not(it()..contains('Microsoft.Windows.SDK.Win32Metadata')));
      });

      test(
          'pagination with `skip` and `take` parameters (including pre-release packages)',
          () async {
        final response = await client.searchPackages('win32',
            includePrerelease: true, skip: 1, take: 10);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data.map((pkg) => pkg.packageId)).which(it()
          ..length.equals(10)
          ..contains('Win32')
          ..not(it()..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Microsoft.Win32.Primitives'));
      });

      test(
          'pagination with `skip` and `take` parameters (excluding pre-release packages)',
          () async {
        final response = await client.searchPackages('win32',
            includePrerelease: false, skip: 0, take: 50);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data.map((pkg) => pkg.packageId)).which(it()
          ..length.equals(50)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not(it()..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Selenium.WebDriver.GeckoDriver.Win32'));
      });

      test('`skip` parameter must be greater or equal to 0', () async {
        await check(client.searchPackages(null, skip: -1)).throws<RangeError>(
          it()..has((e) => e.message, 'message').equals('Invalid value'),
        );
      });

      test('`take` parameter must be greater than 0', () async {
        await check(client.searchPackages(null, take: 0)).throws<RangeError>(
          it()
            ..has((e) => e.message, 'message').equals('Must be greater than 0'),
        );
      });
    });

    tearDown(() => client.close());
  });
}
