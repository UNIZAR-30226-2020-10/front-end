import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/artists.dart';
import 'package:tuneit/pages/audio/equalizer.dart';
import "package:tuneit/pages/profile.dart";
import 'package:tuneit/pages/register/login.dart';
import 'package:tuneit/pages/social/friend.dart';
import 'package:tuneit/pages/social/notificaciones.dart';
import 'package:tuneit/pages/audio/playlists.dart';

import '../pages/paginaInicial.dart';
class LateralMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(Globals.image),
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
              title: Text('ARTISTAS'),

              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Artists(),
                  ),
                );
              }
          ),
          new ListTile(
            title: Text('NOTIFICACIONES'),
              trailing:Globals.mensaje_nuevo ? Container(
                width: 100,
                height: 50,
                child:
                    Icon(Icons.add_alert,
                    color:Colors.green),


              ): Icon(Icons.add_alert,
                  color:Colors.grey),
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
                    builder: (context) => Profile(name:Globals.name,email: Globals.email,country: Globals.country,date: Globals.date,esUser: true,image: Globals.image,),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}