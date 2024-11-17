import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'exception.dart';
import 'resources/resources.dart';

/// A client for interacting with the NuGet Server API.
///
/// The NuGet Server API provides a set of HTTP endpoints that enable various
/// operations such as downloading packages, fetching metadata, and more.
///
/// This client is designed to work with the NuGet Server API implemented by
/// `NuGet.org` and other NuGet-compatible package repositories.
///
/// See https://learn.microsoft.com/nuget/api/overview for more details.
final class NuGetClient {
  /// Initializes a new instance of the [NuGetClient] class.
  ///
  /// The [httpClient] parameter allows you to provide a custom HTTP client.
  /// If not provided, a default HTTP client will be created.
  ///
  /// The [serviceIndexUri] parameter represents the [Uri] of the NuGet Service
  /// Index resource. By default, it uses the `NuGet.org`'s Service Index.
  ///
  /// It's important to close the [httpClient] when it's done being used;
  /// failing to do so can cause the Dart process to hang. You can close the
  /// [httpClient] by calling the [close] method.
  NuGetClient({http.Client? httpClient, Uri? serviceIndexUri})
      : _httpClient = httpClient ?? http.Client(),
        _serviceIndexUri =
            serviceIndexUri ?? ServiceIndexResource.nugetOrgServiceIndex;

  final http.Client _httpClient;
  final Uri _serviceIndexUri;

  final _resourceCache = <Type, NuGetResource>{};
  var _isInitialized = false;

  /// Populates the [_resourceCache] with the resources specified in the service
  /// index.
  Future<void> _initialize() async {
    final serviceIndexResource = ServiceIndexResource(
      httpClient: _httpClient,
      resourceUri: _serviceIndexUri,
    );
    _resourceCache[ServiceIndexResource] = serviceIndexResource;

    final resources = await serviceIndexResource.get();
    final ServiceIndexResponse(
      :packageContentResourceUri,
      :packageMetadataResourceUri,
      :reportAbuseResourceUri,
      :searchAutocompleteResourceUri,
      :searchQueryResourceUri
    ) = resources;

    // Required resources.
    _resourceCache[PackageContentResource] = PackageContentResource(
      httpClient: _httpClient,
      resourceUri: packageContentResourceUri,
    );
    _resourceCache[PackageMetadataResource] = PackageMetadataResource(
      httpClient: _httpClient,
      resourceUri: packageMetadataResourceUri,
    );
    _resourceCache[SearchResource] = SearchResource(
      httpClient: _httpClient,
      resourceUri: searchQueryResourceUri,
    );

    // Optional resources.
    if (reportAbuseResourceUri != null) {
      _resourceCache[ReportAbuseResource] =
          ReportAbuseResource(resourceUri: reportAbuseResourceUri);
    }

    if (searchAutocompleteResourceUri != null) {
      _resourceCache[AutocompleteResource] = AutocompleteResource(
        httpClient: _httpClient,
        resourceUri: searchAutocompleteResourceUri,
      );
    }

    _isInitialized = true;
  }

  /// Retrieves the resource of type [T] from the [_resourceCache].
  T _getResource<T extends NuGetResource>() {
    assert(_isInitialized, 'The client has not been initialized.');
    if (_resourceCache.containsKey(T)) return _resourceCache[T]! as T;
    throw StateError('Resource `$T` not found.');
  }

  /// Retrieves the package IDs that match the [query].
  ///
  /// [includePrerelease] indicates whether to include *pre-release* packages in
  /// the results. Defaults to `false`.
  ///
  /// [skip] represents the number of results to skip, for pagination. It must
  /// be greater than or equal to `0`.
  ///
  /// [take] represents the number of results to return, for pagination. It must
  /// be greater than `0`.
  ///
  /// Note: A package with only *unlisted* versions will not appear in the
  /// results.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<AutocompletePackageIdsResponse> autocompletePackageIds(
    String? query, {
    bool includePrerelease = false,
    int? skip,
    int? take,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<AutocompleteResource>();
    return resource.autocompletePackageIds(
      query,
      includePrerelease: includePrerelease,
      skip: skip,
      take: take,
    );
  }

  /// Returns the contents of the package content (`.nupkg`) file for the
  /// package with the [packageId] and [version].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<Uint8List> downloadPackageContent(
    String packageId, {
    required String version,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<PackageContentResource>();
    return resource.downloadPackageContent(packageId, version: version);
  }

  /// Returns the contents of the package manifest (`.nuspec`) file for the
  /// package with the [packageId] and [version].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<Uint8List> downloadPackageManifest(
    String packageId, {
    required String version,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<PackageContentResource>();
    return resource.downloadPackageManifest(packageId, version: version);
  }

  /// Returns the metadata for all versions of the package with the [packageId].
  ///
  /// Throws a [PackageNotFoundException] if the package does not exist.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<List<CatalogEntry>> getAllPackageMetadata(String packageId) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<PackageMetadataResource>();
    final catalogEntries = <CatalogEntry>[];

