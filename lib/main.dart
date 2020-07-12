import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sclone/provider/image_upload_provider.dart';
import 'package:sclone/provider/user_provider.dart';
import 'package:sclone/resources/auth_methods.dart';
import 'package:sclone/screens/home_screen.dart';
import 'package:sclone/screens/login_screen.dart';
import 'package:sclone/screens/search_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final AuthMethods _authMethods = AuthMethods();


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Skype clone',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",// defines that main.dart is first page
        routes: {
          '/search_screen' : (context) => SearchScreen(),
          '/login_screen' : (context) => LoginScreen(),
        },
        theme: ThemeData(
          brightness: Brightness.dark
        ),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context,AsyncSnapshot<FirebaseUser>snapshot){
            if(snapshot.hasData){
              return HomeScreen();
            }else{
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

