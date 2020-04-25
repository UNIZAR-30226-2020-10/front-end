


import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:url_launcher/url_launcher.dart';






// user defined function
void eliminarCancion(BuildContext context,String nombre_lista,id_lista,int id_song) {
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
              onPressed: () async {
                await songs.eliminarCancion(id_lista.toString(),id_song.toString());
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowList(indetificadorLista: id_lista.toString(), list_title: nombre_lista),
                ));
                //_eliminada(context,nombre_lista,id_lista.toString());
              },
            ),
            new FlatButton(
              onPressed: (){
                Navigator.pop(context);
                operacionCancelada(context);
              },
              child: new Text("Cancelar"))
          ],
        ),
      );
    },
  );
}

void operacionCancelada(BuildContext context) {
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

void _agregada(BuildContext context,String id_lista,String title) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return GestureDetector(

        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          onTapReload (context,id_lista,title);


          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            onTapReload(context,id_lista,title);

          }
        },

        child: AlertDialog(
          title: new Text("Cancion añadida"),

        ),
      );
    },
  );
}





void onTapReload (BuildContext context,String id_lista,String title) {
  Navigator.pop(context);
  Navigator.pop(context);
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ShowList(indetificadorLista: id_lista, list_title: title),
  ));
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
               child:
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
                              _agregada(context,listas[index].id.toString(),listas[index].name);


                            },
                            title: Text(listas[index].name),
                          ),
                        );

                      },
                    ),

            ),
          ),
        );
      }
  );

}

Future<void> launchInBrowser(String cancion,String artista) async {
  String url= 'https://google.com/search?q=';
  url= url + artista+'+'+cancion;
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}







