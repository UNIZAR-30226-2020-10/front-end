import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'Audio.dart';
import 'package:http/http.dart' as http;

// Clase Singleton de la aplicacion
class audioPlayerClass {

  // Implementacion Singleton
  static final audioPlayerClass _audioPlayerClass = audioPlayerClass._internal();
  factory audioPlayerClass() => _audioPlayerClass; // Llamada para recibir la clase
  audioPlayerClass._internal(); // Constructor Privado

  // Variables iniciales
  List<Audio> audios;
  int indice;

  // Variables del sistema
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _playAll = false;
  bool _repeatMode = false;
  bool _shuffleMode = false;
  bool playing = false;
  List<String> urls = new List<String>();
  bool escanciones = true;
  bool iniciado = false;

  // Variables Shuffle
  List<int> audiosShuffle = new List<int>();
  List<Audio> audiosShuffleShow = new List<Audio>();
  int indiceShuffle;
  int primera = 0;

  // Valor inicial de idLista
  String idLista = "1";

  // Variables Notificaciones
  List<AudioNotification> audioNotifications = new List<AudioNotification>();

  // Funciones Set y Get de parametros
  void setValoresIniciales(List<Audio> audios, int indice) {
    this.audios = audios;
    this.indice = indice;
  }
  void setPlay (bool playAll) => _playAll = playAll;
  void setRepeat (bool repeatMode) => _repeatMode = repeatMode;
  void setShuffle (bool shuffleMode) => _shuffleMode = shuffleMode;
  void setIndice(int el_indice) => indice = el_indice;
  void setPlaying(bool playing) => this.playing = playing;
  void setIniciado(bool iniciado) => this.iniciado = iniciado;
  void setEscanciones(bool escanciones) => this.escanciones = escanciones;
  void setIdLista(String idLista) => this.idLista = idLista;
  AudioPlayer getAudioPlayer() {
    return _audioPlayer;
  }
  bool getPlay() {
    return _playAll;
  }
  bool getRepeat() {
    return _repeatMode;
  }
  bool getShuffle() {
    return _shuffleMode;
  }
  int getIndice(){
    return indice;
  }
  List getAudio(){
    return audios;
  }
  List getAudioShuffle(){
    return audiosShuffleShow;
  }
  bool getPlaying(){
    return playing;
  }
  bool getIniciado(){
    return iniciado;
  }
  bool getEscanciones(){
    return escanciones;
  }

  String getIdLista(){
    return idLista;
  }

  // Dispose y create del AudioPlayer
  void dispose(){
    _audioPlayer.dispose();
  }
  void create(){
    _audioPlayer = new AudioPlayer();
  }

  // Funcion para ir de una canción a otra
  Future<void> goTo(int indice_a_ir) async {
    final Result result = await _audioPlayer.seekIndex(indice_a_ir);
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in pause :(");
    }
  }

  // Funcion para cambiar de una lista de reproduccion a otra
  Future<void> changePlay(int segundos) async {
    if (audios != null) {
        _audioPlayer.dispose();
        _audioPlayer = new AudioPlayer();
        final Result result = await _audioPlayer.playAll(urls,index: indice,
          repeatMode: false,
          respectAudioFocus: false,
          playerMode: PlayerMode.FOREGROUND,
          audioNotifications: audioNotifications,
          position: Duration(milliseconds: segundos)
        );
        _playAll = true;
        if (result == Result.ERROR) {
          print("something went wrong in play method :(");
        }
    }

  }

  // Play del AudioPlayer
  Future<void> play() async {
    if (audios != null) {
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

  // Pause del AudioPlayer
  Future<void> pause() async {
    if(audios != null) {
      final Result result = await _audioPlayer.pause();
      if (result == Result.FAIL) {
        print(
            "you tried to call audio conrolling methods on released audio player :(");
      } else if (result == Result.ERROR) {
        print("something went wrong in pause :(");
      }
    }
  }

  // Stop del AudioPlayer
  Future<void> stop() async {
    if(audios != null) {
      indice = 0;
      final Result result = await _audioPlayer.stop();
      if (result == Result.FAIL) {
        print(
            "you tried to call audio conrolling methods on released audio player :(");
      } else if (result == Result.ERROR) {
        print("something went wrong in stop :(");
      }
    }
  }

  // Funcion para permitir repetir listas de reproduccion
  Future<void> repeat() async {
    if (audios != null) {
      final Result result = await _audioPlayer.setRepeatMode(_repeatMode);
      if (result == Result.FAIL) {
        print(
            "you tried to call audio conrolling methods on released audio player :(");
      } else if (result == Result.ERROR) {
        print("something went wrong in stop :(");
      }
    }
  }

  // Avanzar a la siguiente cancion
  Future<void> next() async {
    if(audios != null) {
      if (!_shuffleMode) {
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
      else {
        if (indiceShuffle == audiosShuffle.length - 1) {
          indice = audiosShuffle.elementAt(0);
          indiceShuffle = 0;
        }
        else {
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
  }

  // Ir a la anterior cancion
  Future<void> previous() async {
    if(audios != null) {
      if (!_shuffleMode) {
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
      else {
        if (indiceShuffle == 0) {
          indice = audiosShuffle.elementAt(audiosShuffle.length - 1);
          indiceShuffle = audiosShuffle.length - 1;
        }
        else {
          indiceShuffle--;
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
  }

  // Me quedo con las URL de las canciones
  void rellenarUrl() {
    urls = new List<String>();
    for(int i = 0; i < audios.length; i++){
      urls.add(audios[i].devolverSonido());
    }
  }

  // Relleno notificaciones para la interfaz superior del móvil
  void rellenarNotificaciones(){
    audioNotifications = new List<AudioNotification>();
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

  // Funcion que me permite mezclar canciones
  Future<void> shuffle() async {
    if(audios != null) {
      audiosShuffle = new List<int>();
      for (int i = 0; i < audios.length; i++) {
        audiosShuffle.add(i);
      }
      audiosShuffle.shuffle();
      primera = await _audioPlayer.getCurrentPlayingAudioIndex();
      int index_primera_shuffle = audiosShuffle.indexOf(primera);
      int valor_index_0 = audiosShuffle.elementAt(0);
      audiosShuffle[index_primera_shuffle] = valor_index_0;
      audiosShuffle[0] = primera;
      indiceShuffle = 0;
      audiosShuffleShow = new List<Audio>();
      for (int i = 0; i < audios.length; i++) {
        audiosShuffleShow.add(audios[audiosShuffle[i]]);
      }
    }
  }

  // Peticion para saber si existe o no una canción en favoritos
  Future<bool> existeCancionFav (Audio cancion ) async {
    final http.Response response = await http.post(
      'https://' + baseURL + '/is_fav',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader:Globals.seguridad
      },
      body: jsonEncode(<String, String>{
        'cancion': cancion.devolverID().toString(),
        'email': Globals.email.toString(),
      }),
    );
    if (response.body == 'True') {
      return  Future<bool>.value(true);
    } else {
      return  Future<bool>.value(false);
    }
  }
}