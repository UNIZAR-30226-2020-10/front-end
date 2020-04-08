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
