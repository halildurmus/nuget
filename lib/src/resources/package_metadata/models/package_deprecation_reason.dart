/// Represents the reason why a package is deprecated.
///
/// See https://learn.microsoft.com/nuget/api/registration-base-url-resource#package-deprecation
enum PackageDeprecationReason {
  /// The package has bugs which make it unsuitable for usage.
  criticalBugs('CriticalBugs'),

  /// The package is no longer maintained.
  legacy('Legacy'),

  /// The package is deprecated due to an unknown reason.
  other('Other');

  const PackageDeprecationReason(this.value);

  /// Returns the enum value from a string [value].
  factory PackageDeprecationReason.fromString(String value) => switch (value) {
        final v when v.toLowerCase() == 'criticalbugs' => criticalBugs,
        final v when v.toLowerCase() == 'legacy' => legacy,
        final v when v.toLowerCase() == 'other' => other,
        _ => throw ArgumentError.value(value, 'value', 'No enum value.')
      };

  final String value;
}
