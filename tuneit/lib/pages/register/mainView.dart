import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/audioPlayerClass.dart';
import 'package:tuneit/classes/components/notificaciones/PushProvider.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/login.dart';
import 'package:tuneit/pages/register/register.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../paginaInicial.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<String> datos = new List<String>();
  audioPlayerClass _audioPlayerClass;

  @override
  void initState() {
    // TODO: implement initState
    var pus1=PushProvider();
    pus1.initNotifications();
    super.initState();
    _audioPlayerClass = new audioPlayerClass();
    obtenerDatos();
  }
  void obtenerDatos() async{
    datos = await obtenerDatosConjunto();
    setState(() {
      fetchUser(datos[0],  datos[1]).then((value) async {
        if (value == 'Success') {
          Globals.isLoggedIn = true;
          Globals.email = datos[0];
          List<String> list = await infoUser(datos[0]);
          Globals.name = list[0];
          Globals.password = list[1];
          Globals.date = list[2];
          Globals.country = list[3];
          Globals.image = list[4];

          List<Playlist> listaPlay = await fetchPlaylists(Globals.email);
          Globals.idFavorite = listaPlay[0].id.toString();
          //------
          //Esto habra que cambiarlo por lo que backend
          //-----
          var pus1=PushProvider();
          Globals.mi_token=pus1.devolverToken();
          setToken(
              Globals.email,Globals.mi_token
          );


          final http.Response response = await http.post(
            'https://' + baseURL + '/get_last_song',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'email' : Globals.email
            }),
          );
          List<Audio> lastSong = new List<Audio>();

          if (response.statusCode == 200) {
            Map<String, dynamic> parsedJson = json.decode(response.body);


            if(parsedJson['Cancion'] != null ) {
              lastSong = (parsedJson['Cancion'] as List)
                  .map((data) => new Song.fromJson(data))
                  .toList();
            }
            else{
              lastSong = null;
            }


            int segundos = parsedJson['Segundo'];
            if(lastSong != null && segundos != null){
              print("Aquí meto tremenda cancion al Reproductor");
              _audioPlayerClass.setValoresIniciales(lastSong, 0);
              _audioPlayerClass.rellenarUrl();
              _audioPlayerClass.rellenarNotificaciones();
              _audioPlayerClass.firstplay(segundos);
              _audioPlayerClass.setPlaying(true);
              _audioPlayerClass.setIniciado(true);
            }
          } else {
            lastSong = null;
            print(response.body + ': Failed to load last listened song');
          }


          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
      });
    });
  }

  Future<List<String>> obtenerDatosConjunto() async{
    final prefs = await SharedPreferences.getInstance();
    List<String> data = new List<String>();
    data.add(prefs.getString('user') ?? '0');
    data.add(prefs.getString('password') ?? '0');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
              children: <Widget>[
                Flexible(
                  flex: 6,
                  child: new Image(image: new AssetImage('assets/LogoApp.png'),),
                ),
                Container(
                  color: Colors.transparent,
                  height: 30,
                ),
                Flexible(
                    flex: 2,
                    child: gradientButton(context, toLogin, [], 'INICIAR SESIÓN', 50, 230, 20)
                ),
                Container(
                  color: Colors.transparent,
                  height: 30,
                ),
                Flexible(
                    flex: 2,
                    child: gradientButton(context, toRegister, [], 'REGISTRARSE', 50, 230, 20)
                )
              ]
          )
      ),
    );
  }

  void toLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void toRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }
}