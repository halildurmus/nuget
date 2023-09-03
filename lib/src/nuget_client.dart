// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'exceptions/exceptions.dart';
import 'resources/resources.dart';

/// A client for the NuGet Protocol API.
///
/// The NuGet Protocol API is a REST API that allows you to search for and
/// download NuGet packages from a NuGet-compatible feed. The NuGet Protocol API
/// is implemented by `NuGet.org` and other NuGet-compatible package
/// repositories.
///
/// This client implements the NuGet Protocol API version `3.0.0`.
///
/// See https://learn.microsoft.com/en-us/nuget/api/overview for more details.
final class NuGetClient {
  /// Initializes a new instance of [NuGetClient] class.
  ///
  /// [serviceIndexUri] represents the NuGet Service Index resource URI. By
  /// default, [ServiceIndexResource.nugetOrgServiceIndex] is used.
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
        httpClient: _httpClient, resourceUri: _serviceIndexUri);
    _resourceCache[ServiceIndexResource] = serviceIndexResource;

    final resources = await serviceIndexResource.get();
    final ServiceIndexResponse(
      packageContentResourceUri: packageContentResourceUrl,
      packageMetadataResourceUri: packageMetadataResourceUrl,
      searchAutocompleteResourceUri: searchAutocompleteResourceUrl,
      searchQueryResourceUri: searchQueryResourceUrl
    ) = resources;

    // Required resources
    _resourceCache[PackageContentResource] = PackageContentResource(
        httpClient: _httpClient, resourceUri: packageContentResourceUrl);
    _resourceCache[PackageMetadataResource] = PackageMetadataResource(
        httpClient: _httpClient, resourceUri: packageMetadataResourceUrl);
    _resourceCache[SearchResource] = SearchResource(
        httpClient: _httpClient, resourceUri: searchQueryResourceUrl);

    // Optional resources
    if (searchAutocompleteResourceUrl != null) {
      _resourceCache[AutocompleteResource] = AutocompleteResource(
          httpClient: _httpClient, resourceUri: searchAutocompleteResourceUrl);
    }

    _isInitialized = true;
  }

  /// Retrieves the resource of type [T] from the [_resourceCache].
  T _getResource<T extends NuGetResource>() {
    assert(_isInitialized);
    if (_resourceCache.containsKey(T)) return _resourceCache[T] as T;
    throw StateError('Resource $T not found');
  }

  /// Retrieves the package ids that match the [query].
  ///
  /// [includePrerelease] indicates whether to include pre-release packages in
  /// the results. Defaults to `false`.
  ///
  /// [skip] and [take] parameters are used for pagination. [skip] must be
  /// greater than or equal to `0`. [take] must be greater than `0`.
  ///
  /// Note: A package with only *unlisted* versions will not appear in the
  /// results.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<AutocompletePackageIdsResponse> autocompletePackageIds(
    String? query, {
    bool includePrerelease = false,
    int? skip,
    int? take,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<AutocompleteResource>();
    return await resource.autocompletePackageIds(
      query,
      includePrerelease: includePrerelease,
      skip: skip,
      take: take,
    );
  }

  /// Retrieves the package versions that match the [packageId].
  ///
  /// [includePrerelease] indicates whether to include pre-release versions in
  /// the results. Defaults to `false`.
  ///
  /// Note: A package version that is *unlisted* will not appear in the results.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<List<String>> autocompletePackageVersions(
    String packageId, {
    bool includePrerelease = false,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<AutocompleteResource>();
    return await resource.autocompletePackageVersions(
      packageId,
      includePrerelease: includePrerelease,
    );
  }

  /// Returns the contents of the package content (`.nupkg`) file for the
  /// package with the [packageId] and [version].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<Uint8List> downloadPackageContent(
    String packageId, {
    required String version,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<PackageContentResource>();
    return await resource.downloadPackageContent(packageId, version: version);
  }

  /// Returns the contents of the package manifest (`.nuspec`) file for the
  /// package with the [packageId] and [version].
  ///
  /// Throws a [PackageNotFoundException] if the server returns a *404* status
  /// code.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<Uint8List> downloadPackageManifest(
    String packageId, {
    required String version,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<PackageContentResource>();
    return await resource.downloadPackageManifest(packageId, version: version);
  }

  /// Returns the metadata for all versions of the package with the [packageId].
  ///
  /// Throws a [PackageNotFoundException] if the package with the [packageId]
  /// does not exist.
  Future<List<CatalogEntry>> getAllPackageMetadata(String packageId) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<PackageMetadataResource>();
    final metadata = <CatalogEntry>[];

    final registrationIndex = await resource.getRegistrationIndex(packageId);
    for (final registrationIndexPage in registrationIndex.items) {
      // If the package's registration index is too big, it will be split into
      // registration pages stored at different URLs. We will need to fetch each
      // page's items individually. We can detect this case as the registration
      // index will have "null" items.
      var items = registrationIndexPage.items;
      if (items == null) {
        final externalRegistrationPage = await resource
            .getRegistrationPage(registrationIndexPage.registrationPageUrl);

        // Skip malformed external pages.
        if (externalRegistrationPage.items == null) continue;

        items = externalRegistrationPage.items;
      }

      if (items != null) {
        final packageMetadata = items.map((item) => item.catalogEntry);
        metadata.addAll(packageMetadata);
      }
    }

    return metadata;
  }

  /// Retrieves the latest version of the package with the [packageId].
  ///
  /// [includePrerelease] indicates whether to include pre-release version in
  /// the result. Defaults to `false`.
  Future<String> getLatestPackageVersion(
    String packageId, {
    bool includePrerelease = false,
  }) async {
    if (!_isInitialized) await _initialize();
    final response = await searchPackages('packageid:$packageId',
        includePrerelease: includePrerelease);
    final package = response.data.firstOrNull;
    if (package != null) return package.version;
    throw PackageNotFoundException(packageId);
  }

  /// Retrieves the metadata for the package with the [packageId] and
  /// [version].
  ///
  /// Throws a [PackageNotFoundException] if the package with the [packageId]
  /// and [version] does not exist.
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

      // If the package's registration index is too big, it will be split into
      // registration pages stored at different URLs. We will need to fetch each
      // page's items individually. We can detect this case as the registration
      // index will have "null" items.
      var items = registrationIndexPage.items;
      if (items == null) {
        final externalRegistrationPage = await resource
            .getRegistrationPage(registrationIndexPage.registrationPageUrl);

        // Skip malformed external pages.
        if (externalRegistrationPage.items == null) continue;

        items = externalRegistrationPage.items;
      }

      // We've found the registration items that should cover the desired
      // package.
      final result = items
          ?.where((item) => item.catalogEntry.version == version)
          .firstOrNull;
      if (result != null) return result.catalogEntry;
    }

    // No registration page contained the desired version.
    throw PackageNotFoundException(packageId, version);
  }

  /// Retrieves the versions of the package with the [packageId].
  ///
  /// [includePrerelease] indicates whether to include pre-release versions in
  /// the results. Defaults to `true`.
  ///
  /// Note: A package version that is *unlisted* will not appear in the results.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<List<String>> getPackageVersions(
    String packageId, {
    bool includePrerelease = false,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<AutocompleteResource>();
    return await resource.autocompletePackageVersions(
      packageId,
      includePrerelease: includePrerelease,
    );
  }

  /// Determines whether the package with the [packageId] exists.
  ///
  /// If [version] is specified, it also checks whether the package with the
  /// [packageId] and [version] exists.
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
  /// [includePrerelease] indicates whether to include pre-release packages in
  /// the results. Defaults to `false`.
  ///
  /// [skip] and [take] parameters are used for pagination. [skip] must be
  /// greater than or equal to `0`. [take] must be greater than `0`.
  ///
  /// Note: `NuGet.org` limits the [skip] parameter to *3,000* and the [take]
  /// parameter to *1,000*.
  ///
  /// Note: An *unlisted* package should never appear in search results.
  ///
  /// Throws a [NuGetProtocolException] if the server returns a *non-200* status
  /// code.
  Future<SearchResponse> searchPackages(
    String? query, {
    bool includePrerelease = false,
    int? skip,
    int? take,
  }) async {
    if (!_isInitialized) await _initialize();
    final resource = _getResource<SearchResource>();
    return await resource.searchPackages(
      query,
      includePrerelease: includePrerelease,
      skip: skip,
      take: take,
    );
  }

  /// Closes the underlying HTTP client.
  ///
  /// It's important to close each client when it's done being used; failing to
  /// do so can cause the Dart process to hang.
  void close() => _httpClient.close();
}
