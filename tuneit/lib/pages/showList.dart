import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/pages/audioPlayer.dart';
import 'package:tuneit/widgets/OptionSongs.dart';
import 'package:tuneit/widgets/PlaylistOption.dart';


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
        backgroundColor: Colors.purple,
        actions: <Widget>[

          PopupMenuButton<String>(
            onSelected: ActionPlaylist,
            itemBuilder: (BuildContext context){
              return optionPlayList.map((String choice){
                return PopupMenuItem<String>(
                  value: (indetificadorLista),
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
              StreamBuilder(
                stream: songs.buscar_canciones_1,
                builder: (context,snapshot){
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
                    return ListView.builder(

                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.songs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: new ListTile(
                         onTap:(){


                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlayerPage(audios: snapshot.data.songs,indice: index,escanciones: true),

                          ));
                         },

                          leading: imagen_por_defecto(snapshot.data.songs[index].image),
                          title: Text(snapshot.data.songs[index].name),
                          subtitle: Text(juntarArtistas(snapshot.data.songs[index].artist)),
                          trailing: PopupMenuButton<String>(
                            onSelected: choiceAction,
                            itemBuilder: (BuildContext context){
                              return optionMenuSong.map((String choice){
                                return PopupMenuItem<String>(
                                  value: (choice + "--"+snapshot.data.songs[index].id.toString()+"--"+indetificadorLista),
                                  child: Text(choice),
                                );

                              }).toList();
                            },
                          ),

                        ),
                  );


                  }
                  );
                  }
    }
              ),

              ),



          ],
    ),



      bottomNavigationBar: NewWidget(),
    );


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

  void ActionPlaylist(String lista) async{

    eliminarPlaylist(context,lista);

  }

  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    int id_lista=int.parse(hola[2]);



    if(choice == optionMenuSong[0]){
      print("Agregar");

      List<Playlist>listas=await fetchPlaylists();

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






class NewWidget extends StatefulWidget {
  const NewWidget({
    Key key,
  }) : super(key: key);

  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      child: Card(

        child: Column(

          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

          const ListTile(

            leading: Icon(Icons.album, size: 50),

            title: Text('Heart Shaker'),

            subtitle: Text('TWICE'),

            ),

          ],

        ),

    ),

    );
  }
}
