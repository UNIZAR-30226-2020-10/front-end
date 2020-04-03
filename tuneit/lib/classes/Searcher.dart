



import 'package:flutter/material.dart';
import 'package:tuneit/classes/Playlist.dart';
import 'package:tuneit/pages/result_songs.dart';

import 'Audio.dart';
import 'Song.dart';

class Searcher extends StatefulWidget {
  @override
  _SearcherState createState() => _SearcherState();
}

class _SearcherState extends State<Searcher> {
  TextEditingController editingController = TextEditingController();
  bool muisca_podcast = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[ Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: toggleSwitch,
                    value: muisca_podcast,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.green,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )
              ),

                Text('$textHolder', style: TextStyle(fontSize: 24),)

              ]),
        TextField(
          onChanged: (value) {
            //filterSearchResults(value);
              },
                controller: editingController,
                decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                suffixIcon: IconButton(icon: Icon(Icons.search),iconSize: 40, onPressed: ()async {
                  if(muisca_podcast){

                    List<Song> lista_p = await buscar_canciones(editingController.text);

                  if(lista_p==null){
                    _showDialog();
                  }
                  else{
                    ResultSongList(lista_p,editingController.text);
                  }
                  }
                  else{
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------
                    //AQUI ES DONDE BUSCARIA LAS CANCIONES
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------
                    //---------------------------------------------

                    List<Playlist> lista_p = null;

                    if(lista_p==null){

                    }
                    else{
                      _showDialog();
                    }

                  }

    }),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
      ],
    );
  }



  var textHolder = 'Podcast';

  void toggleSwitch(bool value) {

    if(muisca_podcast == false)
    {
      setState(() {
        muisca_podcast = true;
        textHolder = 'Musica';
      });
      print('Musica');
      // Put your code here which you want to execute on Switch ON event.

    }
    else
    {
      setState(() {
        muisca_podcast = false;
        textHolder = 'Podcast';
      });
      print('Podcast');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }

  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error de Busqueda"),
          content: new Text("No se ha encontrado lo que estaba buscando"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}


