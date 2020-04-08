import 'package:flutter/material.dart';
import 'package:tuneit/pages/mainView.dart';
import "package:tuneit/pages/playlists.dart";
import "package:tuneit/pages/profile.dart";
import "package:tuneit/pages/equalizer.dart";
import "package:tuneit/pages/friendList.dart";
import "package:tuneit/pages/notificaciones.dart";

import '../../main.dart';
import 'Searcher.dart';
class LateralMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
        //  Image(image: AssetImage('assets/LogoAppName.png'),),
          new UserAccountsDrawerHeader(
          currentAccountPicture: Image(image: AssetImage('assets/LogoAppName.png'),fit: BoxFit.contain),
            accountName: Text('TuneIt'),
            accountEmail: Text('tuneit@music.es'),
          ),
          Searcher(),
          new ListTile(
            title: Text('Música'),
            onTap:(){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'TuneIT'),
                ),
              );
            }
          ),
          new ListTile(
            title: Text('Listas de reproducción'),
            onTap:() {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayLists(),
                ),
              );
            }
          ),
          new ListTile(
            title: Text('Notificaciones'),
            onTap:() {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Notificaciones(),
                ),
              );
            }
          ),
          new ListTile(
              title: Text('Amigos'),
              onTap:() {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => Friend_List(),
                ),
                );
              }
          ),
          new ListTile(
              title: Text('Perfil'),
              onTap:() {
                Navigator.push(
                context,
                MaterialPageRoute(
                   builder: (context) => Profile(),
                  ),
                );
              }
          ),
        new ListTile(
            title: Text('Ecualizador'),
            onTap:() {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Equalizer(),
                ),
              );
            }
          ),

        ],
      ),
    );
  }
}