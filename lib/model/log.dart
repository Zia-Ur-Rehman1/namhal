class Logs{
  String? id;
  String? user;
  String? message;
  String? date;
  String? time;


  Logs({this.user, this.message, this.date, this.time, this.id});

  //toJson
  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "message": message,
    "date": date,
    "time": time,
  };
  //fromMap
  factory Logs.fromMap(Map<String, dynamic> json) => Logs(
    id: json["id"],
    user: json["user"],
    message: json["message"],
    date: json["date"],
    time: json["time"],
  );

  @override
  String toString() {
    return 'Logs{id: $id, user: $user, message: $message, date: $date, time: $time}';
  }
}