import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/audioPlayerClass.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:http/http.dart' as http;

import 'AutoScrollableText.dart';

/*
 * Widget asociado a la barra inferior de la Aplicación
 */
class bottomExpandableAudio extends StatefulWidget {
  bottomExpandableAudio({
    Key key}) : super(key: key);

  @override
  _bottomExpandableAudio createState() => _bottomExpandableAudio();
}

class _bottomExpandableAudio extends State<bottomExpandableAudio> with SingleTickerProviderStateMixin  {

  // Variables Iniciales de la clase
  List<Audio> audios;
  int indice;
  BottomBarController controller = null;
  audioPlayerClass _audioPlayerClass;
  AudioPlayer _audioPlayer;

  // Duracion total y posicion actual de la canción
  Duration _duration;
  Duration _position;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  int contador = 0; // Contador para enviar peticiones

  //Colores para botones de barra expandible
  Color iconRepeatColor = Colors.grey;
  Color iconShuffleColor = Colors.grey;

  // Subscripciones para mostrar el estado de la canción por pantalla
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _playerIndexSubscription;
  StreamSubscription _playerAudioSessionIdSubscription;

  // Diferentes estados del AudioPlayer
  PlayerState _playerState = PlayerState.RELEASED;
  get _isPlaying => _playerState == PlayerState.PLAYING;

