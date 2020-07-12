import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sclone/resources/auth_methods.dart';
import 'package:sclone/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();


  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: <Widget>[
          Center(
              child: loginButton()
          ),
          isLoginPressed ? Center(
            child: CircularProgressIndicator(),
          ) : Container(),
        ],
      ),
    );
  }

  Widget loginButton(){
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text('LOGIN',
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2
        ),
        ),
        onPressed: () => performLogin(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),
      ),
    );
  }

  void performLogin(){

    setState(() {
      isLoginPressed = true;
    });

    _authMethods.signIn().then((FirebaseUser user) {
      if(user!=null){
        authenticateUser(user);
      }else{
        print('there was an error');
      }
    });
  }

  void authenticateUser(FirebaseUser user){
    _authMethods.authenticateUser(user).then((isNewUser) {
       if(isNewUser){
         _authMethods.addDataToDb(user).then((value) {
           Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (context) {
                 return HomeScreen();
               }));
         });
       }else{
         Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context) {
             return HomeScreen();
           }
         ));
       }
     });
  }

}
