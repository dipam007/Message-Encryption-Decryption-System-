import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/dashboard.dart';
import 'package:webapp/signin.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Message Encryption Decryption System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String userId;

  @override
  void initState(){
    super.initState();
    checkingLogOutOrNot();
  }

   Future<void> checkingLogOutOrNot() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('uid');
    });
    print(userId);
  }
  @override
  Widget build(BuildContext context){
    return userId == null ? SignIn():DashBoard(uid: userId,);
  }
}
