import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sclone/constants/strings.dart';
import 'package:sclone/enum/user_state.dart';
import 'package:sclone/provider/user_provider.dart';
import 'package:sclone/resources/auth_methods.dart';
import 'package:sclone/resources/local_db/log_repository.dart';
import 'package:sclone/screens/callscreens/pickup/pickup_layout.dart';
import 'package:sclone/screens/pageViews/logs/log_screen.dart';
import 'file:///C:/Users/Jaskirat%20Singh/AndroidStudioProjects/s_clone/lib/screens/pageViews/chats/chat_list_screen.dart';
import 'package:sclone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  PageController pageController;
  int _page = 0;
  double _labeledFontsize = 10;
  UserProvider userProvider;
  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
      LogRepository.init(isHive: false,dbName: userProvider.getUser.uid);
    });

    //created instance at start of app by using WidgetsBindingObserver
    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  //WidgetsBindingObserver observes the app lifecycle very important
  //may help in notifications
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
    (userProvider != null && userProvider.getUser != null)
        ? userProvider.getUser.uid
        : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    //disposed off instance at end of app lifecycle by using WidgetsBindingObserver
    WidgetsBinding.instance.removeObserver(this);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(child: ChatListScreen(),),
            Center(child: LogScreen(),),
            Center(child: Text("Contact Screen",style: TextStyle(color: Colors.white),),),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
//        physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                    color: (_page==0)?UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "chats",
                    style: TextStyle(
                      fontSize: _labeledFontsize,
                      color: (_page==0)?UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor,
                    ),
                  ),
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                    color: (_page==1)?UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "call",
                    style: TextStyle(
                      fontSize: _labeledFontsize,
                      color: (_page==1)?UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor,
                    ),
                  ),
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone,
                    color: (_page==2)?UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "contacts",
                    style: TextStyle(
                      fontSize: _labeledFontsize,
                      color: (_page==2)?UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor,
                    ),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
