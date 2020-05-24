import 'dart:async';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/audioPlayerClass.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/widgets/AutoScrollableText.dart';
import 'package:http/http.dart' as http;


typedef void OnError(Exception exception);

class PlayerPage extends StatefulWidget {
  List<Audio> audios;
  int indice;
  bool escanciones;
  String indetificadorLista;

  PlayerPage({Key key, @required this.audios,@required this.indice,@required this.escanciones, @required this.indetificadorLista}):super(key : key);

  @override
  _PlayerPageState createState() => _PlayerPageState (audios,indice,escanciones, indetificadorLista);
}

class _PlayerPageState extends State<PlayerPage> with SingleTickerProviderStateMixin {

  _PlayerPageState(this.audios,this.indice,this.escanciones, this.indetificadorLista);

  //----------------------------------------------------//

  List<Audio> audios;
  int indice;
  bool escanciones;
  String indetificadorLista;

  List<Audio> audios_show;
  //Cargar datos
  Future <void> funcion_auxiliar()async{await rellenarDatos();}
  Future <void> rellenarDatos()async{
    bool favorita = await _audioPlayerClass.existeCancionFav(audios[indice]);
    setState(() {
      esFavorita = favorita;
    });
  }

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

  BottomBarController audio_controller = null;

  Color _iconRepeatColor = Colors.grey;
  Color _iconShuffleColor = Colors.grey;
  IconData _iconFavorite = Icons.favorite;

  PlayerState _playerState = PlayerState.RELEASED;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _playerIndexSubscription;
  StreamSubscription _playerAudioSessionIdSubscription;
  StreamSubscription _notificationActionCallbackSubscription;

  bool esFavorita = false;

  int contador = 0;
  final List<AudioNotification> audioNotifications = new List<AudioNotification>();

  get _isPlaying => _playerState == PlayerState.PLAYING;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';




