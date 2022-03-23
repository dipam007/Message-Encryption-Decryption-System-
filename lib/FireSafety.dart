import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class FireSafety extends StatefulWidget {
  @override
  _FireSafetyState createState() => _FireSafetyState();
}

class _FireSafetyState extends State<FireSafety> {

  int count=0;

  bool _checkCount(){
    return count==10 ? true : false;
  }

  _makeCall(String val){
    setState(() {
      FlutterPhoneDirectCaller.callNumber(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fire Safety"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              onChanged: (val){
                setState(() {
                  count = val.length;
                });
                if(_checkCount()){
                    _makeCall(val);
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter Phone No.',
              ),
            ),
            // RaisedButton(
            //     child: Text('Count: '+'$count'),
            //     onPressed: (){},
            // )
          ],
        ),
      ),
    );
  }
}
