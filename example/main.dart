// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:nuget/nuget.dart';

void main() async {
  // Create an instance of NuGetClient
  final client = NuGetClient();

  // Get latest package version
  final latestVersion = await client.getLatestPackageVersion('Newtonsoft.Json');
  print('`Newtonsoft.Json` latest version: $latestVersion');

  print('');

  // List package versions
  final versions = await client.getPackageVersions('Newtonsoft.Json');
  print('`Newtonsoft.Json` has ${versions.length} versions:');
  for (final version in versions) {
    print(' - $version');
  }

  print('');

  // Check if a package exists
  final result1 = await client.packageExists('Newtonsoft.Json');
  print('`Newtonsoft.Json` exists: $result1');
  final result2 = await client.packageExists('Newtonsoft.Json2');
  print('`Newtonsoft.Json2` exists: $result2');

  print('');

  // Search packages
  final searchResponse = await client.searchPackages('win32');
  print('The `win32` query returned ${searchResponse.totalHits} hits. Here are '
      'the first 20 results:');
  for (final package in searchResponse.data) {
    print(' - ${package.packageId} (${package.version})');
  }

  print('');

  // Get package metadata
  final metadata =
      await client.getPackageMetadata('Newtonsoft.Json', version: '13.0.3');
  print('`Newtonsoft.Json` metadata:');
  print(' - Version: ${metadata.version}');
  print(' - Description: ${metadata.description}');
  print(' - Author(s): ${metadata.authors}');

  print('');

  // Download a package content (.nupkg)
  final content =
      await client.downloadPackageContent('Newtonsoft.Json', version: '13.0.3');
  print('`Newtonsoft.Json` package size: ${content.length} bytes');

  // Download a package manifest (.nuspec)
  final manifest = await client.downloadPackageManifest('Newtonsoft.Json',
      version: '13.0.3');
  print('`Newtonsoft.Json` manifest size: ${manifest.length} bytes');

  // Close the client when you're done
  client.close();
}