    final registrationIndex = await resource.getRegistrationIndex(packageId);
    for (final registrationIndexPage in registrationIndex.items) {
      // If the package's registration index is too large, it will be divided
      // into separate registration pages stored at different URLs. In such
      // cases, we will need to fetch the items from each page individually.
      // You can identify this scenario when the registration index contains
      // `null` items.
      var items = registrationIndexPage.items;
      if (items == null) {
        final externalRegistrationPage = await resource
            .getRegistrationPage(registrationIndexPage.registrationPageUrl);
        if (externalRegistrationPage.items == null) continue;
        items = externalRegistrationPage.items;
      }

      if (items != null) {
        final entries = items.map((item) => item.catalogEntry);
        catalogEntries.addAll(entries);
      }
    }

    return catalogEntries;
  }

  /// Retrieves the latest version of the package with the [packageId].
  ///
  /// [includePrerelease] indicates whether to include *pre-release* version in
  /// the result. Defaults to `false`.
  ///
  /// Throws a [PackageNotFoundException] if the package does not exist.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<String> getLatestPackageVersion(
    String packageId, {
    bool includePrerelease = false,
  }) async {
    final versions = await getPackageVersions(
      packageId,
      includePrerelease: includePrerelease,
    );
    return switch (versions) {
      [..., final version] => version,
      _ => throw PackageNotFoundException(packageId),
    };
  }

  /// Retrieves the metadata for the package with the [packageId] and [version].
  ///
  /// Throws a [PackageNotFoundException] if the package does not exist.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<CatalogEntry> getPackageMetadata(
    String packageId, {
    required String version,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<PackageMetadataResource>();
    final registrationIndex = await resource.getRegistrationIndex(packageId);

    for (final registrationIndexPage in registrationIndex.items) {
      // Skip pages that do not contain the desired package version.
      final RegistrationIndexPage(:lower, :upper) = registrationIndexPage;
      if (lower.compareTo(version) > 0) continue;
      if (upper.compareTo(version) < 0) continue;

      // If the package's registration index is too large, it will be divided
      // into separate registration pages stored at different URLs. In such
      // cases, we will need to fetch the items from each page individually.
      // You can identify this scenario when the registration index contains
      // `null` items.
      var items = registrationIndexPage.items;
      if (items == null) {
        final externalRegistrationPage = await resource
            .getRegistrationPage(registrationIndexPage.registrationPageUrl);
        if (externalRegistrationPage.items == null) continue;
        items = externalRegistrationPage.items;
      }

      final result = items
          ?.where((item) => item.catalogEntry.version == version)
          .firstOrNull;
      // We've found the metadata for the desired version.
      if (result != null) return result.catalogEntry;
    }

    // No registration page contained the desired version.
    throw PackageNotFoundException(packageId, version);
  }

  /// Retrieves the versions of the package with the [packageId].
  ///
  /// [includePrerelease] indicates whether to include *pre-release* versions in
  /// the results. Defaults to `false`.
  ///
  /// Note: A package version that is *unlisted* will not appear in the results.
  ///
  /// Returns an empty list if the package does not exist.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<List<String>> getPackageVersions(
    String packageId, {
    bool includePrerelease = false,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<AutocompleteResource>();
    return resource.autocompletePackageVersions(
      packageId,
      includePrerelease: includePrerelease,
    );
  }

  /// Returns the URL for reporting abuse of a package with the [packageId] and
  /// [version].
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<Uri> getReportAbuseUrl(String packageId, String version) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<ReportAbuseResource>();
    return resource.getReportAbuseUrl(packageId, version);
  }

  /// Determines whether the package with the [packageId] exists.
  ///
  /// If [version] is specified, it also checks whether the package has the
  /// specified [version].
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<bool> packageExists(String packageId, {String? version}) async {
    if (!_isInitialized) await _initialize();
    try {
      final resource = _getResource<PackageContentResource>();
      final versions = await resource.getPackageVersions(packageId);
      if (version != null) return versions.contains(version);
      return versions.isNotEmpty;
    } on PackageNotFoundException {
      return false;
    }
  }

  /// Retrieves the packages that match the [query].
  ///
  /// [includePrerelease] indicates whether to include *pre-release* packages in
  /// the results. Defaults to `false`.
  ///
  /// [skip] represents the number of results to skip, for pagination. It must
  /// be greater than or equal to `0`.
  ///
  /// [take] represents the number of results to return, for pagination. It must
  /// be greater than `0`.
  ///
  /// Note: `NuGet.org` limits the [skip] parameter to *3,000* and the [take]
  /// parameter to *1,000*.
  ///
  /// Note: An *unlisted* package should never appear in search results.
  ///
  /// Throws a [NuGetServerException] if the server returns a *non-200* status
  /// code.
  Future<SearchResponse> searchPackages(
    String? query, {
    bool includePrerelease = false,
    int? skip,
    int? take,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<SearchResource>();
    return resource.searchPackages(
      query,
      includePrerelease: includePrerelease,
      skip: skip,
      take: take,
    );
  }

  /// Closes the underlying HTTP client.
  ///
  /// It's important to close the HTTP client when it's done being used;
  /// failing to do so can cause the Dart process to hang.
  void close() => _httpClient.close();
}
