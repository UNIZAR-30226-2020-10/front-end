import 'dart:convert';

import 'package:encrypt/encrypt.dart' as Encrypter;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/audioPlayerClass.dart';
import 'package:tuneit/classes/components/notificaciones/PushProvider.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/paginaInicial.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/textFields.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  audioPlayerClass _audioPlayerClass;

  bool rememberMe = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Future<User> _futureUser;
  //final _user = User();
  @override
  Widget build(BuildContext context) {
    _audioPlayerClass = new audioPlayerClass();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
          child: Container(
              width: 350,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Image.asset('assets/LogoAppName.png'),
                    SizedBox(height: 30),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                          bottomLeft: const Radius.circular(25.0),
                          bottomRight: const Radius.circular(25.0),
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF823b8e),
                            Color(0xFF5350a7),
                            Color(0xFF1c4c8b),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    textField(_controller1, false, 'Correo electrónico',
                        Icons.mail_outline),
                    textField(_controller2, true, 'Contraseña',
                        Icons.lock_outline),
                    Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            checkColor: ColorSets.colorWhite,
                            activeColor: ColorSets.colorDarkPurple ,
                            onChanged: (bool value) {
                              setState(() {
                                rememberMe = value;
                              });},
                          ),
                          Text("Recordar Usuario")]),
                    SizedBox(height: 100),
                    gradientButton(context, tryLogin, [], 'ENTRAR', 40, 150, 15),
                  ],
                ),
              )
          )
      ),
    );
  }

  void tryLogin () {
    final key = Encrypter.Key.fromUtf8('KarenSparckJonesProyectoSoftware');
    final iv = Encrypter.IV.fromLength(16);
    final encrypter = Encrypter.Encrypter(Encrypter.AES(key, mode: Encrypter.AESMode.ecb));
    final encrypted = encrypter.encrypt(_controller2.text, iv: iv);
    setState(() {
      fetchUser(_controller1.text,  encrypted.base64).then((value) async {
        if (value == 'Success') {
          Globals.isLoggedIn = true;
          Globals.email = _controller1.text;
          List<String> list = await infoUser(_controller1.text);
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
          final prefs = await SharedPreferences.getInstance();
          if(rememberMe) {
            prefs.setString('user', _controller1.text);
            prefs.setString('password', encrypted.base64);
          }
          else{
            prefs.setString('user', '0');
            prefs.setString('password', '0');
          }
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
            List<Audio> audios = null;
            int idLista = parsedJson['Lista'];
            int segundos = parsedJson['Segundo'];
            print("------------");
            print(idLista);
            print("------------");
            if(idLista != null) {
              SongLista canciones = await fetchSonglists((idLista+1).toString());
              List<Audio> audios = canciones.songs;
            }
            Audio cancionNew = null;
            if(lastSong != null) {
              Audio cancionNew = lastSong[0];
            }
            int index = 0;
            bool encontrada = false;
            if(audios != null) {
              for (Audio elemento in audios) {
                if (elemento.devolverArtista() ==
                    cancionNew.devolverArtista() &&
                    elemento.devolverID() == cancionNew.devolverID() &&
                    elemento.devolverTitulo() == cancionNew.devolverTitulo()) {
                  encontrada = true;
                  break;
                }
                else {
                  index++;
                }
              }
            }
            print(index);
            if(lastSong != null && segundos != null){
              print("Aquí meto tremenda cancion al Reproductor");
              if(encontrada) {
                _audioPlayerClass.setValoresIniciales(audios, index);
              }
              else{

                _audioPlayerClass.setValoresIniciales(lastSong, 0);

              }
              _audioPlayerClass.rellenarUrl();
              _audioPlayerClass.rellenarNotificaciones();
              _audioPlayerClass.firstplay(segundos);
              _audioPlayerClass.setPlaying(true);
              _audioPlayerClass.setIniciado(true);
              _audioPlayerClass.setIdLista(idLista.toString());
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
        else if(value == 'Sin confirmar'){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ERROR'),
                  content: Text('El email no ha sido confirmado'),
                  actions: <Widget>[
                    simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
                  ],
                );
              }
          );
        }
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ERROR'),
                content: Text('El email y/o la contraseña introducidos son incorrectos'),
                actions: <Widget>[
                  simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
                ],
              );
            }
          );
        }
      });
    });
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
      rememberMe = false;
    } else {
      // TODO: Forget the user
      rememberMe = true;
    }
  });

}
