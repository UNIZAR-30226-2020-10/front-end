import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Category.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/audioPlayerClass.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/errors.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionSongs.dart';
import 'package:tuneit/widgets/playlistOption.dart';
import 'package:tuneit/widgets/TuneITProgressIndicator%20.dart';


class ShowList extends StatefulWidget {
  @override
  _State createState() => _State(indetificadorLista,list_title,esAmigo);
  String list_title;
  String indetificadorLista;
  bool esAmigo;
  ShowList({Key key, @required this.list_title,@required this.indetificadorLista,@required this.esAmigo}):super(key : key);
}

class _State extends State<ShowList> {
  List<Audio> audios =[];
  List<Audio> todos_audios =[];
  String list_title;
  bool esAmigo;
  String indetificadorLista;
  audioPlayerClass _audioPlayerClass;
  _State(this.indetificadorLista,this.list_title,this.esAmigo);

  Future<bool> ObtenerDatos() async{
    SongLista canciones =await fetchSonglists(indetificadorLista);
   setState(() {
      audios=canciones.songs;
      todos_audios = canciones.songs;
   });

    return true;

  }


@override
  void initState(){
  ObtenerDatos();
    super.initState();
  _audioPlayerClass = new audioPlayerClass();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text( '$list_title'),
        centerTitle: true,
        actions: <Widget>[

          esAmigo?IconButton(icon: Icon(Icons.add_circle),
          tooltip: agregarListaAmigo,
          onPressed: () async {
            bool resultado = await agregarLista(
                indetificadorLista);
            if (resultado) {
              operacionExito(context);
            }
            else {
              mostrarError(context,
                  'No se ha podido agregar la lista');
            }
          },):PopupMenuButton<String>(
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
                child: ReorderableListView(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                onReorder: _onReorder,
                children: listaParaAudios(context,audios,indetificadorLista,true,choiceAction),
                ),
                ),
                ]
      ),
     bottomNavigationBar: bottomExpandableAudio(),
  );


  }
  void _onReorder(int oldIndex, int newIndex) async{
    bool exito =await reposicionarCancion(indetificadorLista,oldIndex.toString(),newIndex.toString());
    if(exito){
      setState(
            () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Song item = audios.removeAt(oldIndex);
          audios.insert(newIndex, item);
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

      setState(() {
        audios =ordenarPorArtistaAudios(audios);
      });

    }
    else if(opciones[0]==optionPlayList[2]){


      setState(() {
        audios=ordenarPorTituloAudios(audios);
      });
    }

    else if(opciones[0]==optionPlayList[3]){

      mostrarCategoriasLista ();
    }

    else if(opciones[0]==optionPlayList[4]){

      List<User> amigos=await listarAmigos();
      mostrarAmigosLista ( context, amigos,  lista);
    }
    else{
      print("Do nothing");
    }

  }

  void mostrarCategoriasLista ()async{
    List<Category> categorias = await listCategories();
    categorias.insert(0, Category(name: 'Todos los generos'));
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
                  itemCount: categorias.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: new ListTile(
                        onTap:() async {
                          if(categorias[index].name != 'Todos los generos') {
                            SongLista canciones =await fetchSonglists(indetificadorLista);
                            audios=canciones.songs;
                            setState(() {
                              audios.removeWhere((song) => !song.devolverGenero().contains(categorias[index].name));
                            });
                          }
                          else {
                            SongLista canciones =await fetchSonglists(indetificadorLista);
                            setState(() {
                              audios=canciones.songs;
                            });
                          }
                          Navigator.pop(context);
                        },
                        title: Text(categorias[index].name),
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


  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    int id_lista=int.parse(hola[2]);
    int indice=int.parse(hola[3]);

    if(choice == optionMenuSong[0]){
      List<Playlist>listas=await fetchPlaylists(Globals.email);
      mostrarListas(context,listas,id_song,false);
    }
    else if(choice ==optionMenuSong[1]){
      List<User> amigos=await listarAmigos();
      mostrarAmigos(context,amigos,id_song);

    }
    else if(choice ==optionMenuSong[2]){
      eliminarCancion(context,list_title,id_lista,id_song,esAmigo);
    }
    else if(choice == optionMenuSong[3]){
      launchInBrowser(audios[indice].devolverTitulo(),audios[indice].devolverArtista());
    }
    else if(choice == optionMenuSong[4]){
      agregarCancion(Globals.idFavorite,id_song.toString());
      agregada(context,Globals.idFavorite,audios[indice].devolverTitulo(),esAmigo);
    }
    else{
      print ("Correct option was not found");

    }

  }

}
