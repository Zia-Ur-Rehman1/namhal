class UserObject {
  String? name;
  String? email;
  String? password;
  String? token;
  UserObject({ this.name, this.email, this.password, this.token});
  //Tojson
  Map<String,dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "token": token,
    };
  }
  
  //Fromjson
  factory UserObject.fromJson(Map<String, dynamic>? json) {
    return UserObject(
      name: json?['name'],
      email: json?['email'],
      password: json?['password'],
      token: json?['token'],
    );
  }
  @override
  String toString() {
    return 'UserObject{ name: $name, email: $email, password: $password, token: $token}';
  }


}