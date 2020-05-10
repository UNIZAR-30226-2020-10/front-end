import 'dart:async';
import 'package:flutter_exoplayer/audio_notification.dart';
import 'package:flutter_exoplayer/audioplayer.dart';
import 'Audio.dart';

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

  // Variables Shuffle
  List<int> audiosShuffle = new List<int>();
  List<Audio> audiosShuffleShow = new List<Audio>();
  int indiceShuffle;
  int primera = 0;

  // Variables Canciones y Podcast Favoritos
  List<Audio> cancionesFav;
  String idFavoritas;
  String nombreFavoritas;
  // Variables Notificaciones
  List<AudioNotification> audioNotifications = new List<AudioNotification>();
  //////////////////////////////
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
  void setCancionesFavoritas(List<Audio> audiosFavoritos) => cancionesFav =  audiosFavoritos;
  void setIdFavoritas(String idFavoritas) => this.idFavoritas = idFavoritas;
  void setNombreFavoritas(String nombreFavoritas) => this.nombreFavoritas = nombreFavoritas;
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
  String getIdFavoritas(){
    return idFavoritas;
  }
  String getNombreFavoritas(){
    return nombreFavoritas;
  }

  Future<void> goTo(int indice_a_ir) async {
    final Result result = await _audioPlayer.seekIndex(indice_a_ir);
    if (result == Result.FAIL) {
      print(
          "you tried to call audio conrolling methods on released audio player :(");
    } else if (result == Result.ERROR) {
      print("something went wrong in pause :(");
    }
  }
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

  Future<void> Changeplay() async {
    if (audios != null) {
        _audioPlayer.dispose();
        _audioPlayer = new AudioPlayer();
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

  }

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

  void rellenarUrl() {
    urls = new List<String>();
    for(int i = 0; i < audios.length; i++){
      urls.add(audios[i].devolverSonido());
    }
  }

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

  bool existeCancionFav (Audio cancion ) {
    for (Audio cancionBusqueda in cancionesFav) {
      if (cancion.devolverTitulo() == cancionBusqueda.devolverTitulo()
          && cancion.devolverArtista() == cancion.devolverArtista()) return true;
    }
    return false;
  }
}