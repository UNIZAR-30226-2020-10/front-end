import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Song.dart';
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
    Duration _position;
    Duration _duration;
    return new BottomAppBar(
      child: Card(

        child: Column(

          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

          const ListTile(

            leading: Icon(Icons.album, size: 50),

            title: Text('Nombre de la Canción Correspondiente'),

            subtitle: Text('Artista de la canción correspondiente'),

            ),
            SizedBox(
              child: SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  trackHeight: 3,
                  thumbColor: Colors.pink,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: Colors.pink,
                  overlayColor: Colors.transparent,
                ),
                child: Slider(
                  value:
                  _position != null ? _position.inMilliseconds.toDouble() : 0.0,
                  min: 0.0,
                  max:
                  _duration != null ? _duration.inMilliseconds.toDouble() : 0.0,
                  onChanged: (double value) async {
                    //final Result result = await _audioPlayer
                    //    .seekPosition(Duration(milliseconds: value.toInt()));
                    //if (result == Result.FAIL) {
                    //  print(
                    //      "you tried to call audio conrolling methods on released audio player :(");
                    //} else if (result == Result.ERROR) {
                    //  print("something went wrong in seek :(");
                    //}
                    //_position = Duration(milliseconds: value.toInt());
                  },
                ),
              ),
            ),
          new Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.skip_previous), onPressed: () {},),
              IconButton(icon: Icon(Icons.repeat), onPressed: () {},),
              IconButton(icon: Icon(Icons.play_circle_filled), onPressed: () {},),
              IconButton(icon: Icon(Icons.shuffle), onPressed: () {},),
              IconButton(icon: Icon(Icons.skip_next), onPressed: () {},)
            ],

        ),

    ]),

    )
    );
  }
}
