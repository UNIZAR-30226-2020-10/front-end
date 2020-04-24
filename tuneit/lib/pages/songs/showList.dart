import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/bottomExpandableAudio.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/audio/audioPlayer.dart';
import 'package:tuneit/widgets/optionSongs.dart';
import 'package:tuneit/widgets/playlistOption.dart';


class ShowList extends StatefulWidget {
  @override
  _State createState() => _State(indetificadorLista,list_title);
  String list_title;
  String indetificadorLista;
  bool tipo;
  String contenido;

  ShowList({Key key, @required this.list_title,@required this.indetificadorLista}):super(key : key);
}

class _State extends State<ShowList> {
  SongLista songs= SongLista();
  String list_title;
  int indice;
  String indetificadorLista;

  _State(this.indetificadorLista,this.list_title);



  void ObtenerDatos() async{

          SongLista canciones =await fetchSonglists(indetificadorLista);
          setState(() {
            songs=canciones;
          });

          await songs.fetchSonglists(indetificadorLista);
    }




@override
  void initState(){
    // TODO: implement initState

    super.initState();
    ObtenerDatos();


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text( '$list_title'),
        centerTitle: true,
        actions: <Widget>[

          PopupMenuButton<String>(
            onSelected: ActionPlaylist,
            itemBuilder: (BuildContext context){
              return optionPlayList.map((String choice){
                return PopupMenuItem<String>(
                  value: (choice+"--"+indetificadorLista),
                  child: Text(choice),
                );

              }).toList();
            },
          ),



        ],
      ),

      body: Column(
          children: <Widget>[
            Expanded(
              child:
                   StreamBuilder<Object>(
                     stream: songs.buscar_canciones_1,
                     builder: (context, snapshot) {

                       if(!snapshot.hasData){
                         return Column(
                           children: <Widget>[
                             Image(image: AssetImage('assets/LogoApp.png'),
                                 fit: BoxFit.fill,
                                 width: 200,
                                 height: 200),
                             Text("Buscando en nuestra base de datos las mejores canciones...")


                           ],
                         );
                       }
                       else{
                         return ReorderableListView(

                           padding: const EdgeInsets.all(8),
                           scrollDirection: Axis.vertical,
                           onReorder: _onReorder,

                           children: List.generate(
                             songs.songs.length,
                                 (index) {
                               return
                                 Card(
                                   key: Key('$index'),
                                   child: new ListTile(
                                     onTap:(){
                                       Navigator.of(context).push(MaterialPageRoute(
                                         builder: (context) => PlayerPage(audios: songs.songs,indice: index,escanciones: true),

                                       ));
                                     },

                                     leading:       CircleAvatar(
                                       radius: 15.0,
                                       backgroundImage: NetworkImage(songs.songs[index].image),
                                       backgroundColor: Colors.transparent,

                                     ),
                                     //imagen_por_defecto(songs.songs[index].image),
                                     title: Text(songs.songs[index].name),
                                     subtitle: Text(songs.songs[index].devolverArtista()),
                                     trailing: PopupMenuButton<String>(
                                       onSelected: choiceAction,
                                       itemBuilder: (BuildContext context){
                                         return optionMenuSong.map((String choice){
                                           return PopupMenuItem<String>(
                                             value: (choice + "--"+songs.songs[index].id.toString()+"--"+indetificadorLista),
                                             child: Text(choice),
                                           );

                                         }).toList();
                                       },
                                     ),

                                   ),
                                 );

                             },
                           ),


                         );
                       }
                     }
                   ),
    ),



    ]


              ),
      bottomNavigationBar: bottomExpandableAudio(),
  );


  }

  void _onReorder(int oldIndex, int newIndex) async{
    bool exito =await reposicionarCancion(songs.id.toString(),oldIndex.toString(),newIndex.toString());
    if(exito){
      setState(
            () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Song item = songs.songs.removeAt(oldIndex);
          songs.songs.insert(newIndex, item);

        },
      );
    }
  }



  void ActionPlaylist(String contenido) async{

    List<String> opciones=contenido.split("--");
    String lista=opciones[1];

    if(opciones[0]==optionPlayList[0]){
      eliminarPlaylist(context,lista);
    }
    else if(opciones[0]==optionPlayList[1]){
      print(opciones[0]);

      setState(() {
        songs.ordenarPorArtista();


      });

    }
    else if(opciones[0]==optionPlayList[2]){
      print(opciones[0]);

      setState(() {

        songs.ordenarPorTitulo();

      });

    }
    else{
      print("Do nothing");
    }

  }

  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    int id_lista=int.parse(hola[2]);



    if(choice == optionMenuSong[0]){
      print("Agregar");

      List<Playlist>listas=await fetchPlaylists(Globals.email);

      mostrarListas(context,listas,id_song);
    }
    else if(choice ==optionMenuSong[1]){
      print("Compartir");

    }
    else if(choice ==optionMenuSong[2]){
      print("Eliminar");
      //(BuildContext context,String nombre_lista,id_lista,int id_song)
      eliminarCancion(context,list_title,id_lista,id_song);

    }
    else{
      print ("Correct option was not found");

    }

  }



}