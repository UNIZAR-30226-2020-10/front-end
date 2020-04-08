import 'package:flutter/material.dart';
import 'package:tuneit/classes/Audio.dart';
import 'package:tuneit/classes/Song.dart';
import 'package:tuneit/pages/audioPlayer.dart';



class ResultSongList extends StatelessWidget {
  List<Audio> songs= new List<Song>();
  String list_title;
  int indice;
  String indetificadorLista;

  ResultSongList(this.songs,this.list_title);




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text( 'TuneIT'),
        centerTitle: true,
        backgroundColor: Colors.red[500],
      ),

      body: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Title(
              child: Text('Resultados de la busqueda de: $list_title',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 32
                ),
              ),
              color:Colors.black,



            ),
          ),
          Expanded(
            child: ListView.builder(

                        padding: const EdgeInsets.all(8),
                        scrollDirection: Axis.vertical,
                        itemCount: songs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: new ListTile(
                              onTap:(){


                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PlayerPage(audios: songs,indice: index,escanciones: true),

                                ));
                              },

                              leading: imagen_por_defecto(songs[index].devolverImagen()),
                              title: Text(songs[index].devolverTitulo()),
                              subtitle: Text(songs[index].devolverArtista()),


                            ),
                          );


                        }
                    ),


            ),



        ],
      ),
    );

  }

}

  String juntarArtistas(List<String> datos){
    String juntitos="";
    for(int i=0;i<datos.length;i++){
      juntitos+=datos[i] + ' ';

    }
    return juntitos;

  }

  Widget imagen_por_defecto(String imagen){


    if (imagen== null){
      return  new CircleAvatar( backgroundImage: AssetImage('assets/LogoApp.png'));
    }
    else{

      CircleAvatar(
        backgroundImage: NetworkImage(imagen),

      );


    }

  }
