


import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/widgets/errors.dart';
import 'package:url_launcher/url_launcher.dart';


void eliminarCancion(BuildContext context,String nombre_lista,id_lista,int id_song) {
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
          title: new Text("¿Desea eliminar la canción?"),
          content: new Text("La canción se borrará de la lista"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirmar"),
              onPressed: () async {
                await eliminarCancionDeLista(id_lista.toString(),id_song.toString());
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowList(indetificadorLista: id_lista.toString(), list_title: nombre_lista),
                ));
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




void agregada(BuildContext context,String id_lista,String title) {
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
            title: new Text(exito_mensaje),
            content: new Text("Cancion añadida"),

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
                              agregarCancion(listas[index].id.toString(),id_song.toString());
                              Navigator.pop(context);
                              agregada(context,listas[index].id.toString(),listas[index].name);


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


void mostrarAmigos(BuildContext context,List<User> amigos, int id_song)async{

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
                itemCount: amigos.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: new ListTile(
                      onTap:() async {
                        bool resultado = await compartirCancion(amigos[index].email,id_song.toString(),amigos[index].email,Globals.name);
                        Navigator.pop(context);
                        if(resultado){
                          operacionExito(context);
                        }
                        else{
                            mostrarError(context, "No se ha podido compartir la canción");
                        }
                      },
                      title: Text(amigos[index].name),
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










