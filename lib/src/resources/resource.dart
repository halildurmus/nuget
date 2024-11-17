/// A base class for all *NuGet* resources.
abstract class NuGetResource {
  /// Creates a new instance of the [NuGetResource] with the specified
  /// [resourceUri].
  NuGetResource({required this.resourceUri});

  /// The URI of the *NuGet* resource.
  final Uri resourceUri;
}
