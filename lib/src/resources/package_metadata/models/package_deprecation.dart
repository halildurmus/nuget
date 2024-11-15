import 'alternate_package.dart';
import 'package_deprecation_reason.dart';

/// Represents information about a package's deprecation.
///
/// See https://learn.microsoft.com/nuget/api/registration-base-url-resource#package-deprecation
final class PackageDeprecation {
  const PackageDeprecation({
    required this.reasons,
    this.message,
    this.alternatePackage,
  });

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

  /// The reasons why the package was deprecated.
  final List<PackageDeprecationReason> reasons;

  /// The additional details about this deprecation.
  final String? message;

  /// The alternate package that should be used instead.
  final AlternatePackage? alternatePackage;

  @override
  String toString() =>
      'PackageDeprecation(reasons: $reasons, message: $message, '
      'alternatePackage: $alternatePackage)';
}
