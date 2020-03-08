import 'package:flutter/material.dart';

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
            title: Text('Perfil'),
          ),
          Ink(
              color: Colors.indigo,
              child: new ListTile(
                title: Text('Listas de reproducción', style: TextStyle(color: Colors.white),),
              )
          ),
        ],
      ),
    );
  }
}