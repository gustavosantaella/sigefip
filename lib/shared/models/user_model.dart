class User {
  final String? name;
  final String? email;
  final String? imagePath;

  const User({this.name, this.email, this.imagePath});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'imagePath': imagePath};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String?,
      email: json['email'] as String?,
      imagePath: json['imagePath'] as String?,
    );
  }

  User copyWith({String? name, String? email, String? imagePath}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
