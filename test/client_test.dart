import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('NuGetClient', () {
    late NuGetClient client;

    setUpAll(() => client = NuGetClient());

    group('autocompletePackageIds', () {
      test('includes pre-release packages in results', () async {
        final response = await client.autocompletePackageIds('win32',
            includePrerelease: true);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which((it) => it
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..contains('Microsoft.Windows.SDK.Win32Metadata'));
      });

      test('excludes pre-release packages in results', () async {
        final response = await client.autocompletePackageIds('win32');
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which((it) => it
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not((it) => it..contains('Microsoft.Windows.SDK.Win32Metadata')));
      });

      test(
          'pagination with `skip` and `take` parameters (including pre-release packages)',
          () async {
        final response = await client.autocompletePackageIds('win32',
            includePrerelease: true, skip: 1, take: 10);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which((it) => it
          ..length.equals(10)
          ..not((it) => it..contains('Win32'))
          ..not((it) => it..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Microsoft.Win32.Registry'));
      });

      test(
          'pagination with `skip` and `take` parameters (excluding pre-release packages)',
          () async {
        final response =
            await client.autocompletePackageIds('win32', skip: 0, take: 50);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).which((it) => it
          ..length.equals(50)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not((it) => it..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Win32Interop.Gdi32'));
      });

      test('`skip` parameter must be greater or equal to 0', () async {
        await check(client.autocompletePackageIds(null, skip: -1))
            .throws<RangeError>(
          (it) => it..has((e) => e.message, 'message').equals('Invalid value'),
        );
      });

      test('`take` parameter must be greater than 0', () async {
        await check(client.autocompletePackageIds(null, take: 0))
            .throws<RangeError>(
          (it) => it
            ..has((e) => e.message, 'message').equals('Must be greater than 0'),
        );
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
          (it) => it
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.')
            ..has((e) => e.toString(), 'toString').equals(
                'PackageNotFoundException: Package `Non.Existent.Package` not found.'),
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
          (it) => it
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.'),
        );
      });
    });

    group('getAllPackageMetadata', () {
      test('returns metadata for all versions of a package (1)', () async {
        final metadata =
            await client.getAllPackageMetadata('Microsoft.Win32.Registry');
        check(metadata).isNotEmpty();
        check(metadata.map((m) => m.version)).which((it) => it
          ..length.isGreaterOrEqual(55)
          ..contains('4.0.0-beta-22231')
          ..contains('4.0.0')
          ..contains('4.3.0')
          ..contains('4.7.0')
          ..contains('5.0.0-preview.1.20120.5')
          ..contains('5.0.0')
          ..contains('6.0.0-preview.1.21102.12'));
      });

      test('returns metadata for all versions of a package (2)', () async {
        final metadata = await client.getAllPackageMetadata('Serilog');
        check(metadata).isNotEmpty();
        check(metadata.map((m) => m.version)).which((it) => it
          ..length.isGreaterOrEqual(510)
          ..contains('0.1.6')
          ..contains('1.2.47')
          ..contains('1.2.48')
          ..contains('1.4.34')
          ..contains('3.0.0-dev-01794')
          ..contains('3.0.1')
          ..contains('3.0.2-dev-02042')
          ..contains('3.0.2-dev-02044'));
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.getAllPackageMetadata('Non.Existent.Package'))
            .throws<PackageNotFoundException>(
          (it) => it
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
          'Microsoft.Extensions.DependencyInjection',
          includePrerelease: true,
        );
        check(version).anyOf([
          (it) => it..contains(RegExp('(-experimental|-preview|-rc)')),
          // The latest version might not be a pre-release version.
          (it) => it
            ..not((it) => it.contains(RegExp('(-experimental|-preview|-rc)'))),
        ]);
      });

      test(
          'returns the latest version of a package (excluding pre-release versions)',
          () async {
        final version = await client.getLatestPackageVersion(
          'Microsoft.Windows.SDK.Contracts',
        );
        check(version).not((it) => it..contains('-preview'));
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.getLatestPackageVersion('Non.Existent.Package'))
            .throws<PackageNotFoundException>(
          (it) => it
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
          ..has((e) => e.packageId, 'packageId')
              .equals('Microsoft.Win32.Registry')
          ..has((e) => e.version, 'version').equals('5.0.0')
          ..has((e) => e.authors, 'authors').equals('Microsoft')
          ..has((e) => e.dependencyGroups, 'dependencyGroups')
              .isNotNull()
              .which((it) => it..length.equals(13))
          ..has((e) => e.deprecation, 'deprecation').isNull()
          ..has((e) => e.description, 'description').isNotNull().contains(
              'Provides support for accessing and modifying the Windows Registry.')
          ..has((e) => e.language, 'language').isNotNull().isEmpty()
          ..has((e) => e.minClientVersion, 'minClientVersion')
              .isNotNull()
              .equals('2.12')
          ..has((e) => e.summary, 'summary').isNotNull().isEmpty()
          ..has((e) => e.tags, 'tags').isNotNull().isEmpty()
          ..has((e) => e.isListed, 'isListed').isTrue()
          ..has((e) => e.title, 'title')
              .isNotNull()
              .equals('Microsoft.Win32.Registry')
          ..has((e) => e.iconUrl, 'iconUrl').equals(
              'https://api.nuget.org/v3-flatcontainer/microsoft.win32.registry/5.0.0/icon')
          ..has((e) => e.licenseUrl, 'licenseUrl').equals(
              'https://www.nuget.org/packages/Microsoft.Win32.Registry/5.0.0/license')
          ..has((e) => e.packageContentUrl, 'packageContentUrl').equals(
              'https://api.nuget.org/v3-flatcontainer/microsoft.win32.registry/5.0.0/microsoft.win32.registry.5.0.0.nupkg')
          ..has((e) => e.projectUrl, 'projectUrl')
              .equals('https://github.com/dotnet/runtime')
          ..has((e) => e.requireLicenseAcceptance, 'requireLicenseAcceptance')
              .isNotNull()
              .isFalse();
      });

      test('throws a PackageNotFoundException if the package does not exist',
          () async {
        await check(client.getPackageMetadata(
          'Non.Existent.Package',
          version: '1.0.0',
        )).throws<PackageNotFoundException>(
          (it) => it
            ..has((e) => e.message, 'message')
                .equals('Package `Non.Existent.Package` not found.'),
        );
      });

      test(
          'throws a PackageNotFoundException if the package with the specified version does not exist',
          () async {
        await check(client.getPackageMetadata(
          'Microsoft.Win32.Registry',
          version: '0.1.0',
        )).throws<PackageNotFoundException>(
          (it) => it
            ..has((e) => e.message, 'message').equals(
                'Package `Microsoft.Win32.Registry` (0.1.0) not found.'),
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
        check(versions).which((it) => it
          ..length.isGreaterOrEqual(92)
          ..contains('10.0.17134.1000')
          ..contains('10.0.19041.1')
          ..contains('10.0.22621.755')
          ..contains('10.0.22621-preview')
          ..contains('10.0.25931-preview'));
      });

      test('returns all versions of a package (excluding pre-release versions)',
          () async {
        final versions =
            await client.getPackageVersions('Microsoft.Windows.SDK.Contracts');
        check(versions).which((it) => it
          ..length.isGreaterOrEqual(12)
          ..contains('10.0.17134.1000')
          ..contains('10.0.19041.1')
          ..contains('10.0.22621.755')
          ..not((it) => it..contains('10.0.22621-preview'))
          ..not((it) => it..contains('10.0.25931-preview')));
      });

      test('returns an empty List if the package does not exist', () async {
        final versions =
            await client.getPackageVersions('Non.Existent.Package');
        check(versions).isEmpty();
      });
    });

    group('getReportAbuseUrl', () {
      test('returns an URL for reporting package abuse', () async {
        final url = await client.getReportAbuseUrl('Newtonsoft.Json', '13.0.3');
        check(url.toString()).equals(
          'https://www.nuget.org/packages/Newtonsoft.Json/13.0.3/ReportAbuse',
        );
      });
    });

    group('packageExists', () {
      test('returns true if the package exists', () async {
        await check(client.packageExists('Microsoft.Win32.Registry'))
            .completes((it) => it..isTrue());
      });

      test('returns true if the package with the specified version exists',
          () async {
        await check(client.packageExists(
          'Microsoft.Win32.Registry',
          version: '5.0.0',
        )).completes((it) => it..isTrue());
      });

      test('returns false if the package does not exist', () async {
        await check(client.packageExists('Non.Existent.Package'))
            .completes((it) => it..isFalse());
      });

      test(
          'returns false if the package with the specified version does not exist',
          () async {
        await check(client.packageExists(
          'Microsoft.Win32.Registry',
          version: '0.1.0',
        )).completes((it) => it..isFalse());
      });
    });

    group('searchPackages', () {
      test('includes pre-release packages in results', () async {
        final response =
            await client.searchPackages('win32', includePrerelease: true);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).isNotEmpty();
        check(response.data.map((pkg) => pkg.packageId)).which((it) => it
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..contains('Microsoft.Windows.SDK.Win32Metadata'));
      });

      test('excludes pre-release packages in results', () async {
        final response = await client.searchPackages('win32');
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).isNotEmpty();
        check(response.data.map((pkg) => pkg.packageId)).which((it) => it
          ..length.equals(20)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not((it) => it..contains('Microsoft.Windows.SDK.Win32Metadata')));
      });

      test(
          'pagination with `skip` and `take` parameters (including pre-release packages)',
          () async {
        final response = await client.searchPackages('win32',
            includePrerelease: true, skip: 1, take: 10);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).isNotEmpty();
        check(response.data.map((pkg) => pkg.packageId)).which((it) => it
          ..length.equals(10)
          ..contains('Win32')
          ..not((it) => it..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Microsoft.Win32.Primitives'));
      });

      test(
          'pagination with `skip` and `take` parameters (excluding pre-release packages)',
          () async {
        final response =
            await client.searchPackages('win32', skip: 0, take: 50);
        check(response.totalHits).isGreaterOrEqual(250);
        check(response.data).isNotEmpty();
        check(response.data.map((pkg) => pkg.packageId)).which((it) => it
          ..length.equals(50)
          ..contains('Win32')
          ..contains('Microsoft.Win32.Registry')
          ..not((it) => it..contains('Microsoft.Windows.SDK.Win32Metadata'))
          ..contains('Selenium.WebDriver.GeckoDriver.Win32'));
      });

      test('`skip` parameter must be greater or equal to 0', () async {
        await check(client.searchPackages(null, skip: -1)).throws<RangeError>(
          (it) => it..has((e) => e.message, 'message').equals('Invalid value'),
        );
      });

      test('`take` parameter must be greater than 0', () async {
        await check(client.searchPackages(null, take: 0)).throws<RangeError>(
          (it) => it
            ..has((e) => e.message, 'message').equals('Must be greater than 0'),
        );
      });
    });

    tearDownAll(() => client.close());
  });
}
