import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/songs/playlists.dart';
import 'package:tuneit/widgets/optionSongs.dart';
import 'package:tuneit/widgets/textFields.dart';

import 'buttons.dart';

Widget crearListaRep(BuildContext context) {
  return RawMaterialButton(
    child: IconButton(
        icon: Icon(Icons.add, color: Colors.white70,),
        iconSize: 30,
        onPressed: (){_mostrarInforme(context);}
    ),
    shape: new CircleBorder(),
    onPressed: (){_mostrarInforme(context);},
    fillColor: Colors.white10,
  );
}


void _mostrarInforme(BuildContext context) {
  // flutter defined function
  final _newkeylist = GlobalKey<FormState>();
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _descp = TextEditingController();
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
            title: Text(
              'Crear nueva lista',
              style: Theme.of(context).textTheme.title,
            ),

            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                textField(_titulo, false, 'Título', Icons.title),
                textField(_descp, false, 'Descripción', Icons.description),
              ],
            ),
            actions: <Widget>[
              //SizedBox(height: 15,),
              RaisedButton(
                onPressed: () async {
                  await nuevaLista(_titulo.text, _descp.text,Globals.email);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayLists(true),
                    ),
                  );
                },
                color: ColorSets.colorBlue,
                child: Text("CREAR"),
              ),

            ],

          ),

      );
    },
  );
}


void eliminarPlaylist(BuildContext context, String id_lista) async {
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
          title: new Text("¿Desea eliminar la lista?"),
          content: new Text("La lista se borrará para siempre"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirmar"),
              onPressed: () async {
                await borrarLista(id_lista);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayLists(true),
                  ),
                );

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

