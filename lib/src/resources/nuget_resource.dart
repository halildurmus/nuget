import 'package:http/http.dart' as http;

abstract class NuGetResource {
  NuGetResource({http.Client? httpClient, required this.resourceUri})
      : httpClient = httpClient ?? http.Client();

  final http.Client httpClient;
  final Uri resourceUri;

  /// Closes the underlying HTTP client.
  void close() => httpClient.close();
}
