[![ci][ci_badge]][ci_link]
[![Package: nuget][package_badge]][package_link]
[![Publisher: halildurmus.dev][publisher_badge]][publisher_link]
[![Language: Dart][language_badge]][language_link]
[![License: BSD-3-Clause][license_badge]][license_link]
[![codecov][codecov_badge_link]][codecov_link]

**A lightweight Dart client for querying and interacting with the
[NuGet Server API][nuget_server_api_link].**

## ✨ Features

- 🔍 Autocomplete package IDs
- 📦 Download package content (`.nupkg`) and manifest (`.nuspec`)
- 📋 Fetch package metadata — all versions or a specific version
- 🏷️ Get the latest package version or list all versions
- ✅ Check if a package exists
- 🔗 Get the report abuse URL for a package
- 🔎 Search packages

## 🚀 Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  nuget: ^0.2.0
```

Then import it:

```dart
import 'package:nuget/nuget.dart';
```

## ⚡ Quick Example

Download the `.nupkg` content for a specific package version:

```dart
import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  const packageId = 'Newtonsoft.Json';
  const version = '13.0.3';
  final content = await client.downloadPackageContent(
    packageId,
    version: version,
  );
  print('`$packageId` ($version) package size: ${content.length} bytes');

  client.close();
}
```

## 🐞 Features and Bugs

If you encounter bugs or need additional functionality, please
[file an issue][issue_tracker_link].

[ci_badge]: https://github.com/halildurmus/nuget/actions/workflows/nuget.yml/badge.svg
[ci_link]: https://github.com/halildurmus/nuget/actions/workflows/nuget.yml
[codecov_badge_link]: https://codecov.io/gh/halildurmus/nuget/branch/main/graph/badge.svg?token=42CZB2LDML
[codecov_link]: https://codecov.io/gh/halildurmus/nuget
[nuget_server_api_link]: https://learn.microsoft.com/nuget/api/overview
[issue_tracker_link]: https://github.com/halildurmus/nuget/issues
[language_badge]: https://img.shields.io/badge/language-Dart-blue.svg
[language_link]: https://dart.dev
[license_badge]: https://img.shields.io/github/license/halildurmus/nuget?color=blue
[license_link]: https://opensource.org/licenses/BSD-3-Clause
[package_badge]: https://img.shields.io/pub/v/nuget.svg
[package_link]: https://pub.dev/packages/nuget
[publisher_badge]: https://img.shields.io/pub/publisher/nuget.svg
[publisher_link]: https://pub.dev/publishers/halildurmus.dev
