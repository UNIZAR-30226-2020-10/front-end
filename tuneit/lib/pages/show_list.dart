import 'package:flutter/material.dart';
import 'package:tuneit/classes/Song.dart';
import 'package:tuneit/pages/player_song.dart';

class ShowList extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ShowList> {
  List<Song> songs= new List<Song>();
  String list_title;
  int indice;






  Future<void> fillthelist ( ) async{

      songs.add(Song(title:"I'll be there for you",album:'https://uh.gsstatic.es/sfAttachPlugin/1007229.jpg',artist:'The Rembrandts',url:'https://www.soundboard.com/mediafiles/22/223554-d1826dea-bfc3-477b-a316-20ded5e63e08.mp3'));
      songs.add(Song(title:'All Shall Fall',album:'https://diablorock.com/wp-content/uploads/2018/07/immortal-northern-chaos-gods.jpg',artist:'Immortal',url:'https://www.soundboard.com/mediafiles/22/223554-d1826dea-bfc3-477b-a316-20ded5e63e08.mp3'));
      songs.add(Song(title:'Primo Victoria',album:'https://images-na.ssl-images-amazon.com/images/I/81SSDwDXG%2BL._SL1400_.jpg',artist:'Sabaton',url:'https://luan.xyz/files/audio/nasa_on_a_mission.mp3'));


  }


  void ObtenerDatos() async{
    await fillthelist();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    setState(() {
      list_title=arguments['list_title'];

    });
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
              child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder:( context,index){
                    return Card(
                      child: ListTile(
                        onTap:(){

                         Navigator.of(context).push(MaterialPageRoute(
                           builder: (context) => PlayerPage(songs: songs,indice: index),

                         ));
                        },

                        leading: CircleAvatar(
                         backgroundImage: NetworkImage('${songs[index].album}'),

                        ),
                        title: Text(songs[index].title),
                        subtitle: Text(songs[index].artist),


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
