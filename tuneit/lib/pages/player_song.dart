import 'dart:async';
import 'dart:io';
import 'package:tuneit/pages/player_widget.dart';

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
  @override
  _PlayerPageState createState() => _PlayerPageState ();
}

class _PlayerPageState extends State<PlayerPage> {
  String url_cancion = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
  String titulo_cancion;
  String artista;
  AudioPlayer advancedPlayer = AudioPlayer();
  String url_imagen;



  //----------------------------------------------------//


  //Cargar datos

  Future <void> funcion_auxiliar()async{
   await rellenarDatos();

  }

  Future <void> rellenarDatos()async{

      final Map argumentos = ModalRoute.of(context).settings.arguments as Map;
      setState(() {
        titulo_cancion=argumentos['titulo_cancion'];
        artista=argumentos['artista'];
        url_imagen=argumentos['url_imagen'];

      });


  }

  //----------------------------------------------------//




  @override
  void initState() {
    super.initState();

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
                    child: Text('${titulo_cancion}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 32
                      ),
                    ),
                  ),



              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${artista}',
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
                child: PlayerWidget(
                    url: url_cancion,
                ),
              ),


                ],



          ),
        ),
      ),
    );
  }
}
