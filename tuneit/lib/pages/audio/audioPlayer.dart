import 'dart:async';
import 'dart:convert';
import 'package:tuneit/classes/components/Song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuneit/classes/components/Audio.dart';


import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';

const imageUrl1 = "https://www.bensound.com/bensound-img/buddy.jpg";
const imageUrl2 = "https://www.bensound.com/bensound-img/epic.jpg";
const imageUrl3 = "https://www.bensound.com/bensound-img/onceagain.jpg";



typedef void OnError(Exception exception);
//enum PlayerState { stopped, playing, paused }



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
  int indiceShuffle;
  bool escanciones;


  //Cargar datos

  Future <void> funcion_auxiliar()async{
   await rellenarDatos();

  }

  Future <void> rellenarDatos()async{



  }

  //----------------------------------------------------//

  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  String url;
  List<String> urls = new List<String>();

  List<int> audiosShuffle = new List<int>();
  int primera = 0;

  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;
  bool _playAll = false;
  bool _repeatMode = false;
  bool _shuffleMode = false;

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

  //CON ESTO SE MUESTRA CÓMO VA LA CANCIÓN

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';


  final _playerStreamController = StreamController<AudioPlayer>.broadcast();
  Stream<AudioPlayer> get devolverPlayer => _playerStreamController.stream;

  @override
  void initState() {
    super.initState();

    setState((){
      url=audios[indice].devolverSonido();
    });
    _initAudioPlayer();
    _playerStreamController.sink.add(_audioPlayer);
  }

  @override
  Future<void> dispose() async {
    _audioPlayer.dispose();
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
    _rellenarUrl();
    _rellenarNotificaciones();
    funcion_auxiliar();
    print('=== Slider value: ${_position?.inMilliseconds?.toDouble() ?? 0.0} ===');
    print('=== Duration value: ${_duration?.inMilliseconds?.toDouble() ?? 0.0} ===');
    return /*MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: */DefaultTabController(
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
                    child: imagen_por_defecto(audios[indice].devolverImagen()),

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
                                _previous();
                              }),
                          IconButton(
                            onPressed:(){
                              if(_repeatMode){
                                _repeatMode = false;
                                setState((){_iconRepeatColor = ColorSets.colorGrey;});
                              }
                              else{
                                _repeatMode = true;
                                setState((){_iconRepeatColor = ColorSets.colorBlue;});
                              }
                              _repeat();
                            },
                            iconSize: 60.0,
                            icon:  Icon(Icons.repeat,
                                color:_iconRepeatColor
                            ),
                          ),
                          IconButton(
                            onPressed:(){
                              if(!_isPlaying) {
                                _play(urls);
                              }
                              else{
                                _pause();
                              }
                            },
                            iconSize: 60.0,

                            icon: Icon(_isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled),
                          ),
                          IconButton(
                              iconSize: 60.0,
                              icon: Icon(Icons.shuffle),
                              color: _iconShuffleColor,
                              onPressed: () {
                                if(!_shuffleMode){
                                  _shuffleMode = true;
                                  setState((){_iconShuffleColor = ColorSets.colorBlue;});
                                  _shuffle();
                                }
                                else{
                                  _shuffleMode = false;
                                  setState((){_iconShuffleColor = ColorSets.colorGrey;});
                                }
                              }),
                          IconButton(
                              iconSize: 60.0,
                              icon: Icon(Icons.skip_next),
                              onPressed: () {
                                _next();
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

        ),
      );
    //);
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
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

  Future<void> _play(List<String> urls) async {
    if (urls != null) {
      if(!_playAll) {
        final Result result = await _audioPlayer.playAll(urls,index: indice,
          repeatMode: false,
          respectAudioFocus: false,
          playerMode: PlayerMode.FOREGROUND,
          audioNotifications: audioNotifications,
        );
        _playAll = true;
        if (result == Result.ERROR) {
          print("something went wrong in play method :(");
        }

      }
      else{
        final Result result = await _audioPlayer.resume();
        if (result == Result.ERROR) {
          print("something went wrong in play method :(");
        }
      }
  }

    }

  Future<void> _pause() async {
    final Result result = await _audioPlayer.pause();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in pause :(");
    }
  }

  Future<void> _stop() async {
    indice = 0;
    final Result result = await _audioPlayer.stop();
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in stop :(");
    }
  }

  Future<void> _repeat() async {
    final Result result = await _audioPlayer.setRepeatMode(_repeatMode);
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in stop :(");
    }
  }

  Future<void> _next() async {
    if(!_shuffleMode) {
      if (indice == audios.length - 1) {
        indice = 0;
      }
      else {
        indice++;
      }
      final Result result = await _audioPlayer.seekIndex(indice);
      if (result == Result.FAIL) {
        print(
            "you tried to call audio conrolling methods on released audio player :(");
      } else if (result == Result.ERROR) {
        print("something went wrong in next :(");
      }
    }
    else{
      if(indiceShuffle == audiosShuffle.length - 1){
        indice = audiosShuffle.elementAt(0);
        indiceShuffle = 0;
      }
      else{
        indiceShuffle++;
        indice = audiosShuffle.elementAt(indiceShuffle);
      }
      final Result result = await _audioPlayer.seekIndex(indice);
      if (result == Result.FAIL) {
        print(
            "you tried to call audio conrolling methods on released audio player :(");
      } else if (result == Result.ERROR) {
        print("something went wrong in previous :(");
      }
    }
  }

  Future<void> _previous() async {
    if(!_shuffleMode) {
      if (indice == 0) {
        indice = audios.length - 1;
      }
      else {
        indice--;
      }
      final Result result = await _audioPlayer.seekIndex(indice);
      if (result == Result.FAIL) {
        print(
            "you tried to call audio conrolling methods on released audio player :(");
      } else if (result == Result.ERROR) {
        print("something went wrong in previous :(");
      }
    }
    else{
     if(indiceShuffle == 0){
        indice = audiosShuffle.elementAt(audiosShuffle.length - 1);
        indiceShuffle = audiosShuffle.length - 1;
      }
      else{
        indiceShuffle--;
        indice =audiosShuffle.elementAt(indiceShuffle);
      }
      final Result result = await _audioPlayer.seekIndex(indice);
      if (result == Result.FAIL) {
        print(
            "you tried to call audio conrolling methods on released audio player :(");
      } else if (result == Result.ERROR) {
        print("something went wrong in previous :(");
      }
    }
  }

  void _rellenarUrl() {
    for(int i = 0; i < audios.length; i++){
      urls.add(audios[i].devolverSonido());
    }
  }

  void _rellenarNotificaciones(){
    for(int i = 0; i < audios.length; i++){
      audioNotifications.add( AudioNotification(
          smallIconFileName: "ic_launcher",
          title:audios[i].devolverTitulo(),
          subTitle: audios[i].devolverArtista(),
          largeIconUrl: audios[i].devolverImagen(),
          isLocal: false,
          notificationDefaultActions: NotificationDefaultActions.ALL));
    }
  }

  Widget imagen_por_defecto(String imagen){
    if (imagen== null){
      return  new Image(image: AssetImage('assets/LogoApp.png'),
                        fit: BoxFit.fill,
        width: 300,
        height: 300);
    }
    else{
     return new Image(
          image: NetworkImage(audios[indice].devolverImagen()),fit: BoxFit.fill,
       width: 300,
       height: 300,
     );
      
    }
    
  }
  Future<void> _shuffle() async {

    for(int i = 0; i < audios.length ; i++){
      audiosShuffle.add(i);
      print(i);
    }
    audiosShuffle.shuffle();
    primera = await _audioPlayer.getCurrentPlayingAudioIndex();
    int index_primera_shuffle = audiosShuffle.indexOf(primera);
    int valor_index_0 = audiosShuffle.elementAt(0);
    audiosShuffle[index_primera_shuffle] = valor_index_0;
    audiosShuffle[0] = primera;
    indiceShuffle = 0;
  }

}








