import 'package:flutter/material.dart';
import 'package:tuneit/pages/social/yourFriends.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';

import 'finFriends.dart';

class Friend_List extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState ();
}


class _FriendListPageState extends State<Friend_List> {
  int _counter = 0;
  //----------------------------------------------------//

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Lista de Amigos'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.youtube_searched_for)),
              Tab(icon: Icon(Icons.child_friendly)),
            ],
          ),
          centerTitle: true,
        ),
        drawer: LateralMenu(),
        bottomNavigationBar: bottomExpandableAudio(),
        body: TabBarView(
          children: [
            buscarAmigos(),
            yourFriends(),
          ],
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),

    );
  }
}