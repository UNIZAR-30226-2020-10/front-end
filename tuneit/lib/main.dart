import 'package:flutter/material.dart';
import 'package:tuneit/pages/login.dart';
import 'package:tuneit/pages/main_view.dart';
import 'package:tuneit/pages/notificaciones.dart';
import 'package:tuneit/pages/playlists.dart';
import 'package:tuneit/pages/register.dart';
import 'package:tuneit/pages/show_list.dart';
import 'package:tuneit/pages/player_song.dart';
import 'package:tuneit/classes/push_provider.dart';
import 'package:tuneit/pages/show_podcast.dart';

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

        /*'/player':(context) => PlayerPage(),*/
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TUSA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void initState() {
    super.initState();



    //FUNCION PARA REACCIONAR A LAS NOTIFICACIONES
    Reaccionar_notificacion();


  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/playlists',arguments: {
            'list_title':'Favoritos'
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
