import 'package:flutter/material.dart';
import 'package:webapp/dashboard.dart';
import 'package:webapp/settings_form.dart';
import 'package:webapp/utils/database.dart';
import 'package:webapp/utils/user.dart';

class DrawerPage extends StatefulWidget {

  final String uid;
  DrawerPage({this.uid});
  @override
  _DrawerPageState createState() => _DrawerPageState(uid: uid);
}

class _DrawerPageState extends State<DrawerPage> {

  final String uid;
  _DrawerPageState({this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: uid).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          else {
            UserData userData = snapshot.data;
            return Container(
              child: Drawer(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text(userData.name),
                          accountEmail: Text("${userData.email}"),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/back4.jpg"),
                                fit: BoxFit.cover,
                              )
                          ),
                          currentAccountPicture: CircleAvatar(
                            child: Text(userData.name[0].toUpperCase(),
                              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                            backgroundColor: Colors.black45,
                          ),
                          // onDetailsPressed: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.home, size: 25,color: Colors.brown,),
                          title: Text("DashBoard", style: TextStyle(fontSize: 22,color: Colors.brown),),
                          enabled: true,
                          trailing: Icon(Icons.dashboard, size: 25,color:  Colors.brown[400],),
                          //is shows the icon in right side or end
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DashBoard(uid: uid,)
                            ));
                          },
                        ),
                        Divider(height: 4,),
                        ListTile(
                            leading: Icon(Icons.people, size: 25,color: Colors.blue,),
                            title: Text("Chat", style: TextStyle(fontSize: 22,color: Colors.blue),),
                            trailing: Icon(Icons.people_outline,size: 25,color: Colors.blue,),
                            //is shows the icon in right side or end
                            onTap: ()  {}
                        ),
                        Divider(height: 4,),
                        Expanded(
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: ListTile(
                                    leading: Icon(Icons.settings, size: 25),
                                    trailing: Icon(Icons.settings_applications, size: 25),
                                    title: Text("Settings", style: TextStyle(fontSize: 22,color: Colors.black54),),
                                    onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsForm(uid: uid,)));}
                                )
                            )
                        ),
                      ]
                  )
              ),
            );
          }
        }
    );
  }
}
