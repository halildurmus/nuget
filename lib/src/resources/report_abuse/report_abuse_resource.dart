import '../resource.dart';

/// The NuGet Report Abuse resource, used to construct URLs for reporting abuse
/// related to a package.
///
/// See https://learn.microsoft.com/nuget/api/report-abuse-resource
final class ReportAbuseResource extends NuGetResource {
  ReportAbuseResource({required super.resourceUri});

  /// Constructs a URL for reporting abuse of a package with the [packageId] and
  /// [version].
  Uri getReportAbuseUrl(String packageId, String version) => Uri.parse(
        resourceUri
            .toString()
            // https://www.nuget.org/packages/{id}/{version}/ReportAbuse
            // Replace {id} and {version} with the given packageId and version.
            .replaceFirst('%7Bid%7D', Uri.encodeComponent(packageId))
            .replaceFirst('%7Bversion%7D', Uri.encodeComponent(version)),
      );
}
