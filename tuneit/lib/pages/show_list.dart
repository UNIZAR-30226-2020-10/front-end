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
              child: ReorderableListView(

                      onReorder: _onReorder,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      children: List.generate(
                      songs.songs.length,
                      (index) {
                        // ignore: missing_return
                        return Card(
                            key:ValueKey(index),

                              child: song_card(songs.songs[index].image, juntarArtistas(songs.songs[index].artist), index)
                              );

                      },
                      ),
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
      juntitos+=datos[i] +",";

    }
    return juntitos;

  }

  void _onReorder(int oldIndex, int newIndex) {
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


  Widget song_card(String imagen, String artistas,index ){
    if(imagen== null){
      imagen="https://i.blogs.es/2596e6/sonic/450_1000.jpg";
    }
    return new ListTile(
      onTap:(){


        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlayerPage(songs: songs.songs,indice: index),

        ));
      },

      leading: CircleAvatar(
        backgroundImage: NetworkImage(imagen),

      ),
      title: Text(songs.songs[index].title),
      subtitle: Text(artistas),


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
