import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/songs/playlists.dart';
import "package:tuneit/pages/profile.dart";
import 'package:tuneit/pages/audio/equalizer.dart';
import 'package:tuneit/pages/social/friendList.dart';
import 'package:tuneit/pages/social/notificaciones.dart';

import '../pages/paginaInicial.dart';
import '../classes/components/Searcher.dart';
class LateralMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(Globals.imagen),
              ),
              accountName: Text(Globals.name),
              accountEmail: Text(Globals.email),
          ),
          new ListTile(
            title: Text('PAGINA PRINCIPAL'),
            onTap:(){
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            }
          ),
          new ListTile(
              title: Text('MUSICA'),
              onTap:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayLists(true),
                  ),
                );
              }
          ),
          new ListTile(
              title: Text('PODCASTS'),
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayLists(false),
                  ),
                );
              }
          ),
          new ListTile(
            title: Text('NOTIFICACIONES'),
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
              title: Text('AMIGOS'),
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
              title: Text('PERFIL'),
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
              title: Text('ECUALIZADOR'),
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