import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/pages/playlists.dart';
import 'package:tuneit/widgets/textFields.dart';
import 'package:tuneit/widgets/OptionSongs.dart';

Widget crearListaRep(BuildContext context) {
  return RaisedButton(
    onPressed: () {
  _mostrarInforme(context);
    },
    color: Colors.transparent,
    child: new SizedBox(
      height: 60,
      width: 230.0,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
                bottomLeft: const Radius.circular(25.0),
                bottomRight: const Radius.circular(25.0),
              ),
              gradient: LinearGradient(
                colors: <Color>[
                  ColorSets.colorprimaryPink,
                  Color(0xAA5350a7),
                  Color(0xAA1c4c8b),
                ],
              ),
              border: Border.all(color: Colors.white, width: 4)
          ),
          child: Center(
            child: Text(
                'Crear nueva',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'RobotoMono'
                )
            ),
          )
      ),
    ),
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
          title: new Text("Crear nueva lista"),
          content: Center(
              child: Container(
                  width: 350,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Form(
                    key: _newkeylist,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          controller: _titulo,
                          decoration: InputDecoration(
                              hintText: "Titulo",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.deepPurple)
                          ),
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                              hintText: "Descripcion",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.deepPurple)
                          ),
                          controller: _descp,
                        ),
                        RaisedButton(
                          onPressed: () async {


                            await nuevaLista(_titulo.text, _descp.text);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayLists(true),
                              ),
                            );

                          },
                          child: Text("Crear"),

                        ),
                      ],
                    ),
                  )
              )
          ),

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

