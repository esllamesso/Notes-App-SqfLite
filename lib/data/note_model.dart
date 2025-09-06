class Notes {
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;

  Notes({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  static Notes fromJson(Map<String, dynamic> json) => Notes(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  static Map<String, dynamic> toJson(Notes notes) => {
    'id': notes.id,
    'title': notes.title,
    'description': notes.description,
    'createdAt': notes.createdAt.toIso8601String(),
  };

  Notes copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return Notes(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