  @override
  void initState() {
    super.initState();
    _audioPlayerClass = new audioPlayerClass();
    initAudioPlayer();
    audio_controller = BottomBarController(vsync: this, dragLength: 533, snap: true);
    if(_audioPlayerClass.getShuffle()){
      audios_show =  _audioPlayerClass.getAudioShuffle();
    }
    else {
      if (_audioPlayerClass.getAudio() != null) {
        audios_show = _audioPlayerClass.getAudio();
      }
      else{
        audios_show = audios;
      }
    }
    funcion_auxiliar();
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
    if(_position != null && _audioPlayerClass.getEscanciones()) {
      contador= contador + 1;
      if (contador == 5) {
        contador = 0;
        setState(() {
          sendLastSong(Globals.email, audios[indice].devolverID(),
              _position.inMilliseconds.toString(),indetificadorLista).then((value) async {
            if (!value) {
              print("Ha ocurrido un error en la peticion");
            }
          });
        });
      }
    }
    return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              escanciones ?Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: IconButton(
                    iconSize: 20.0,
                    icon: Icon(esFavorita
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: (){
                      if(esFavorita){
                        eliminarCancionDeLista(Globals.idFavorite,audios[indice].devolverID().toString());
                        setState(() {esFavorita = false;});
                      }
                      else{
                        agregarCancion(Globals.idFavorite,audios[indice].devolverID().toString());
                        setState(() {esFavorita = true;});
                      }
                    }
                ),
              ):Container(width: 0,height: 0,)
            ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          )
          ,
          body:
                Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child:SizedBox(
                      child: MarqueeWidget(
                              child: Text('${audios[indice].devolverTitulo()} \n'+
                                          audios[indice].devolverArtista() + ' | ' + audios[indice].devolverGenero(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 32
                                ),
                              ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child:SizedBox(
                    child: Image(
                      image: NetworkImage(audios[indice].devolverImagen()),fit: BoxFit.fill,
                      width: 200,
                      height: 200,
                    ),

                ),
              ),
                    Flexible(child:SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                            child:
                            Transform.scale(
                              scale: 1,
                              child:
                              IconButton(
                                iconSize: 50.0,
                                icon: Icon(Icons.skip_previous),
                                onPressed: () {
                                  _audioPlayerClass.previous();
                                  esFavorita = null;
                                }
                              )
                            )),
                              Flexible(
                              child:
                            Transform.scale(
                              scale: 1,
                              child:
                              IconButton(
                                iconSize: 50.0,
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
                                icon:  Icon(Icons.repeat,
                                  color:_iconRepeatColor
                                ),
                              )
                            )),
    Flexible(
    child:
                        Transform.scale(
                          scale: 1,
                          child:
                          IconButton(
                            iconSize: 50.0,
                            onPressed:(){
                              if(_audioPlayerClass.getAudio() != audios){
                                _audioPlayerClass.setValoresIniciales(audios,indice);
                                _audioPlayerClass.rellenarUrl();
                                _audioPlayerClass.rellenarNotificaciones();
                                _audioPlayerClass.Changeplay();
                                _audioPlayerClass.setPlaying(true);
                                audios_show = _audioPlayerClass.getAudio();
                                initAudioPlayer();
                                _audioPlayerClass.setIniciado(true);
                                _audioPlayerClass.setEscanciones(escanciones);
                                _audioPlayerClass.setIdLista(indetificadorLista);
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
                                  initAudioPlayer();
                                }
                              }
                            },

                            icon: Icon(_audioPlayerClass.getAudio() == audios
                                      && _audioPlayerClass.getIndice() == indice
                                      && _audioPlayerClass.getPlaying()
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled),
                          ))),
    Flexible(
    child:
                        Transform.scale(
                          scale: 1,
                          child:
                          IconButton(
                              iconSize: 50.0,
                              icon: Icon(Icons.shuffle),
                              color: _iconShuffleColor,
                              onPressed: () {
                                if(!_audioPlayerClass.getShuffle()){
                                  _audioPlayerClass.setShuffle(true);
                                  setState((){_iconShuffleColor = ColorSets.colorBlue;});
                                  _audioPlayerClass.shuffle();
                                  audios_show =  _audioPlayerClass.getAudioShuffle();
                                }
                                else{
                                  _audioPlayerClass.setShuffle(false);
                                  setState((){_iconShuffleColor = ColorSets.colorGrey;});
                                  if (_audioPlayerClass.getAudio() != null) {
                                    audios_show = _audioPlayerClass.getAudio();
                                  }
                                  else{
                                    audios_show = audios;
                                  }
                                }
                              }))),
                            Transform.scale(
                                scale: 1,
                                child:
                          IconButton(
                              iconSize: 50.0,
                              icon: Icon(Icons.skip_next),
                              onPressed: () {
                                _audioPlayerClass.next();
                                esFavorita = null;
                              })),
                        ],
                      ),
                      )),
                Flexible(
                child:
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
                )),
                Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _position != null
                          ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                          : _duration != null ? _durationText : '',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                )),
            ],
          ),

          bottomNavigationBar: PreferredSize(
            preferredSize: Size.fromHeight(audio_controller.dragLength),
            child: BottomExpandableAppBar(
              controller: audio_controller,
              expandedHeight: audio_controller.dragLength,
              horizontalMargin: 0,
              expandedBackColor: Theme.of(context).backgroundColor,
              attachSide: Side.Bottom,
              bottomOffset: 20.0,
              // Your bottom sheet code here
              expandedBody: GestureDetector(
                onVerticalDragUpdate: audio_controller.onDrag,
                onVerticalDragEnd: audio_controller.onDragEnd,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "",
                        textAlign: TextAlign.center,
                      ),
                   Expanded(
                    child: ReorderableListView(
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.vertical,
                      onReorder: _onReorder,
                      children: List.generate(
                        audios_show.length, (index) {
                          return
                            Card(
                              key: Key('$index'),
                              child: new ListTile(
                                leading: GFAvatar(

                                  backgroundImage: NetworkImage(audios_show[index].devolverImagen()),
                                  backgroundColor: Colors.transparent,
                                  shape: GFAvatarShape.standard,

                                ),
                                title: Text(audios_show[index].devolverTitulo()),
                                subtitle: Text(audios_show[index].devolverArtista() + ' | ' + audios_show[index].devolverGenero()),
                              ),
                            );
                        },
                      ),
                    ),
                  )],
                ),
              )
              ),
              ),
            ),
          );
  }

  void initAudioPlayer() {
    _audioPlayer = _audioPlayerClass.getAudioPlayer();
    if(audios == _audioPlayerClass.getAudio() && indice == _audioPlayerClass.getIndice()) {
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
      }
      );
    }
  }
  void _onReorder(int oldIndex, int newIndex) async{
    bool exito =await reposicionarCancion(indetificadorLista,oldIndex.toString(),newIndex.toString());
    if(exito){
      setState(
            () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Song item = audios.removeAt(oldIndex);
          audios.insert(newIndex, item);
        },
      );
    }
  }

  Future<bool> sendLastSong(String email, String cancion, String segundos, String idLista) async {
    var queryParameters = {
      'email' : email,
      'cancion' : cancion,
      'segundo' : segundos,
      'lista' : idLista
    };
    var uri = Uri.http(baseURL, '/set_last_song', queryParameters);
    final http.Response response = await http.get(uri);
    if(response.body == 'Success'){
      return true;
    }
    else{
      return false;
    }
  }

}










