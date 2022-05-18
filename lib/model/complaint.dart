import 'package:cloud_firestore/cloud_firestore.dart';

class Complains {
  String? username;
  String? title;
  String? desc;
  String? service;
  String? address;
  String? img;
  String? worker;
  String? status;
  String? manager;
  String? priority;
  String? startTime;
  String? startDate;
  String? endTime;
  String? endDate;
  String? feedback;
  Timestamp? timestamp;
  bool? isComplete;
  int? reissue;
  double? rating;
  Complains({
    this.username,
    this.title,
    this.desc,
    this.service,
    this.address,
    this.manager,
    this.img,
    this.worker = "---",
    this.status,
    this.priority = "---",
    this.startTime,
    this.startDate,
    this.endTime,
    this.endDate,
    this.timestamp,
    // this.notification,
    this.feedback,
    this.isComplete = false,
    this.reissue = 0,
    this.rating=0.0,

  });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['title'] = title;
    data['desc'] = desc;

    data['service'] = service;
    data['address'] = address;
    data['manager'] = manager;
    data['img'] = img;
    data['timestamp'] = timestamp;
    data['worker'] = worker;
    data['status'] = status;
    data['priority'] = priority;
    data['startTime'] = startTime;
    data['startDate'] = startDate;
    data['endTime'] = endTime;
    data['endDate'] = endDate;
    data['feedback'] = feedback;
    data['isComplete'] = isComplete;
    data['reissue'] = reissue;
    data['rating'] = rating;
    // data['notification'] = this.notification;
    return data;
  }



  Complains.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    title = map['title'];
    desc = map['desc'];
    service = map['service'];
    address = map['address'];
    img = map['img'];
    manager = map['manager'];
    timestamp = map['timestamp'] as Timestamp;
    worker = map['worker'];
    status = map['status'];
    priority = map['priority'];
    startTime = map['startTime'];
    startDate = map['startDate'];
    endTime = map['endTime'];
    endDate = map['endDate'];
    feedback = map['feedback'];
    isComplete = map['isComplete'] as bool;
    reissue = map['reissue'] as int;
    rating = map['rating'] as double;
    // this.notification = map['notification'];
  }

  setStatus(String status) {
    this.status = status;
  }
  setPriority(String priority) {
    this.priority = priority;
  }
  setWorker(String worker) {
    this.worker = worker;
  }
  setService(String service) {
    this.service = service;
  }
  setEndTime(String endTime) {
    this.endTime = endTime;
  }
  setEndDate(String endDate) {
    this.endDate = endDate;
  }
  @override
  String toString() {
    return 'Complains{username: $username, title: $title, desc: $desc, service: $service, address: $address, img: $img, worker: $worker, status: $status, manager: $manager, priority: $priority, startTime: $startTime, startDate: $startDate, endTime: $endTime, endDate: $endDate, feedback: $feedback, timestamp: $timestamp, isComplete: $isComplete, reissue: $reissue, rating: $rating}';
  }


}
