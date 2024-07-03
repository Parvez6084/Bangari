
import 'dart:convert';

FirebaseDBModel firebaseDatabaseModelFromJson(String str) => FirebaseDBModel.fromJson(json.decode(str));

class FirebaseDBModel {

  bool? isTicketAssign;


  FirebaseDBModel({
    this.isTicketAssign
  });

  factory FirebaseDBModel.fromJson(Map<dynamic, dynamic> json)
  => FirebaseDBModel(
     isTicketAssign: json["isTicketAssign"],
  );

}