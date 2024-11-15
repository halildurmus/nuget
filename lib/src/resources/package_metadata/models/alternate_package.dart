/// The alternate package that should be used instead of a deprecated package.
///
/// See https://learn.microsoft.com/nuget/api/registration-base-url-resource#alternate-package
final class AlternatePackage {
  const AlternatePackage({required this.id, this.range});

  factory AlternatePackage.fromJson(Map<String, dynamic> json) {
    if (json case {'id': final String id}) {
      final range = json['range'] as String?;
      return AlternatePackage(id: id, range: range);
    }
    throw FormatException('Invalid JSON: $json');
  }

  /// The ID of the alternate package.
  final String id;

  /// The allowed version range, or `*` if any version is allowed.
  final String? range;

  @override
  String toString() => 'AlternatePackage(id: $id, range: $range)';
}
