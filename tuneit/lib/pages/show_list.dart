import 'package:flutter/material.dart';
import 'package:tuneit/classes/Song.dart';

class ShowList extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ShowList> {
  List<Song> songs= new List<Song>();
  String list_title;

  Future<void> fillthelist ( ) async{

      songs.add(Song(title:'Si veo a tu mama',album:'1.jpg',artist:'Bad bunny'));
      songs.add(Song(title:'All Shall Fall',album:'2.jpeg',artist:'Immortal'));
      songs.add(Song(title:'Primo Victoria',album:'3.jpg',artist:'Sabaton'));
      songs.add(Song(title:'Si veo a tu mama',album:'1.jpg',artist:'Bad bunny'));
      songs.add(Song(title:'All Shall Fall',album:'2.jpeg',artist:'Immortal'));
      songs.add(Song(title:'Primo Victoria',album:'3.jpg',artist:'Sabaton'));
      songs.add(Song(title:'Master of Puppets',album:'4.jpg',artist:'Metallica'));
      songs.add(Song(title:'Se preparó',album:'5.jpeg',artist:'Ozuna'));
      songs.add(Song(title:'Du Hast',album:'6.jpg',artist:'Rammstein'));
      songs.add(Song(title:'Master of Puppets',album:'4.jpg',artist:'Metallica'));
      songs.add(Song(title:'Si veo a tu mama',album:'1.jpg',artist:'Bad bunny'));
      songs.add(Song(title:'All Shall Fall',album:'2.jpeg',artist:'Immortal'));
      songs.add(Song(title:'Primo Victoria',album:'3.jpg',artist:'Sabaton'));
      songs.add(Song(title:'Master of Puppets',album:'4.jpg',artist:'Metallica'));
      songs.add(Song(title:'Se preparó',album:'5.jpeg',artist:'Ozuna'));
      songs.add(Song(title:'Du Hast',album:'6.jpg',artist:'Rammstein'));
      songs.add(Song(title:'Se preparó',album:'5.jpeg',artist:'Ozuna'));
      songs.add(Song(title:'Du Hast',album:'6.jpg',artist:'Rammstein'));
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
                          Navigator.pushReplacementNamed(context, '/player',arguments: {
                          'titulo_cancion':songs[index].title,
                          'artista':songs[index].artist,
                          'url_imagen':songs[index].album
                          });
                        },

                        leading: CircleAvatar(
                         backgroundImage: AssetImage(
                           'assets/${songs[index].album}'
                         ),
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
