class UserObject {
  String? name;
  String? email;
  String? pass;
  String? token;
  UserObject({ this.name, this.email, this.pass, this.token});
  //Tojson
  Map<String,dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "pass": pass,
      "token": token,
    };
  }
  
  //Fromjson
  factory UserObject.fromJson(Map<String, dynamic>? json) {
    return UserObject(
      name: json?['name'],
      email: json?['email'],
      pass: json?['pass'],
      token: json?['token'],
    );
  }
  @override
  String toString() {
    return 'UserObject{ name: $name, email: $email, password: $pass, token: $token}';
  }


}