class Note {
  final int? id;
  final String title;
  final String description;
  final int user_id;

  const Note(
      {required this.title,
      required this.description,
      this.id,
      required this.user_id});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        user_id: json['user_id'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'user_id': user_id,
      };
}
