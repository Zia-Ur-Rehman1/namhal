import 'package:flutter/foundation.dart';
import 'package:namhal/model/complaint.dart';

class add extends ChangeNotifier{
  String address="Not Set";
  void setAddress(String newAddress){
    address = newAddress;
    notifyListeners();
  }

}
class ComplaintObject extends ChangeNotifier{
  Complains complaint = Complains();
  void setComplaint(Complains newComplaint){
    complaint = newComplaint;
    notifyListeners();
  }
  getComplaint(){
    return complaint;
  }

}
class Status extends ChangeNotifier{
  int total = 0;
  int pending = 0;
  int InProgress = 0;
  int rejected = 0;
  int completed = 0;

  void incrementTotal(){
    total++;
    notifyListeners();
  }
  void incrementPending(){

    pending++;
    notifyListeners();
  }
  void incrementInProgress(){
    InProgress++;
    notifyListeners();
  }
  void incrementRejected(){
    rejected++;
    notifyListeners();
  }
  void incrementCompleted(){
    completed++;
    notifyListeners();
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