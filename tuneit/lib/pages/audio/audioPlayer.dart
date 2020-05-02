import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/audioPlayerClass.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';



typedef void OnError(Exception exception);

class PlayerPage extends StatefulWidget {
  List<Audio> audios;
  int indice;
  bool escanciones;

  PlayerPage({Key key, @required this.audios,@required this.indice,@required this.escanciones}):super(key : key);

  @override
  _PlayerPageState createState() => _PlayerPageState (audios,indice,escanciones);
}

class _PlayerPageState extends State<PlayerPage> {

  _PlayerPageState(this.audios,this.indice,this.escanciones);

  //----------------------------------------------------//

  List<Audio> audios;
  int indice;
  bool escanciones;


  //Cargar datos
  Future <void> funcion_auxiliar()async{await rellenarDatos();}
  Future <void> rellenarDatos()async{}

  //----------------------------------------------------//

  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//

  audioPlayerClass _audioPlayerClass;
  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;

  Color _iconRepeatColor = Colors.grey;
  Color _iconShuffleColor = Colors.grey;

  PlayerState _playerState = PlayerState.RELEASED;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _playerIndexSubscription;
  StreamSubscription _playerAudioSessionIdSubscription;
  StreamSubscription _notificationActionCallbackSubscription;

  final List<AudioNotification> audioNotifications = new List<AudioNotification>();

  get _isPlaying => _playerState == PlayerState.PLAYING;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';




  @override
  void initState() {
    super.initState();
    _audioPlayerClass = new audioPlayerClass();
    initAudioPlayer();
  }

  @override
  Future<void> dispose() async {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerIndexSubscription?.cancel();
    _playerAudioSessionIdSubscription?.cancel();
    _notificationActionCallbackSubscription?.cancel();
    super.dispose();

  }

  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    funcion_auxiliar();
    print(_audioPlayerClass.getAudio() == audios);
    print(_audioPlayerClass.getIndice() == indice);
    print(_audioPlayerClass.getPlaying());
    print(_audioPlayerClass.getIndice());
    print(_audioPlayerClass.getIndice());
    print(_audioPlayerClass.getIndice());
    print(indice);
    print(indice);
    print(indice);
    print(indice);
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          )
          ,
          body:  Column(
            children: [

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${audios[indice].devolverTitulo()}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 32
                        ),
                      ),
                    ),
                  ),



              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(audios[indice].devolverArtista(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 32
                    ),
                  ),
                ),
              ),






              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: NetworkImage(audios[indice].devolverImagen()),fit: BoxFit.fill,
                      width: 300,
                      height: 300,
                    ),

                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              iconSize: 64,
                              icon: Icon(Icons.skip_previous),
                              onPressed: () {
                                _audioPlayerClass.previous();
                              }),
                          IconButton(
                            onPressed:(){
                              if(_audioPlayerClass.getRepeat()){
                                _audioPlayerClass.setRepeat(false);
                                setState((){_iconRepeatColor = ColorSets.colorGrey;});
                              }
                              else{
                                _audioPlayerClass.setRepeat(true);
                                setState((){_iconRepeatColor = ColorSets.colorBlue;});
                              }
                              _audioPlayerClass.repeat();
                            },
                            iconSize: 60.0,
                            icon:  Icon(Icons.repeat,
                                color:_iconRepeatColor
                            ),
                          ),
                          IconButton(
                            onPressed:(){
                              if(_audioPlayerClass.getAudio() != audios){
                                _audioPlayerClass.setValoresIniciales(audios,indice);
                                _audioPlayerClass.rellenarUrl();
                                _audioPlayerClass.rellenarNotificaciones();
                                _audioPlayerClass.Changeplay();
                                _audioPlayerClass.setPlaying(true);
                                initAudioPlayer();
                              }
                              else{
                                if(_audioPlayerClass.getIndice() == indice){
                                  if(_audioPlayerClass.getPlaying()){
                                    _audioPlayerClass.setPlaying(false);
                                    _audioPlayerClass.pause();
                                  }
                                  else{
                                    _audioPlayerClass.play();
                                    _audioPlayerClass.setPlaying(true);
                                  }
                                }
                                else{
                                  _audioPlayerClass.setIndice(indice);
                                  _audioPlayerClass.goTo(indice);
                                  _audioPlayerClass.play();
                                  _audioPlayerClass.setPlaying(true);
                                }
                              }
                            },
                            iconSize: 60.0,

                            icon: Icon(_audioPlayerClass.getAudio() == audios
                                      && _audioPlayerClass.getIndice() == indice
                                      && _audioPlayerClass.getPlaying()
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled),
                          ),
                          IconButton(
                              iconSize: 60.0,
                              icon: Icon(Icons.shuffle),
                              color: _iconShuffleColor,
                              onPressed: () {
                                if(!_audioPlayerClass.getShuffle()){
                                  _audioPlayerClass.setShuffle(true);
                                  setState((){_iconShuffleColor = ColorSets.colorBlue;});
                                  _audioPlayerClass.shuffle();
                                }
                                else{
                                  _audioPlayerClass.setShuffle(false);
                                  setState((){_iconShuffleColor = ColorSets.colorGrey;});
                                }
                              }),
                          IconButton(
                              iconSize: 60.0,
                              icon: Icon(Icons.skip_next),
                              onPressed: () {
                                _audioPlayerClass.next();
                              }),

                        ],
                      ),
                    ],
                  ),
                )
                ,
              ),
              SizedBox(
                  width: 400,
                  height: 30,
                  child: SliderTheme(
                    data: SliderThemeData(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                      trackHeight: 3,
                      thumbColor: ColorSets.colorBlue,
                      inactiveTrackColor: ColorSets.colorGrey,
                      activeTrackColor: ColorSets.colorBlue,
                      overlayColor: Colors.transparent,
                    ),
                    child: Slider(
                      min: 0.0,
                      max:
                      _duration != null ? _duration.inMilliseconds.toDouble().abs() : 0.0,
                      value:
                      (_position != null) &&
                      (_position != null && _duration != null && _position.inMilliseconds.toDouble().abs() <
                       _duration.inMilliseconds.toDouble().abs())
                          ? _position.inMilliseconds.toDouble().abs() : 0.0,
                      onChanged: (double value) async {
                        final Result result = await _audioPlayer
                            .seekPosition(Duration(milliseconds: value.toInt()).abs());
                        if (result == Result.FAIL) {
                          print(
                              "you tried to call audio conrolling methods on released audio player :(");
                        } else if (result == Result.ERROR) {
                          print("something went wrong in seek :(");
                        }
                        _position = Duration(milliseconds: value.toInt().abs());
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _position != null
                          ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                          : _duration != null ? _durationText : '',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
            ],
          ),

          //colaReproduccion(List<Song> canciones,int actual)

        ),


      );
    //);
  }

  void initAudioPlayer() {
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
    _notificationActionCallbackSubscription = _audioPlayer
        .onNotificationActionCallback
        .listen((notificationActionName) {
      //do something
    });
    _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen((a) {
      _position = Duration(milliseconds: 0);
      print('Current player is completed');
    });
  }
}










