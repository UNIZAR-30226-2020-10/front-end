import 'dart:async';
import 'dart:io';
import 'package:tuneit/pages/player_widget.dart';
import 'package:tuneit/classes/Song.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/constants.dart';


typedef void OnError(Exception exception);


const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';


class PlayerPage extends StatefulWidget {
  List<Song> songs;
  int indice;

  PlayerPage({Key key, @required this.songs,@required this.indice}):super(key : key);

  @override
  _PlayerPageState createState() => _PlayerPageState (songs,indice);
}

class _PlayerPageState extends State<PlayerPage> {
  String url_cancion = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
  String titulo_cancion;
  String artista;
  AudioPlayer advancedPlayer = AudioPlayer();
  String url_imagen;

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
  PlayerMode mode;
  //int indice;
  bool second;

  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';


  //#_PlayerWidgetState(this.url, this.mode,this.indice,this.second);

  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//
  //----------------------------------------------------//






  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    setState(() {
      url=songs[indice].url;
    });

  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

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
    _play(url);



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
      //await _play(url);

      print(url);
      url=songs[indice].url;
    });
    _play(url);
  }


  @override
  Widget build(BuildContext context) {

    funcion_auxiliar();
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: DefaultTabController(
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
                    image: NetworkImage('https://elcultural.com/wp-content/uploads/2020/01/a-34-696x390.jpg'),
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



                              _decrementCounter();


                            }),

                        IconButton(
                          onPressed:(){
                            operacion();
                          },
                          iconSize: 64.0,

                          icon: Icon(_isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled),
                        ),


                        IconButton(
                            iconSize: 64.0,
                            icon: Icon(Icons.skip_next),
                            onPressed: () {




                              _incrementCounter();

                            }),






                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Stack(
                            children: [
                              Slider(
                                onChanged: (v) {
                                  final Position = v * _duration.inMilliseconds;
                                  _audioPlayer
                                      .seek(Duration(milliseconds: Position.round()));
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
                    ),
                  ],
                ),
              ),


                ],



          ),
        ),
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
        }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
          _onComplete();
          setState(() {
            _position = _duration;
          });
        });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });
  }

  Future<int> _play( String enlace) async {
    final playPosition = (_position != null &&
        _duration != null &&
        _position.inMilliseconds > 0 &&
        _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(enlace, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }


  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  Future<void> operacion()async{
    if(_isPaused){
      _play(url);
    }
    else{
      _pause();
    }
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }


}
