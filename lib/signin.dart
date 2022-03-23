import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp/dashboard.dart';
import 'package:webapp/signup.dart';
import 'package:webapp/utils/authentication.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool key = true;
  Color _color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        leading: Icon(Icons.group, size: 32.0,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  padding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  child: TextFormField(controller: _emailController,
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
                  padding: EdgeInsets.only(bottom: 12.0,left: 12.0, right: 12.0),
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
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05, left: MediaQuery.of(context).size.width*0.1, right:  MediaQuery.of(context).size.width*0.1),
                  child: CupertinoButton(
                      //splashColor: Colors.blueAccent,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.pink[400],
                      child: Center(
                        child: Text("Sign In", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                      onPressed: () async{
                        final email = _emailController.text.toString();
                        final password = _passwordController.text.toString();

                        await signInWithEmailPassword(email, password)
                            .then((result) {
                          setState(() {
                            _emailController.text='';
                            _passwordController.text='';
                          });
                          if(result!=null){
                            print("uuuussseeerrrIIIIDDD:");
                            print(result);
                            return Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard(uid: result,)));
                          }

                        }).catchError((error) {
                          print('Registration Error: $error');
                        });


                        // dynamic result = await _auth.signInWithEmailAndPassword(email,password);
                        //
                        // if(result!=null){
                        //   return Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard(uid: result,)));
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text("Create an Account", style: TextStyle(fontSize: 15.0),),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
