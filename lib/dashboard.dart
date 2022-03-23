import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webapp/FireSafety.dart';
import 'package:webapp/chatpage.dart';
import 'package:webapp/decrypt.dart';
import 'package:webapp/signin.dart';
import 'package:webapp/utils/authentication.dart';

import 'drawerPage.dart';


class DashBoard extends StatefulWidget {

  final String uid;
  DashBoard({this.uid});
  @override
  _DashBoardState createState() => _DashBoardState(uid: uid);
}

class _DashBoardState extends State<DashBoard> {

  final String uid;
  _DashBoardState({this.uid});

  bool _isProcessing;

  @override
  void initState(){
    super.initState();
    _isProcessing= false;
  }


  var fsconnect = FirebaseFirestore.instance;

  myget() async {
    var d = await fsconnect.collection("students").get();
    // print(d.docs[0].data());

    for (var i in d.docs) {
      print(i.data());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Dashboard",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.wifi_tethering),
            tooltip: "Fire Alarm",
            onPressed: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FireAlarm(uid: uid,)));
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            tooltip: "Firesafety",
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FireSafety()));
            },
          ),
          IconButton(
            icon: Icon(Icons.lock_open),
            tooltip: "Decrypt your Message",
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DecryptMsg()));
            },
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app, size: 30.0,),
              tooltip: "Logout",
              onPressed: _isProcessing
              ? null
                  : () async {
                //_auth.signOut(context);
                  setState(() {
                    _isProcessing = true;
                  });
                  await signOut().then((result) {
                    print(result);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => SignIn(),
                      ),
                    );
                  }).catchError((error) {
                    print('Sign Out Error: $error');
                  });
                  setState(() {
                    _isProcessing = false;
                  });
              }
          )
        ],
      ),
      drawer: DrawerPage(uid: uid,),
      body: uid != null ? StreamBuilder<QuerySnapshot>  (
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

          print("HASError: "+ "${snapshot.hasError}");
          print("Error: "+ "${snapshot.error}");
          print("HASData: "+ "${snapshot.hasData}");
          print("Data: "+ "${snapshot.data}");

          if (snapshot.hasError) {
            return Center(
                child:Text(
                    'Something went wrong',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    )
                )
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.data.docs.length==0)
          {
            return Center(
              child: Text(
                "There are no Users in this App",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot user = snapshot.data.docs[index];
                return Card(
                    elevation: 10.0,
                    color: Colors.white,
                    margin: user.data()['uid']!=uid ? EdgeInsets.all(10.0) : EdgeInsets.all(0.0),
                    child: user.data()['uid']!=uid ? ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: Icon(Icons.account_circle, size: 50.0, color: Colors.blue,),
                      title: Text("Name: " + user.data()['name']),
                      subtitle: Text("Mobile:" + user.data()['phone']+"\nEmail:"+user.data()['email']),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(senderUid: uid, receiverUid: user.data()['uid'], receiverName: user.data()['name'])));
                      },
                    ) : SizedBox(height: 0.0,)
                );
              },
            ),
          );
        },
      ):Center(child: CircularProgressIndicator(),)
    ) ;
  }
}
