import 'package:checks/checks.dart';
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('ReportAbuseResource', () {
    late final ReportAbuseResource resource;

    setUpAll(() async {
      final serviceIndexResource = ServiceIndexResource(
        resourceUri: ServiceIndexResource.nugetOrgServiceIndex,
      );
      final ServiceIndexResponse(:reportAbuseResourceUri) =
          await serviceIndexResource.get();
      serviceIndexResource.close();
      return resource =
          ReportAbuseResource(resourceUri: reportAbuseResourceUri!);
    });

    test('getRegistrationIndex retrieves the registration index for a package',
        () {
      final url = resource.getReportAbuseUrl('Newtonsoft.Json', '13.0.3');
      check(url.toString()).equals(
        'https://www.nuget.org/packages/Newtonsoft.Json/13.0.3/ReportAbuse',
      );
    });
  });
}
