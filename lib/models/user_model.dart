class User {
  final int? id;
  final String user_name;

  const User({required this.user_name, this.id});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], user_name: json['user_name']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_name': user_name,
      };
}
