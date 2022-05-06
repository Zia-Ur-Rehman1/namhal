import 'package:flutter/foundation.dart';
import 'package:namhal/model/UserObject.dart';
import 'package:namhal/model/complaint.dart';

class add extends ChangeNotifier{
  String address="Not Set";
  void setAddress(String newAddress){
    address = newAddress;
    notifyListeners();
  }
  getAddress(){
    return address;
  }

}
class ComplaintObject extends ChangeNotifier {
  Complains complaint = Complains();

  void setComplaint(Complains newComplaint) {
    complaint = newComplaint;
    notifyListeners();
  }

  getComplaint() {
    return complaint;
  }

//set priority
  setPriority(String newPriority) {
    complaint.setPriority(newPriority);
    notifyListeners();
  }
//  set status
  setStatus(String newStatus) {
    complaint.setStatus(newStatus);
    notifyListeners();
  }
//  set worker
  setWorker(String newWorker) {
    complaint.setWorker(newWorker);
    notifyListeners();
  }
  setService(String newService) {
    complaint.setService(newService);
    notifyListeners();
  }
}

class Status extends ChangeNotifier{
  int total = 0;
  int pending = 0;
  int InProgress = 0;
  int rejected = 0;
  int completed = 0;
  String toString(){
    return "Total: $total, Pending: $pending, InProgress: $InProgress, Rejected: $rejected, Completed: $completed";
  }
  void setTotal(int newTotal){
    total = newTotal;
    notifyListeners();
  }

  void setPending(int newPending){
    pending = newPending;
    notifyListeners();
  }
  void setInProgress(int newInProgress){
    InProgress = newInProgress;
    notifyListeners();
  }
    void setRejected(int newRejected){
    rejected = newRejected;
    notifyListeners();
  }
    void setCompleted(int newCompleted){
    completed = newCompleted;
    notifyListeners();
  }

}
class Info extends ChangeNotifier{
  UserObject user = UserObject();
  void setUser(UserObject newUser){
    user = newUser;
    notifyListeners();
  }
  getUser(){
    return user;
  }


}