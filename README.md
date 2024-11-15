[![ci][ci_badge]][ci_link]
[![Package: nuget][package_badge]][package_link]
[![Publisher: halildurmus.dev][publisher_badge]][publisher_link]
[![Language: Dart][language_badge]][language_link]
[![License: BSD-3-Clause][license_badge]][license_link]
[![codecov][codecov_badge_link]][codecov_link]

A Dart package that allows interaction with the
[NuGet Server API][nuget_server_api_link]. This package provides easy access to
the `NuGet Server API`, allowing you to perform various operations such as
querying package information, downloading package content, fetching package
metadata, and more.

## Features

- Autocomplete package IDs
- Download package content (`.nupkg`)
- Download package manifest (`.nuspec`)
- Get all package metadata (all versions)
- Get latest package version
- Get package metadata (specific version)
- Get package versions
- Check if a package exists
- Search packages

## Usage

### Autocomplete package IDs

```dart
import 'package:nuget/nuget.dart';

void main() async {
  // Create an instance of NuGetClient.
  final client = NuGetClient();

  const query = 'win32';
  final response = await client.autocompletePackageIds(query);
  print('The `$query` query returned ${response.totalHits} hits. '
      'Here are the first 20 results:');
  for (final packageId in response.data) {
    print(' - $packageId');
  }

  // Close the client when it's no longer needed.
  client.close();
}
```

### Download package content (`.nupkg`)

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  const version = '13.0.3';
  final content =
      await client.downloadPackageContent(packageId, version: version);
  print('`$packageId` ($version) package size: ${content.length} bytes');

  client.close();
}
```

### Download package manifest (`.nuspec`)

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  const version = '13.0.3';
  final manifest =
      await client.downloadPackageManifest(packageId, version: version);
  print('`$packageId` ($version) manifest size: ${manifest.length} bytes');

  client.close();
}
```

### Get all package metadata (all versions)

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  final allMetadata = await client.getAllPackageMetadata(packageId);
  print('`$packageId` metadata of first three versions:');
  for (final metadata in allMetadata.take(3)) {
    print(' - Version: ${metadata.version}');
    print(' - Description: ${metadata.description}');
    print(' - Author(s): ${metadata.authors}');
    print('');
  }

  client.close();
}
```

### Get latest package version

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  final latestVersion = await client.getLatestPackageVersion(packageId);
  print('`$packageId` latest version: $latestVersion');

  client.close();
}
```

### Get package metadata (specific version)

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  const version = '13.0.3';
  final metadata = await client.getPackageMetadata(packageId, version: version);
  print('`$packageId` ($version) metadata:');
  print(' - Version: ${metadata.version}');
  print(' - Description: ${metadata.description}');
  print(' - Author(s): ${metadata.authors}');

  client.close();
}
```

### Get package versions

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  final versions = await client.getPackageVersions(packageId);
  print('`$packageId` has ${versions.length} versions:');
  for (final version in versions) {
    print(' - $version');
  }

  client.close();
}
```

### Check if a package exists

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  final exists = await client.packageExists(packageId);
  print('`$packageId` exists: $exists');

  client.close();
}
```

### Search packages

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const query = 'win32';
  final searchResponse = await client.searchPackages(query);
  print('The `$query` query returned ${searchResponse.totalHits} hits. Here '
      'are the first 20 results:');
  for (final package in searchResponse.data) {
    print(' - ${package.packageId} (${package.version})');
  }

  client.close();
}
```

## Feature requests and bugs

Please file feature requests and bugs at the
[issue tracker][issue_tracker_link].

[ci_badge]: https://github.com/halildurmus/nuget/actions/workflows/nuget.yml/badge.svg
[ci_link]: https://github.com/halildurmus/nuget/actions/workflows/nuget.yml
[codecov_badge_link]: https://codecov.io/gh/halildurmus/nuget/branch/main/graph/badge.svg?token=42CZB2LDML
[codecov_link]: https://codecov.io/gh/halildurmus/nuget
[issue_tracker_link]: https://github.com/halildurmus/nuget/issues
[language_badge]: https://img.shields.io/badge/language-Dart-blue.svg
[language_link]: https://dart.dev
[license_badge]: https://img.shields.io/github/license/halildurmus/nuget?color=blue
[license_link]: https://opensource.org/licenses/BSD-3-Clause
[nuget_server_api_link]: https://learn.microsoft.com/nuget/api/overview
[package_badge]: https://img.shields.io/pub/v/nuget.svg
[package_link]: https://pub.dev/packages/nuget
[publisher_badge]: https://img.shields.io/pub/publisher/nuget.svg
[publisher_link]: https://pub.dev/publishers/halildurmus.dev
