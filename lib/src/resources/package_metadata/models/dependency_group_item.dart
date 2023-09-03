import 'dependency_item.dart';

/// The dependencies of the package for a specific target framework.
///
/// See https://learn.microsoft.com/en-us/nuget/api/registration-base-url-resource#package-dependency-group
final class DependencyGroupItem {
  const DependencyGroupItem({
    required this.targetFramework,
    required this.dependencies,
  });

  /// The target framework that these dependencies are applicable to.
  final String? targetFramework;

  /// A list of dependencies.
  final List<DependencyItem>? dependencies;

  factory DependencyGroupItem.fromJson(Map<String, dynamic> json) =>
      DependencyGroupItem(
        targetFramework: json['targetFramework'] as String?,
        dependencies: (json['dependencies'] as List<dynamic>?)
            ?.map((e) => DependencyItem.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );

  @override
  String toString() => 'DependencyGroupItem(targetFramework: $targetFramework, '
      'dependencies: $dependencies)';
}