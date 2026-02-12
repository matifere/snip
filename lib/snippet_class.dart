class SnippetClass {
  int? id;
  DateTime? createdAt;
  String title;
  String content;
  String language;
  List<String>? tags;
  bool? isFavorite;

  SnippetClass({
    this.id,
    this.createdAt,
    required this.title,
    required this.content,
    required this.language,
    this.tags,
    this.isFavorite,
  });

  factory SnippetClass.fromJson(Map<String, dynamic> map) {
    return SnippetClass(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      title: map['title'],
      content: map['content'],
      language: map['language'],
      tags: List<String>.from(map['tags'] ?? []),
      isFavorite: map['is_favorite'],
    );
  }
  Map<String, dynamic> toRequiredSupaJson() {
    return {'title': title, 'content': content, 'language': language};
  }

  @override
  String toString() {
    return title;
  }
}
