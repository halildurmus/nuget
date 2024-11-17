import 'package:nuget/nuget.dart';

void main() async {
  // Create an instance of NuGetClient.
  final client = NuGetClient();

  // Autocomplete package IDs.
  final autocompleteResponse = await client.autocompletePackageIds('json');
  print('The `json` query returned ${autocompleteResponse.totalHits} hits. '
      'Here are the first 20 results:');
  for (final packageId in autocompleteResponse.data) {
    print(' - $packageId');
  }

  print('');

  // Download package content (.nupkg).
  final content =
      await client.downloadPackageContent('Newtonsoft.Json', version: '13.0.3');
  print('`Newtonsoft.Json` package size: ${content.length} bytes');

  // Download package manifest (.nuspec).
  final manifest = await client.downloadPackageManifest('Newtonsoft.Json',
      version: '13.0.3');
  print('`Newtonsoft.Json` manifest size: ${manifest.length} bytes');

  print('');

  // Get all package metadata.
  final allMetadata = await client.getAllPackageMetadata('Newtonsoft.Json');
  print('`Newtonsoft.Json` metadata of first three versions:');
  for (final metadata in allMetadata.take(3)) {
    print(' - Version: ${metadata.version}');
    print(' - Description: ${metadata.description}');
    print(' - Author(s): ${metadata.authors}');
    print('');
  }

  // Get latest package version.
  final latestVersion = await client.getLatestPackageVersion('Newtonsoft.Json');
  print('`Newtonsoft.Json` latest version: $latestVersion');

  print('');

  // Get package metadata.
  final metadata =
      await client.getPackageMetadata('Newtonsoft.Json', version: '13.0.3');
  print('`Newtonsoft.Json` (13.0.3) metadata:');
  print(' - Version: ${metadata.version}');
  print(' - Description: ${metadata.description}');
  print(' - Author(s): ${metadata.authors}');

  print('');

  // Get package versions.
  final versions = await client.getPackageVersions('Newtonsoft.Json');
  print('`Newtonsoft.Json` has ${versions.length} versions:');
  for (final version in versions) {
    print(' - $version');
  }

  print('');

  // Check if package exists.
  final exists = await client.packageExists('Newtonsoft.Json');
  print('`Newtonsoft.Json` exists: $exists');

  print('');

  // Get report abuse URL.
  final reportAbuseUrl =
      await client.getReportAbuseUrl('Newtonsoft.Json', '13.0.3');
  print('Report abuse URL for `Newtonsoft.Json` (13.0.3): $reportAbuseUrl');

  print('');

  // Search packages.
  final searchResponse = await client.searchPackages('win32');
  print('The `win32` query returned ${searchResponse.totalHits} hits. Here are '
      'the first 20 results:');
  for (final package in searchResponse.data) {
    print(' - ${package.packageId} (${package.version})');
  }

  // Close the client when it's no longer needed.
  client.close();
}
