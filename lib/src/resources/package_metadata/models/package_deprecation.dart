// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'alternate_package.dart';
import 'package_deprecation_reason.dart';

/// A package's metadata.
///
/// See https://learn.microsoft.com/en-us/nuget/api/registration-base-url-resource#package-deprecation
final class PackageDeprecation {
  const PackageDeprecation({
    required this.reasons,
    required this.message,
    required this.alternatePackage,
  });

  /// The reasons why the package was deprecated.
  final List<PackageDeprecationReason> reasons;

  /// The additional details about this deprecation.
  final String? message;

  /// The alternate package that should be used instead.
  final AlternatePackage? alternatePackage;

  factory PackageDeprecation.fromJson(Map<String, dynamic> json) {
    if (json case {'reasons': final List<dynamic> reasonsVal}) {
      final reasons = reasonsVal
          .cast<String>()
          .map(PackageDeprecationReason.fromString)
          .toList(growable: false);
      final message = json['message'] as String?;
      final alternatePackage = json['alternatePackage'] != null
          ? AlternatePackage.fromJson(
              json['alternatePackage'] as Map<String, dynamic>)
          : null;
      return PackageDeprecation(
        reasons: reasons,
        message: message,
        alternatePackage: alternatePackage,
      );
    }
    throw FormatException('Invalid JSON: $json');
  }

  @override
  String toString() =>
      'PackageDeprecation(reasons: $reasons, message: $message, '
      'alternatePackage: $alternatePackage)';
}
