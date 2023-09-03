import 'package:nuget/nuget.dart';

void main() async {
  final client = NuGetClient();

  final versions = await client.autocompletePackageVersions(
      'Microsoft.Windows.SDK.Win32Metadata',
      includePrerelease: true);
  print(versions);

  client.close();
}
