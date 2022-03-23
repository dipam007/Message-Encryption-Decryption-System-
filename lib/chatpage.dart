import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ChatPage extends StatefulWidget {
  final senderUid;
  final receiverUid;
  final receiverName;

  const ChatPage({Key key, this.senderUid, this.receiverUid, this.receiverName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _message = TextEditingController();
  ScrollController scrollController = ScrollController();

  var _firestore = FirebaseFirestore.instance;

  String _timeString;
  Timer timer;
  var size1;
  var size2;

  @override
  void initState() {
    super.initState();
    setState(() {
      _timeString = _formatDateTime(DateTime.now());
    });
    size1=0;
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => size2!=null ? controlScrolar() : Container());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  controlScrolar(){
    if(size2>size1)
    {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.bounceInOut,
          duration: Duration(milliseconds: 100)
      );
      setState(() {
        size1=size2;
      });
    }
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    _timeString = formattedDateTime;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message is empty!!!'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendMsg() async{
    if(_message.text.length == 0){
      _showMyDialog();
    }
    if(_message.text.length > 0) {
      String msg1='';
      String msg2='';
      String msg3='';
      for(int i=0;i<_message.text.length;i++){
        if(i%3==0)
          msg1 += _message.text[i];
        else if(i%3==1)
          msg2 += _message.text[i];
        else
          msg3 += _message.text[i];
      }
      final String finalMsg = msg1+'~'+msg2+'~'+msg3;

      await _firestore.collection('messages').doc(widget.senderUid).collection(widget.receiverUid).add({
        'Message': finalMsg,
        'sender id': widget.senderUid,
        'receiver id': widget.receiverUid,
        'receiver name': widget.receiverName,
        'message time': _timeString,
        'message length': '${_message.text.length}'
      });
      await _firestore.collection('messages').doc(widget.receiverUid).collection(widget.senderUid).add({
        'Message': finalMsg,
        'sender id': widget.senderUid,
        'receiver id': widget.receiverUid,
        'receiver name': widget.receiverName,
        'message time': _timeString,
        'message length': '${_message.text.length}'
      });
      _message.clear();
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut
      );
    }
  }

  bool check(){
    if(widget.senderUid != null && (widget.receiverName != null && widget.receiverUid != null))
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return check() ? Scaffold(
        appBar: AppBar(
          title: Text("Receiver: "+ widget.receiverName),
          centerTitle: true,
        ),
      body: Center(
        child: Column(
          children: [

            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection("messages").doc(widget.senderUid).collection(widget.receiverUid).orderBy("message time", descending: false).snapshots(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData){
                        return Center(child: CircularProgressIndicator(),);
                      }

                      List<DocumentSnapshot> docs = snapshot.data.docs;
                      size2 = snapshot.data.docs.length;

                      List<Widget> messages = docs.map((doc) => Message(
                        text: doc.data()['Message'],
                        me: widget.senderUid == doc.data()['sender id'],
                      )).toList();

                      return messages.length != 0 ? ListView(
                        controller: scrollController,
                        children: <Widget>[
                          ...messages
                        ],
                      ) :  Center(child: Text("No Message"),);
                    }
                )
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
              padding: EdgeInsets.only(bottom: 12.0,left: 12.0, right: 12.0),
              child: TextFormField(
                controller: _message,
                decoration: InputDecoration(
                  hintText: "Enter Message...",
                  suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendMsg
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    ) : Center(child: CircularProgressIndicator(),);
  }
}

class Message extends StatefulWidget {
  final String text;
  final bool me;

  const Message({Key key, this.text, this.me}) : super(key: key);
  @override
  _MessageState createState() => _MessageState(text: text, me: me);
}

class _MessageState extends State<Message> {
  final String text;
  final bool me;

   _MessageState({this.text, this.me});

   String _decry(String cipher){
     String msg1='';
     String msg2='';
     String msg3='';
     String plainText='';
     int f=0,k1=0,k2=0,k3=0;
      for(int i=0;i<cipher.length;i++){
        if(cipher[i]=='~' && f==1){
          f=2;
          continue;
        }
        if(cipher[i]=='~'){
          f=1;
          continue;
        }

        if(f==0)
          msg1+=cipher[i];
        else if(f==1)
          msg2+=cipher[i];
        else if(f==2)
          msg3+=cipher[i];
      }
      for(int i=0;i<cipher.length-2;i++){
        if(i%3==0)
          plainText+=msg1[k1++];
        else if(i%3==1)
          plainText+=msg2[k2++];
        else if(i%3==2)
          plainText+=msg3[k3++];
      }
      return plainText;
   }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            margin: me ? EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2, top: 6.0, bottom: 6.0, right: 2.0): EdgeInsets.only(right: MediaQuery.of(context).size.width*0.2, top: 6.0, bottom: 6.0, left: 2.0),
            child: Material(
              color:  me ? Colors.lightBlue : Colors.lightGreen,
              borderRadius: BorderRadius.circular(10.0),
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.028),
                child: Column(
                  children: <Widget>[
                    Text(_decry(text), style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.055, color: Colors.white,),),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}


