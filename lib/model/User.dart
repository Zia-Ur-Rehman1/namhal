class User{
  String? id;
  String? name;
  String? email;
  String? password;
  String? token;
  String? role;
  User({this.id, this.name, this.email, this.password, this.token, this.role});
  //Tojson
  Map<String,dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "token": token,
      "role": role
    };
  }
  //Fromjson
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      role: json['role']
    );
  }
  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, token: $token, role: $role}';
  }


}