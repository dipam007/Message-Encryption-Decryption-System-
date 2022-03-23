import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webapp/utils/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String email,String name,String phone) async{
    return await brewCollection.doc(uid).set({
      'uid' : uid,
      'email' : email,
      'name' : name,
      'phone' : phone,
    });
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
      return UserData(
        uid: uid,
        email: snapshot.data()['email'],
        name: snapshot.data()["name"],
        phone: snapshot.data()["phone"],
      );
  }

  //get user doc stream
  Stream<UserData> get userData{
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

}