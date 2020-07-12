import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sclone/models/contact.dart';
import 'package:sclone/models/user.dart';
import 'package:sclone/provider/user_provider.dart';
import 'package:sclone/resources/auth_methods.dart';
import 'package:sclone/resources/chat_methods.dart';
import 'package:sclone/screens/chatscreens/chatScreens.dart';
import 'package:sclone/screens/chatscreens/widgets/cached_image.dart';
import 'package:sclone/screens/pageViews/chats/widgets/last_message_container.dart';
import 'package:sclone/screens/pageViews/chats/widgets/online_dot_indicator.dart';
import 'package:sclone/utils/universal_variables.dart';
import 'package:sclone/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {

  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });



  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        (contact != null ? contact.name : null) != null ? contact.name : "..",
        style:
        TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}

