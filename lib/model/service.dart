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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service'] = service;
    data['manager'] = manager;
    return data;
  }

  @override
  String toString() {
    return 'Service{service: $service, manager: $manager}';
  }
}
