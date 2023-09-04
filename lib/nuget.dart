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
///   // Create an instance of NuGetClient
///   final client = NuGetClient();
///
///   // List all package versions
///   final versions = await client.getPackageVersions('Newtonsoft.Json');
///   print('`Newtonsoft.Json` has ${versions.length} versions:');
///   for (final version in versions) {
///     print(' - $version');
///   }
///
///   // Search for packages
///   final searchResponse = await client.searchPackages('win32');
///   print('The `win32` query returned ${searchResponse.totalHits} hits. Here '
///       'are the first 20 results:');
///   for (final package in searchResponse.data) {
///     print(' - ${package.packageId} (${package.version})');
///   }
///
///   // Get package metadata
///   final metadata =
///       await client.getPackageMetadata('Newtonsoft.Json', version: '13.0.3');
///   print('`Newtonsoft.Json` metadata:');
///   print(' - Version: ${metadata.version}');
///   print(' - Description: ${metadata.description}');
///   print(' - Author(s): ${metadata.authors}');
///
///   // Download package content (.nupkg)
///   final content = await client.downloadPackageContent('Newtonsoft.Json',
///       version: '13.0.3');
///   print('`Newtonsoft.Json` package size: ${content.length} bytes');
///
///   // Don't forget to close the client when you're done with it
///   client.close();
/// }
/// ```
library;

export 'src/exceptions/exceptions.dart';
export 'src/nuget_client.dart';
export 'src/resources/resources.dart';
