// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Exception thrown when a server returns *non-200* status code.
final class NuGetServerException implements Exception {
  const NuGetServerException(this.message);

  final String message;

  @override
  String toString() => 'NuGetServerException: $message';
}

/// Exception thrown when a package is not found.
final class PackageNotFoundException implements Exception {
  const PackageNotFoundException(this.packageId, [this.packageVersion]);

  final String packageId;
  final String? packageVersion;

  String get message => packageVersion != null
      ? 'Package `$packageId` ($packageVersion) not found.'
      : 'Package `$packageId` not found.';

  @override
  String toString() => 'PackageNotFoundException: $message';
}
