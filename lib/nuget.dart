// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// A Dart library that allows interaction with the NuGet Server API.
///
/// This library provides easy access to the NuGet Server API, allowing you to
/// perform various operations such as querying package information, downloading
/// package content, fetching package metadata, and more.
///
/// Here's a basic example demonstrating how to use the `NuGetClient` class
/// to interact with the NuGet Server API:
///
/// ```dart
/// import 'package:nuget/nuget.dart';
///
/// void main() async {
///   // Create an instance of NuGetClient.
///   final client = NuGetClient();
///
///   // Download package content (.nupkg).
///   final content = await client.downloadPackageContent('Newtonsoft.Json',
///       version: '13.0.3');
///   print('`Newtonsoft.Json` package size: ${content.length} bytes');
///
///   // Get package metadata.
///   final metadata =
///       await client.getPackageMetadata('Newtonsoft.Json', version: '13.0.3');
///   print('`Newtonsoft.Json` metadata:');
///   print(' - Version: ${metadata.version}');
///   print(' - Description: ${metadata.description}');
///   print(' - Author(s): ${metadata.authors}');
///
///   // Get package versions.
///   final versions = await client.getPackageVersions('Newtonsoft.Json');
///   print('`Newtonsoft.Json` has ${versions.length} versions:');
///   for (final version in versions) {
///     print(' - $version');
///   }
///
///   // Search packages.
///   final searchResponse = await client.searchPackages('win32');
///   print('The `win32` query returned ${searchResponse.totalHits} hits. Here '
///       'are the first 20 results:');
///   for (final package in searchResponse.data) {
///     print(' - ${package.packageId} (${package.version})');
///   }
///
///   // Close the client when it's no longer needed.
///   client.close();
/// }
/// ```
library;

export 'src/client.dart';
export 'src/exception.dart';
export 'src/resources/resources.dart';
