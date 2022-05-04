import 'package:flutter/foundation.dart';
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
  String username="";
  String email="";
  String password="";
  String token="";
  String role="";
  void setUsername(String newUsername){
    username = newUsername;
    notifyListeners();
  }
  void setEmail(String newEmail){
    email = newEmail;
    notifyListeners();
  }
  void setPassword(String newPassword){
    password = newPassword;
    notifyListeners();
  }
  void setToken(String newToken){
    token = newToken;
    notifyListeners();
  }
  void setRole(String newRole){
    role = newRole;
    notifyListeners();
  }

//get username
  getUsername(){
    return username;
  }
  getEmail(){
    return email;
  }
  getPassword(){
    return password;
  }
  getToken(){
    return token;
  }
//to string
  toString(){
    return "Username: $username, Email: $email, Password: $password, Token: $token, Role: $role";
  }
}