import 'search_entry.dart';

/// Represents the JSON response from the Search Resource's
/// `Search for packages` API.
///
/// See https://learn.microsoft.com/en-us/nuget/api/search-query-service-resource#response
final class SearchResponse {
  const SearchResponse({required this.totalHits, required this.data});

  /// The total number of matches, disregarding `skip` and `take`.
  final int totalHits;

  /// The search results matched by the request.
  final List<SearchEntry> data;

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'totalHits': final int totalHits,
          'data': final List<dynamic> dataVal
        }) {
      final data = dataVal
          .map((dynamic e) => SearchEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      return SearchResponse(totalHits: totalHits, data: data);
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() => 'SearchResponse(totalHits: $totalHits, data: $data)';
}
