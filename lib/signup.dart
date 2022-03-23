import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp/dashboard.dart';
import 'package:webapp/signin.dart';
import 'package:webapp/utils/authentication.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool key=true;
  Color _color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        leading: Icon(Icons.group_add, size: 35.0,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 20.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _emailController,
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
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: key,
                    decoration: InputDecoration(
                      hintText: "Enter your Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: _color,
                        size: 30,
                      ),
                      suffixIcon: IconButton(
                          icon: key==false ? Icon(Icons.remove_red_eye) : Icon(Icons.visibility_off),
                          onPressed: (){
                            key==false ? setState(() {key=true;_color=null;}) : setState(() {key=false;_color=Colors.red;});
                          }
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _nameController,
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
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "Enter your Phone Number",
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
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  child: CupertinoButton(
                      //splashColor: Colors.blueAccent,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.pink[400],
                      child: Center(
                        child: Text("Sign Up", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                      onPressed: () async {
                        final email = _emailController.text.toString();
                        final password = _passwordController.text.toString();
                        final name = _nameController.text.toString();
                        final phone = _phoneController.text.toString();


                        await registerWithEmailPassword(email, password,name,phone)
                            .then((result) async{
                          setState(() {
                            _emailController.text = '';
                            _nameController.text = '';
                            _phoneController.text = '';
                            _passwordController.text = '';
                          });
                           return Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard(uid: result,)));

                        }).catchError((error) {
                          print('Registration Error: $error');
                        });

                        // dynamic result = await _auth.registerWithEmailAndPassword(email,name,phone,password);

                        // if(result!=null){
                        //   //return Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard(uid: result,)));
                        // }
                        // else{
                        //   return CircularProgressIndicator();
                        // }

                      }

                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.008, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Text("Already has an Account", style: TextStyle(fontSize: 15.0),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
