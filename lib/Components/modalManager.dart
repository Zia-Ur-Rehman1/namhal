class Managers {
  late String name;
  late String email;
  late String phoneNo;
  late String services;

  Managers({
    required this.name,
    required this.email,
    required this.services,
    required this.phoneNo,
  });

  static toObject(var value) {
    return Managers(
      name: value['name'],
      email: value['email'],
      phoneNo: value['phoneNo'],
      services: value['services'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Managers &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          services == other.services &&
          phoneNo == other.phoneNo;

  @override
  String toString() {
    return 'Managers{name: $name, email: $email, services: $services, phoneNo: $phoneNo}';
  }
}
