import 'package:flutter/material.dart';
import "package:tuneit/pages/playlists.dart";
import "package:tuneit/pages/profile.dart";
import "package:tuneit/pages/equalizer.dart";
import "package:tuneit/pages/friend_list.dart";
import "package:tuneit/pages/notificaciones.dart";
class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text('TuneIt'),
            accountEmail: Text('tuneit@music.es'),
          ),
          new ListTile(
            title: Text('Música'),
            onTap:(){
             /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerPage(),
                ),
              );*/
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