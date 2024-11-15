import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('PackageMetadataResource', () {
    late final PackageMetadataResource resource;

    setUpAll(() async {
      final serviceIndexResource = ServiceIndexResource(
          resourceUri: ServiceIndexResource.nugetOrgServiceIndex);
      final ServiceIndexResponse(:packageMetadataResourceUri) =
          await serviceIndexResource.get();
      serviceIndexResource.close();
      return resource =
          PackageMetadataResource(resourceUri: packageMetadataResourceUri);
    });

    test('getRegistrationIndex retrieves the registration index for a package',
        () async {
      final response = await resource.getRegistrationIndex('Newtonsoft.Json');
      check(response)
        ..has((e) => e.count, 'count').equals(2)
        ..has((e) => e.items, 'items').isNotEmpty();
    });

    test(
        'getRegistrationIndex retrieves the registration index for a deprecated package',
        () async {
      final response =
          await resource.getRegistrationIndex('EntityFramework.MappingAPI');
      check(response)
        ..has((e) => e.count, 'count').equals(1)
        ..has((e) => e.items, 'items').isNotEmpty();
    });

    test('getRegistrationPage retrieves the registration page', () async {
      final registrationIndex = await resource.getRegistrationIndex('Serilog');
      final pageUrl = registrationIndex.items.first.registrationPageUrl;
      final response = await resource.getRegistrationPage(pageUrl);
      check(response)
        ..has((e) => e.count, 'count').equals(64)
        ..has((e) => e.items, 'items').isNotNull();
    });

    test('getRegistrationLeaf retrieves the registration leaf', () async {
      final registrationIndex = await resource.getRegistrationIndex('Serilog');
      final pageUrl = registrationIndex.items.first.registrationPageUrl;
      final page = await resource.getRegistrationPage(pageUrl);
      check(page.items).isNotNull().isNotEmpty();
      final leafUrl = page.items!.first.registrationLeafUrl;
      final response = await resource.getRegistrationLeaf(leafUrl);
      check(response)
        ..has((e) => e.catalogEntry, 'catalogEntry').isNotNull()
        ..has((e) => e.listed, 'listed').isNotNull().isTrue()
        ..has((e) => e.published, 'published').isNotNull()
        ..has((e) => e.registrationLeafUrl, 'registrationLeafUrl')
            .equals(leafUrl);
    });

    tearDownAll(() => resource.close());
  });
}
