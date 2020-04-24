import 'package:flutter/material.dart';
import 'package:tuneit/pages/register/login.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/pages/social/notificaciones.dart';
import 'package:tuneit/pages/songs/playlists.dart';
import 'package:tuneit/pages/register/register.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/PushProvider.dart';
import 'package:tuneit/pages/podcast/showPodcast.dart';
import '../widgets/LateralMenu.dart';


class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void initState() {
    super.initState();

    //FUNCION PARA REACCIONAR A LAS NOTIFICACIONES
    reaccionarNotificacion();


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
