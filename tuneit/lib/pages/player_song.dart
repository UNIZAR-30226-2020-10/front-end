import 'dart:async';
import 'package:tuneit/classes/Song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:flutter/material.dart';

const imageUrl1 = "https://www.bensound.com/bensound-img/buddy.jpg";
const imageUrl2 = "https://www.bensound.com/bensound-img/epic.jpg";
const imageUrl3 = "https://www.bensound.com/bensound-img/onceagain.jpg";



typedef void OnError(Exception exception);
//enum PlayerState { stopped, playing, paused }



class PlayerPage extends StatefulWidget {
  List<Song> songs;
  int indice;

  PlayerPage({Key key, @required this.songs,@required this.indice}):super(key : key);

  @override
  _PlayerPageState createState() => _PlayerPageState (songs,indice);
}

class _PlayerPageState extends State<PlayerPage> {

  _PlayerPageState(this.songs,this.indice);

  //----------------------------------------------------//

  List<Song> songs;
  int indice;


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

  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;
  bool _playAll = false;

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

    setState((){
      url=songs[indice].url;
    });
    _initAudioPlayer();
  }

  @override
  void dispose() {
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


  //#_PlayerWidgetState(this.url, this.mode,this.indice,this.second);

  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//







  Future<void> _incrementCounter() async {
    await _stop();
    setState((){
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      indice++;
      if(indice>songs.length){
        indice=0;
      }

      url=songs[indice].url;
    });
    _play();



  }

  void _decrementCounter() async{

    await _stop();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      indice--;
      if(indice<0){
        indice=0;
      }
      print(url);
      url=songs[indice].url;
    });
    _play();
  }


  @override
  Widget build(BuildContext context) {
    _rellenarUrl();
    _rellenarNotificaciones();
    funcion_auxiliar();
    return /*MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: */DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar()
          ,
          body:  Column(
            children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${songs[indice].title}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 32
                      ),
                    ),
                  ),



              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${songs[indice].artist}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 32
                  ),
                ),
              ),






              Padding(
                padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: NetworkImage('${songs[indice].album}'),
            ),

              ),
              Padding(
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
                            if(!_isPlaying) {
                              _play();
                            }
                            else{
                              _pause();
                            }
                          },
                          iconSize: 64.0,

                          icon: Icon(_isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled),
                        ),

                        IconButton(
                          onPressed:(){
                            _stop();
                          },
                          iconSize: 64.0,
                          icon:  Icon(Icons.stop),
                        ),
                        IconButton(
                            iconSize: 64.0,
                            icon: Icon(Icons.skip_next),
                            onPressed: () {
                              _next();
                            }),
                      ],
                    ),
                  // tiempo(),
                  ],
                ),
              ),


                ],



          ),
        ),
      );
    //);
  }

 /* Widget tiempo(){

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Slider(
                onChanged: (v) {
                  print("aaaaaaaaaaaaaa");
                  final Position = v * _duration.inMilliseconds;
                  _audioPlayer
                      .seek(Duration(milliseconds: Position.round()));
                    setState(() {
                      if(_duration.inMilliseconds==_position.inMilliseconds){
                          print("WWWWWWWWWWWWWWWWWWWWWWWWW");
                          _incrementCounter();
                      }

                    });
                },
                value: (_position != null &&
                    _duration != null &&
                    _position.inMilliseconds > 0 &&
                    _position.inMilliseconds < _duration.inMilliseconds)
                    ? _position.inMilliseconds / _duration.inMilliseconds
                    : 0.0,
              ),
            ],
          ),
        ),
        Text(

          _position != null
              ? '${_positionText ?? ''} / ${_durationText ?? ''}'
              : _duration != null ? _durationText : '',
          style: TextStyle(fontSize: 24.0),
        ),
      ],

    );

  }*/

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

  Future<void> _play() async {
    if (url != null) {
      if(!_playAll) {
        final Result result = await _audioPlayer.playAll(urls,index: indice,
          repeatMode: false,
          respectAudioFocus: true,
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

  Future<void> _next() async {
    if(indice == songs.length - 1) {
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

  Future<void> _previous() async {
    if(indice == 0){
      indice = songs.length - 1;
    }
    else{
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

  void _rellenarUrl() {
    for(int i = 0; i < songs.length; i++){
      urls.add(songs[i].url);
    }
  }

  void _rellenarNotificaciones(){
    for(int i = 0; i < songs.length; i++){
      audioNotifications.add( AudioNotification(
          smallIconFileName: "ic_launcher",
          title:songs[i].title + "( " + songs[i].artist + " )",
          subTitle: songs[i].artist,
          largeIconUrl: songs[i].album,
          isLocal: false,
          notificationDefaultActions: NotificationDefaultActions.ALL));
    }
  }
}



