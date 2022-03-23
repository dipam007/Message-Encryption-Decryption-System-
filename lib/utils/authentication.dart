import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/utils/database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

bool authSignedIn;
String uid;
String userEmail;

Future<String> registerWithEmailPassword(String email, String password, String name, String phone) async {
  // Initialize Firebase;
  // await Firebase.initializeApp();
  await Firebase.initializeApp();

  final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final User user = userCredential.user;

  await DatabaseService(uid: user.uid).updateUserData(email,name,phone);

  if (user != null) {
    // checking if uid or email is null
    assert(user.uid != null);
    assert(user.email != null);

    uid = user.uid;
    userEmail = user.email;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);


    prefs.setBool('auth', true);
    prefs.setString('uid', user.uid);



    return user.uid;
  }

  return null;
}

Future<String> signInWithEmailPassword(String email, String password) async {
  // Initialize Firebase;
  // await Firebase.initializeApp();

  await Firebase.initializeApp();

  final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final User user = userCredential.user;

  if (user != null) {
    // checking if uid or email is null
    assert(user.uid != null);
    assert(user.email != null);

    uid = user.uid;
    userEmail = user.email;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print(user.uid);

    prefs.setBool('auth', true);
    prefs.setString('uid', user.uid);

    return user.uid;
  }

  return null;
}

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);
  prefs.remove('uid');

  uid = null;
  userEmail = null;

  return 'User signed out';
}