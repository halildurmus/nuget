/// Represents a package dependency.
///
/// See https://learn.microsoft.com/nuget/api/registration-base-url-resource#package-dependency
final class DependencyItem {
  const DependencyItem({required this.id, this.range, this.registration});

  factory DependencyItem.fromJson(Map<String, dynamic> json) {
    if (json case {'id': final String id}) {
      final range = json['range'] as String?;
      final registration = json['registration'] as String?;
      return DependencyItem(id: id, range: range, registration: registration);
    }
    throw FormatException('Invalid JSON: $json');
  }

  /// The ID of the package dependency.
  final String id;

  /// The allowed version range of the dependency.
  final String? range;

  /// The URL to the registration index for this dependency.
  final String? registration;

  @override
  String toString() => 'DependencyItem(id: $id, range: $range, '
      'registration: $registration)';
}
