


import 'package:flutter/material.dart';

import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';






// user defined function
void eliminarCancion(BuildContext context,id_lista,int id_song) {
  // flutter defined function
  SongLista songs= new SongLista();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return GestureDetector(

        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: AlertDialog(
          title: new Text("¿Desea eliminar la canción?"),
          content: new Text("La canción se borrará de la lista"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirmar"),
              onPressed: () {
                songs.eliminarCancion(id_lista.toString(),id_song.toString());
                Navigator.pop(context);
                _eliminada(context);
              },
            ),
            new FlatButton(
              onPressed: (){
                Navigator.pop(context);
                _cancelada(context);
              },
              child: new Text("Cancelar"),)
          ],
        ),
      );
    },
  );
}

void _cancelada(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return GestureDetector(

        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: AlertDialog(
          title: new Text("Operacion cancelada"),

        ),
      );
    },
  );
}

void _eliminada(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return GestureDetector(

        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: AlertDialog(
          title: new Text("Cancion eliminada"),

        ),
      );
    },
  );
}

void _agregada(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return GestureDetector(

        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: AlertDialog(
          title: new Text("Cancion añadida"),

        ),
      );
    },
  );
}


void mostrarListas(BuildContext context,List<Playlist> listas, int id_song)async{
  SongLista songs= new SongLista();

   showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: AlertDialog(
            content:Container(
              width: double.maxFinite,
              child: Column(
                  children: <Widget>[
                    //itemCount: snapshot.data.songs.length,
                    ListView.builder(

                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.vertical,
                      itemCount: listas.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: new ListTile(
                            onTap:(){
                              songs.agregarCancion(listas[index].id.toString(),id_song.toString());
                              Navigator.pop(context);
                              _agregada(context);


                            },
                            title: Text(listas[index].name),
                          ),
                        );

                      },
                    ),

                  ]
              ),
            ),
          ),
        );
      }
  );

}





