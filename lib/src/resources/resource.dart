import 'package:http/http.dart' as http;

/// A base class for all *NuGet* resources.
abstract class NuGetResource {
  /// Creates a new instance of the [NuGetResource] class.
  ///
  /// * [httpClient]: The HTTP client used to make requests. If `null`, a new
  /// instance of [http.Client] is created automatically.
  /// * [resourceUri]: The [Uri] of the *NuGet* resource.
  NuGetResource({required this.resourceUri, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  /// The underlying HTTP client used to make requests.
  final http.Client httpClient;

  /// The URI of the *NuGet* resource.
  final Uri resourceUri;

  /// Closes the underlying HTTP client.
  void close() => httpClient.close();
}
