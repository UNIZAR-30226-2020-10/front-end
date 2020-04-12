import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/pages/audioPlayer.dart';


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
        title:Text( 'TuneIT'),
        centerTitle: true,
        backgroundColor: Colors.red[500],
      ),

      body: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Title(
                child: Text('$list_title',
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
              child:
              StreamBuilder(
                stream: songs.buscar_canciones_1,
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Column(
                      children: <Widget>[
                      Image(image: AssetImage('assets/LogoApp.png'),
                              fit: BoxFit.fill,
                               width: 300,
                                height: 300),
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
                                  value: (choice + "--"+index.toString()),
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

  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int indice_song=int.parse(hola[1]);
    print(indice);


    if(choice == optionMenuSong[0]){
      print("Agregar");

      List<Playlist>listas=await fetchPlaylists();

      mostrarListas(listas,indice_song);
    }
    else if(choice ==optionMenuSong[1]){
      print("Compartir");

    }
    else if(choice ==optionMenuSong[2]){
      print("Eliminar");
      _showEliminar(indice_song);

    }
    else{
      print ("Correct option was not found");

    }

  }

  // user defined function
  void _showEliminar(int indice_song) {
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
            title: new Text("¿Desea eliminar la canción?"),
            content: new Text("La canción se borrará de la lista"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Confirmar"),
                onPressed: () {
                  songs.eliminarCancion(indice_song);
                },
              ),
              new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _cancelada();
                },
                child: new Text("Cancelar"),)
            ],
          ),
        );
      },
    );
  }

  void _cancelada() {
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

  void _agregada() {
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
            title: new Text("Cancion añadida"),

          ),
        );
      },
    );
  }


  void mostrarListas(List<Playlist> listas, int indice_song)async{


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
                child: Column(
                    children: <Widget>[
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
                                        songs.agregarCancion(listas[index].id,indice_song);
                                        Navigator.pop(context);
                                        _agregada();


                                      },
                                      title: Text(listas[index].name),
                                    ),
                                  );

                        },
                            ),

                    ]
                ),
              ),
            ),
          );
        }
    );

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
