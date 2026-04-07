class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'],
        name: map['name'],
      );
}

class Note {
  final int? id;
  final String title;
  final String content;
  final int categoryId;

  Note({this.id, required this.title, required this.content, required this.categoryId});

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'category_id': categoryId,
      };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        categoryId: map['category_id'],
      );
}