  // Funcion que inicia el estado del Widget
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = BottomBarController(vsync: this, dragLength: 200, snap: true);
    _audioPlayerClass = new audioPlayerClass();
    _initAudioPlayer();

  }
  @override
  Widget build(BuildContext context) {
    _initAudioPlayer();
    // Obtenemos el audio e indice actual de la aplicacion
    audios = _audioPlayerClass.getAudio();
    indice = _audioPlayerClass.getIndice();
    // Contador para enviar peticion de la ultima cancion escuchada
    contador= contador + 1;
    if (audios != null && _audioPlayerClass.getEscanciones() && _position!=null && _audioPlayer.playerState == PlayerState.PLAYING) {
      if (contador == 5) {
        contador = 0;
        setState(() {
          sendLastSong(Globals.email, audios[indice].devolverID(),
              _position.inMilliseconds.toString(), _audioPlayerClass.getIdLista()).then((value) async {
            if (!value) {
              print("Ha ocurrido un error en la peticion");
            }
          });
        });
      }
    }
    // Widget de la barra expandible para mostrar por interfaz
    return PreferredSize(
      // Longitud hasta la que se puede expandir el Widget
      preferredSize: Size.fromHeight(controller.dragLength),
      // Controlador y diseño de la barra expandible
      child: BottomExpandableAppBar(
          controller: controller,
          expandedHeight: controller.dragLength,
          horizontalMargin: 0,
          expandedBackColor: Theme
              .of(context)
              .backgroundColor,
          attachSide: Side.Bottom,
          bottomOffset: 20.0,
          expandedBody: GestureDetector(
              onVerticalDragUpdate: controller.onDrag,
              onVerticalDragEnd: controller.onDragEnd,
              child: Card(
                // Interfaz del Reproductor
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Widget que muestra Titulo, Imagen, Género y Artista
                      // de la canción correspondiente
                      ListTile(
                        leading:  audios != null && indice != null ?
                          Image(
                          image: NetworkImage(audios[indice].devolverImagen()),
                            fit: BoxFit.fill,
                            width: 70,
                            height: 70,
                        ) : Icon(Icons.album, size: 50),

                        title: MarqueeWidget(
                          child: Text(
                            audios != null && indice != null ?
                              audios[indice].devolverTitulo() :
                              'Título Deconocido',
                              style: Theme.of(context).textTheme.body1),
                        ),
                        subtitle: MarqueeWidget(
                          child: Text(
                            audios != null && indice != null ?
                              audios[indice].devolverArtista()
                              + " | " + audios[indice].devolverGenero() :
                              'Artista Desconocido | Género Desconocido',
                              style: Theme.of(context).textTheme.body1),
                        ),
                      ),

                      // Barra que muestra el estado de la canción
                      SizedBox(
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 5),
                            trackHeight: 3,
                            thumbColor: Colors.pink,
                            inactiveTrackColor: Colors.grey,
                            activeTrackColor: Colors.pink,
                            overlayColor: Colors.transparent,
                          ),
                          child: Slider(
                            min: 0.0,
                            max:
                            _duration != null ? _duration.inMilliseconds.toDouble().abs() : 0.0,
                            value:
                              (_position != null) &&
                              (_position != null && _duration != null &&
                              _position.inMilliseconds.toDouble().abs() <
                              _duration.inMilliseconds.toDouble().abs()) ?
                                _position.inMilliseconds.toDouble().abs() : 0.0,
                            onChanged: (double value) async {
                              final Result result = await _audioPlayer
                                  .seekPosition(Duration(milliseconds: value.toInt()).abs());
                              if (result == Result.FAIL) {
                                print(
                                  "AudioPlayer esta en modo release");
                              } else if (result == Result.ERROR) {
                                print("Error al cambiar el tiempo de la cancion");
                              }
                              _position = Duration(milliseconds: value.toInt().abs());
                            },
                          ),
                        ),
                      ),

                      // Aquí se muestra el tiempo de la canción
                      new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _position != null
                                ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                                : _duration != null ? _durationText : '',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                      // Sección de botones de la aplicación
                      new Row(mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Botón para ir a la anterior canción
                          IconButton(icon: Icon(Icons.skip_previous),
                            onPressed: () {
                              if (_audioPlayerClass.getAudio() != null) {
                                _audioPlayerClass.previous();
                              }
                            },
                          ),
                          // Botón para repetir la canción
                          IconButton(icon: Icon(Icons.repeat,
                              color: iconRepeatColor),
                            onPressed: () {
                              if (_audioPlayerClass.getAudio() != null) {
                                if (_audioPlayerClass.getRepeat()) {
                                  _audioPlayerClass.setRepeat(false);
                                  setState(() {
                                    iconRepeatColor = ColorSets.colorGrey;
                                  });
                                }
                                else {
                                  _audioPlayerClass.setRepeat(true);
                                  setState(() {
                                    iconRepeatColor = ColorSets.colorBlue;
                                  });
                                }
                                _audioPlayerClass.repeat();
                              }
                            }),
                          // Botón de Play y Pause
                          IconButton(icon: Icon(_audioPlayerClass.getPlaying() ?
                              Icons.pause_circle_filled :
                              Icons.play_circle_filled),
                            onPressed: () {
                              if (_audioPlayerClass.getAudio() != null) {
                                if (!_audioPlayerClass.getPlaying()) {
                                  _audioPlayerClass.play();
                                  _audioPlayerClass.setPlaying(true);
                                }
                                else {
                                  _audioPlayerClass.pause();
                                  _audioPlayerClass.setPlaying(false);
                                }
                              }
                            }),
                          // Botón para mezclar la canción
                          IconButton(icon: Icon(Icons.shuffle),
                            color: iconShuffleColor,
                            onPressed: () {
                              if(_audioPlayerClass.getAudio() != null){
                                if(!_audioPlayerClass.getShuffle()) {
                                  _audioPlayerClass.setShuffle(true);
                                  setState((){iconShuffleColor = ColorSets.colorBlue;});
                                  _audioPlayerClass.shuffle();
                                }
                                else{
                                  _audioPlayerClass.setShuffle(false);
                                  setState((){iconShuffleColor = ColorSets.colorGrey;});
                                }
                              }
                            },),
                          // Botón para avanzar la siguiente canción
                          IconButton(icon: Icon(Icons.skip_next),
                            onPressed: () {
                               if (_audioPlayerClass.getAudio() != null) {
                                 _audioPlayerClass.next();
                               }
                            },
                          ),
                        ],
                      ),
                    ]
                ),
              )
          )
      ),
    );
  }

  // Funcion que inicia el AudioPlayer
  void _initAudioPlayer() {
    _audioPlayer = _audioPlayerClass.getAudioPlayer();
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((playerState) {
          setState(() {
            _playerState = playerState;
            print(_playerState);
          });
        });
    _playerIndexSubscription =
        _audioPlayer.onCurrentAudioIndexChanged.listen((index) {
          setState(() {
            _position = Duration(milliseconds: 0);
            indice = index;
          });
        });
    _playerAudioSessionIdSubscription =
        _audioPlayer.onAudioSessionIdChange.listen((audioSessionId) {
          print("audio Session Id: $audioSessionId");
        });
    _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen((a) {
      _position = Duration(milliseconds: 0);
      print('Current player is completed');
    });
  }

  // Funcion que envia la peticion de ultima canción
  Future<bool> sendLastSong(String email, String cancion, String segundos, String idLista) async {
    if(idLista == "NoLista"){
      idLista = null;
    }
    final http.Response response = await http.post(
      'https://' + baseURL + '/set_last_song',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader:Globals.seguridad,
      },
      body: jsonEncode(<String, String>{
        'email' : email,
        'cancion' : cancion,
        'segundo' : segundos,
        'lista' : idLista
      }),
    );
    if (response.body == 'Success') {
      return true;
    }
    else {
      return false;
    }
  }
}