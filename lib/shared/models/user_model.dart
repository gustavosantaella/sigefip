class User {
  final String? name;
  final String? email;

  const User({this.name, this.email});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'] as String?, email: json['email'] as String?);
  }

  User copyWith({String? name, String? email}) {
    return User(name: name ?? this.name, email: email ?? this.email);
  }
}
