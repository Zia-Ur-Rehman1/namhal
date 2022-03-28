import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:namhal/api/TokenHandling.dart';

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

  Complains({
    this.username,
    this.title,
    this.desc,
    this.service,
    this.address,
    this.manager,
    this.img,
    this.worker = "Not Assign",
    this.status = "Not Approve",
    this.priority = "Not Set",
    this.startTime,
    this.startDate,
    this.endTime,
    this.endDate,
    this.timestamp,
    // this.notification,
    this.feedback,
    this.isComplete = false,
    this.reissue = 0,
  });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['service'] = this.service;
    data['address'] = this.address;
    data['manager'] = this.manager;
    data['img'] = this.img;
    data['timestamp'] = this.timestamp;
    data['worker'] = this.worker;
    data['status'] = this.status;
    data['priority'] = this.priority;
    data['startTime'] = this.startTime;
    data['startDate'] = this.startDate;
    data['endTime'] = this.endTime;
    data['endDate'] = this.endDate;
    data['feedback'] = this.feedback;
    data['isComplete'] = this.isComplete;
    data['reissue'] = this.reissue;
    // data['notification'] = this.notification;
    return data;
  }



  Complains.fromMap(Map<String, dynamic> map) {
    this.username = map['username'];
    this.title = map['title'];
    this.desc = map['desc'];
    this.service = map['service'];
    this.address = map['address'];
    this.img = map['img'];
    this.manager = map['manager'];
    this.timestamp = map['timestamp'] as Timestamp;
    this.worker = map['worker'];
    this.status = map['status'];
    this.priority = map['priority'];
    this.startTime = map['startTime'];
    this.startDate = map['startDate'];
    this.endTime = map['endTime'];
    this.endDate = map['endDate'];
    this.feedback = map['feedback'];
    this.isComplete = map['isComplete'] as bool;
    this.reissue = map['reissue'] as int;
    // this.notification = map['notification'];
  }

  @override
  String toString() {
    return 'Complains{username: $username, title: $title, desc: $desc, service: $service, address: $address, img: $img, worker: $worker, status: $status, manager: $manager, priority: $priority, startTime: $startTime, startDate: $startDate, endTime: $endTime, endDate: $endDate, feedback: $feedback, timestamp: $timestamp, isComplete: $isComplete, reissue: $reissue}';
  }
}
