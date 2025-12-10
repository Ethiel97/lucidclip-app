typedef Tags = List<Tag>;

class Tag {
  Tag({
    required this.color,
    required this.createdAt,
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.userId,
  });

  final String color;

  final DateTime createdAt;

  final String id;

  final DateTime updatedAt;

  final String userId;

  final String name;

  Tag copyWith({
    String? color,
    DateTime? createdAt,
    String? id,
    String? name,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Tag(
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}
