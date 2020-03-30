import 'package:flutter/material.dart';
import 'package:tuneit/classes/Song.dart';
import 'package:tuneit/pages/player_song.dart';


class ShowList extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ShowList> {
  SongLista songs= SongLista();
  String list_title;
  int indice;
  String indetificadorLista;





  Future<void> fillthesongs () async{

    /*final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    setState(() {
      indetificadorLista=arguments['indetificadorLista'];

    });*/
    print("aaaaaaaaaa");
    SongLista list = await fetchSonglists('1');
    setState(() {
      songs=list;
    });

    print(songs.songs.length);
  }


  void ObtenerDatos() async{
    print("aaaaaa");
    await fillthesongs();
    print("bbbbbb");
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    setState(() {
      list_title=arguments['list_title'];
      indetificadorLista=arguments['indetificadorLista'];

    });

  }


@override
  void initState(){
    // TODO: implement initState
    ObtenerDatos();
    super.initState();


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
              child: ListView.builder(

                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.vertical,
                      itemCount: songs.songs.length,
                      itemBuilder: (BuildContext context, int index) {
                              return Card(
                              child: new ListTile(
                              onTap:(){


                              Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlayerPage(songs: songs.songs,indice: index),

                              ));
                              },

                              leading: imagen_por_defecto(songs.songs[index].image),
                              title: Text(songs.songs[index].title),
                              subtitle: Text(juntarArtistas(songs.songs[index].artist)),


                              ),
                              );


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
