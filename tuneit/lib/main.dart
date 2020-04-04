import 'package:flutter/material.dart';
import 'package:tuneit/pages/login.dart';
import 'package:tuneit/pages/main_view.dart';
import 'package:tuneit/pages/notificaciones.dart';
import 'package:tuneit/pages/playlists.dart';
import 'package:tuneit/pages/register.dart';
import 'package:tuneit/pages/show_list.dart';
import 'package:tuneit/classes//Playlist.dart';
import 'package:tuneit/classes/push_provider.dart';
import 'package:tuneit/pages/show_podcast.dart';
import 'classes/LateralMenu.dart';

void main() => runApp(MyApp());
final GlobalKey<NavigatorState> navigatorKey =
new GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/mainview',
      navigatorKey: navigatorKey,
      routes:{
        '/mainview':(context) => MainView(),
        '/list':(context) => ShowList(),
        '/playlists':(context) => PlayLists(),
        '/notificaciones':(context) => Notificaciones(),
        '/login':(context) => Login(),
        '/register':(context) => Register(),
        '/list_podcast':(context) => ShowPodcast(),


      },
      theme: ThemeData(

        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'TuneIT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  InitialPlaylist cargar_datos = new InitialPlaylist();

  void initState() {
    super.initState();



    //FUNCION PARA REACCIONAR A LAS NOTIFICACIONES
    Reaccionar_notificacion();
    leer_datos();



  }

  void leer_datos()async{
  await cargar_datos.fetchNewList();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(


        title: Text(widget.title),
      ),
      drawer: MenuLateral(),
      body:Column(

        children: <Widget>[

          Center(
            child: Text('Novedades'),
          ),
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//

          Center(
            child:
            StreamBuilder(
                stream: cargar_datos.buscar_listas_1,
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Column(
                      children: <Widget>[
                        Image(image: AssetImage('assets/LogoApp.png'),
                            fit: BoxFit.fill,),
                        Text("Buscando en nuestra base de datos las mejores canciones...")


                      ],
                    );
                  }
                  else{
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  list_box (context, index,snapshot.data);


                          }
                      ),
                    );
                  }
                }
            ),

          ),

          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//
          //----------------------------------//

          Center(
            child: Text('Generos musicales'),
          ),

          /*Center(
            child:
            StreamBuilder(
                stream: cargar_datos.buscar_listas_1,
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Column(
                      children: <Widget>[
                        Image(image: AssetImage('assets/LogoApp.png'),
                          fit: BoxFit.fill,),
                        Text("Buscando en nuestra base de datos las mejores canciones...")


                      ],
                    );
                  }
                  else{
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  list_categories (context, index,snapshot.data);


                          }
                      ),
                    );
                  }
                }
            ),

          ),*/



        ],



        ),

    );


  }


  Widget template_list (String image, String playlist_name) {
    return Column(
      children: <Widget>[
        new
            CircleAvatar(
              maxRadius: 60,
              backgroundColor: Colors.brown.shade800,
              backgroundImage: NetworkImage(image),
              ),

        Text(playlist_name),
      ],
    );

  }

  Widget list_box (BuildContext context, index, list) {


    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowList(indetificadorLista: list[index].id.toString(), list_title: list[index].name),
          ));
      },
      child: template_list(
           (list[index].image != null? list[index].image : "https://i.blogs.es/2596e6/sonic/450_1000.jpg"),
          list[index].name
      ),
    );
  }

  Widget list_categories (BuildContext context, index, list) {


    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowList(indetificadorLista: list[index].id.toString(), list_title: list[index].name),
        ));
      },
      child: template_list(
          (list[index].image != null? list[index].image : "https://i.blogs.es/2596e6/sonic/450_1000.jpg"),
          list[index].name
      ),
    );
  }





  /**************************************************/
  /**************************************************/
  /**************************************************/

  /**************************************************/
  /**************************************************/
  /**************************************************/
  /**************************************************/
  /**************************************************/

  /**************************************************/
  /**************************************************/






  Future <void> almacenarMensaje(){

  }


  void Reaccionar_notificacion() async{
    final pushProvider = new PushProvider();


    pushProvider.initNotifications();

    pushProvider.mensaje.listen((argumento) async{

      String data = argumento.title;
      String cuerpo = argumento.body;

      //AQUI FALTARIA GUARDAR EL MENSAJE EN NUESTRA BASE DE DATOS
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

      await almacenarMensaje();

      navigatorKey.currentState.pushNamed('/notificaciones', arguments:{
        'title': '${data}',
        'body': '${cuerpo}',
      } );

      /*Navigator.pushNamed(context, '/notificaciones' ,arguments: {
        'title': '${data}',
        'body': '${cuerpo}',
      });*/
      //navigatorKey.currentState.pushNamed('/notificaciones',arguments: data);
    });


  }


}
