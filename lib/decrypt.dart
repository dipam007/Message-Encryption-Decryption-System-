import 'package:flutter/material.dart';

class DecryptMsg extends StatefulWidget {
  @override
  _DecryptMsgState createState() => _DecryptMsgState();
}

class _DecryptMsgState extends State<DecryptMsg> {

  final _msgController = TextEditingController();
  String _msg;

  @override
  void initState() {
    super.initState();
    _msg = '';
  }

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
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
              padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
              child: TextFormField(
                controller: _msgController,
                decoration: InputDecoration(
                  hintText: "Enter Message...",
                  prefixIcon: Icon(
                    Icons.lock_open,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 25),
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.5,
              child: MaterialButton(
                  color: Colors.blueGrey,
                  child: Center(child: Text("Decrypt", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.0),)),
                  onPressed: (){
                      setState(() {
                        _msg = _decry(_msgController.text);
                      });
                  }
                  ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 25),
              child: Text(_msg, style: TextStyle(fontSize: 40.0 ,color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, letterSpacing: 1.0),),
            )
          ],
        ),
      ),
    );
  }
}
