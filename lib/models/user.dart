class User {
  final int id;
  final String email;
  final String username;
  final String phone;
  final String firstname;
  final String lastname;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      firstname: json['name']['firstname'],
      lastname: json['name']['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'phone': phone,
      'name': {
        'firstname': firstname,
        'lastname': lastname,
      }
    };
  }
}
