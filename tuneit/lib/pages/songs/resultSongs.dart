import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/audio/audioPlayer.dart';
import 'package:tuneit/widgets/optionSongs.dart';



class ResultSongList extends StatefulWidget {
  List<Audio> songs= new List<Song>();
  String list_title;

  ResultSongList(this.songs,this.list_title);

  @override
  _ResultSongListState createState() => _ResultSongListState(songs,list_title);
}

class _ResultSongListState extends State<ResultSongList> {
  int indice;
  List<Audio> songs= new List<Song>();
  String list_title;

  _ResultSongListState(this.songs,this.list_title);

  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    int indice=int.parse(hola[2]);



    if(choice == optionMenuSong[0]){
      print("Agregar");

      List<Playlist>listas=await fetchPlaylists(Globals.email);

      mostrarListas(context,listas,id_song);
    }
    else if(choice ==optionMenuSong[1]){
      print("Compartir");

    }
    else if(choice ==optionMenuSong[2]){

    }
    else if(choice == optionMenuSong[3]){
      launchInBrowser(widget.songs[indice].devolverTitulo(),widget.songs[indice].devolverArtista());
    }
    else{
      print ("Correct option was not found");

    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text( 'TuneIT'),
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(textoResultado,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 32
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(

                        padding: const EdgeInsets.all(8),
                        scrollDirection: Axis.vertical,
                        itemCount: widget.songs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: new ListTile(
                              onTap:(){


                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PlayerPage(audios: widget.songs,indice: index,escanciones: true),

                                ));
                              },

                              leading: GFAvatar(

                                backgroundImage: NetworkImage(widget.songs[index].devolverImagen()),
                                backgroundColor: Colors.transparent,
                                shape: GFAvatarShape.standard,

                              ),
                              title: Text(widget.songs[index].devolverTitulo()),
                              subtitle: Text(widget.songs[index].devolverArtista()),
                              trailing: PopupMenuButton<String>(
                                onSelected: choiceAction,
                                itemBuilder: (BuildContext context){
                                  return optionMenuSong.map((String choice){
                                    return PopupMenuItem<String>(
                                      value: (choice + "--"+widget.songs[index].devolverID()+"--"+index.toString()),
                                      child: Text(choice),
                                    );

                                  }).toList();
                                },
                              ),

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

