class Service {
  String? service;
  String? manager;

  Service({this.service, this.manager});
  factory Service.toJson(Map<String, dynamic> json) {
    return Service(
      service: json['service'],
      manager: json['manager'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service'] = this.service;
    data['manager'] = this.manager;
    return data;
  }

  @override
  String toString() {
    return 'Service{service: $service, manager: $manager}';
  }
}
