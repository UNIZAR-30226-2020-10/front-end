import 'package:flutter/material.dart';
import 'package:tuneit/pages/login.dart';
import 'package:tuneit/pages/mainView.dart';
import 'package:tuneit/pages/notificaciones.dart';
import 'package:tuneit/pages/playlists.dart';
import 'package:tuneit/pages/register.dart';
import 'package:tuneit/pages/showList.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/PushProvider.dart';
import 'package:tuneit/pages/showPodcast.dart';
import 'classes/components/LateralMenu.dart';

void main() => runApp(MyApp());

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

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
        //'/playlists':(context) => PlayLists(),
        '/notificaciones':(context) => Notificaciones(),
        '/login':(context) => Login(),
        '/register':(context) => Register(),
        '/list_podcast':(context) => ShowPodcast(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        fontFamily: 'RobotoMono',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 25.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'RobotoMono'),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  InitialPlaylist cargarDatos = new InitialPlaylist();

  void initState() {
    super.initState();

    //FUNCION PARA REACCIONAR A LAS NOTIFICACIONES
    reaccionarNotificacion();
    leerDatos();

  }

  void leerDatos() async {
    await cargarDatos.fetchNewList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAGINA PRINCIPAL'),
        centerTitle: true,
      ),
      drawer: LateralMenu(),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),

          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Novedades',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Center(
              child:
              StreamBuilder(
                  stream: cargarDatos.seleccionar_listas,
                  builder: (context,snapshot){
                    if(!snapshot.hasData){
                      return Column(
                        children: <Widget>[
                          Image(image: AssetImage('assets/LogoApp.png'),
                            fit: BoxFit.fill,),
                          Text("Buscando en la base de datos las mejores canciones...")
                        ],
                      );
                    }
                    else{
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.listas.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  listBox (context, index,snapshot.data.listas);
                            }
                        ),
                      );
                    }
                  }
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Generos',
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget templateList (String image, String playlistName) {
    return Column(
      children: <Widget>[
        new CircleAvatar(
              maxRadius: 60,
              backgroundColor: Colors.brown.shade800,
              backgroundImage: NetworkImage(image),
        ),
        Text(playlistName),
      ],
    );
  }

  Widget listBox (BuildContext context, index, list) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ShowList(indetificadorLista: list[index].id.toString(), list_title: list[index].name),
          ));
      },
      child: templateList(
           (list[index].image != null? list[index].image : "https://i.blogs.es/2596e6/sonic/450_1000.jpg"),
          list[index].name
      ),
    );
  }

  Widget listCategories (BuildContext context, index, list) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowList(indetificadorLista: list[index].id.toString(), list_title: list[index].name),
        ));
      },
      child: templateList(
          (list[index].image != null? list[index].image : "https://i.blogs.es/2596e6/sonic/450_1000.jpg"),
          list[index].name
      ),
    );
  }

  Future <void> almacenarMensaje() {

  }

  void reaccionarNotificacion() async {

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
