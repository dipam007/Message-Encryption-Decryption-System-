import 'package:flutter/material.dart';
import 'package:webapp/utils/database.dart';
import 'package:webapp/utils/user.dart';

class SettingsForm extends StatefulWidget {

  final String uid;
  SettingsForm({this.uid});
  @override
  _SettingsState createState() => _SettingsState(uid: uid);
}

class _SettingsState extends State<SettingsForm> {

  final String uid;
  _SettingsState({this.uid});

  final _formKey = GlobalKey<FormState>();

  bool key=true;

  Color _color = Colors.blue;
  Color _lockColor;


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: uid).userData,
        builder: (context, snapshot) {
          print("HasData: ${snapshot.hasData}");
          print("Data: ${snapshot.data}");
          print("HasError: ${snapshot.hasError}");
          print("Error: ${snapshot.error}");

          if (snapshot.hasError) {
            return Center(
                child:Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )
                )
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasData){
            UserData userData = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                title: Text("Settings"),
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                ),
              ),
              body: Form(
                key: _formKey,
                child: Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0,),
                        Icon(Icons.account_box, size: 120.0, color: _color,),
                        SizedBox(height: 20.0,),
                        Container(
                          padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                          child: TextFormField(
                            initialValue: userData.email,
                            readOnly: true,
                            //enabled: false,
                            //validator: (val) => val.isEmpty ? 'Please enter Email' : null,
                            decoration: InputDecoration(
                              hintText: "Enter your Email",
                              prefixIcon: Icon(
                                Icons.email,
                                size: 30,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                          child: TextFormField(
                            initialValue: userData.name,
                            readOnly: true,
                            //enabled: false,
                            //validator: (val) => val.isEmpty ? 'Please enter Name' : null,
                            decoration: InputDecoration(
                              hintText: "Enter your Name",
                              prefixIcon: Icon(
                                Icons.person,
                                size: 30,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                          child: TextFormField(
                            initialValue: userData.phone,
                            readOnly: true,
                            //enabled: false,
                            // validator: (val) => val.isEmpty ? 'Please enter Mobile Number' : null,
                            decoration: InputDecoration(
                              hintText: "Enter your Mobile Number",
                              prefixIcon: Icon(
                                Icons.phone,
                                size: 30,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 12.0, left: 5.0, right: 5.0),
                          child: TextFormField(
                            initialValue: userData.uid,
                            readOnly: true,
                            obscureText: key,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: _lockColor,
                                size: 30,
                              ),
                              suffixIcon: IconButton(
                                  icon: key==false ? Icon(Icons.remove_red_eye) : Icon(Icons.visibility_off),
                                  onPressed: (){
                                    key==false ?
                                    setState(() {
                                      key=true;
                                      _color=Colors.blue;
                                      _lockColor=null;
                                    })
                                        : setState(() {
                                      key=false;
                                      _color=Colors.red;
                                      _lockColor=Colors.red;
                                    });
                                  }
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.2,)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }
}
