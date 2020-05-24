import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaCancion.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaLista.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaPodcast.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/model/message.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/TuneITProgressIndicator%20.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/errors.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/optionSongs.dart';


class Notificaciones extends StatefulWidget{

  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
   List<Peticion> peticiones = [];
   List<CompartidaCancion> songs=[];
   List<CompartidaLista>  playlists=[];
   List<CompartidaPodcast> podcasts_future=[];

   void choiceAction(String choice) async{
     List<String> hola=choice.split("--");
     choice=hola[0];
     int id_song=int.parse(hola[1]);
     int indice=int.parse(hola[3]);

     if(choice == optionMenuSong[0]){
       List<Playlist>listas=await fetchPlaylists(Globals.email);
       mostrarListas(context,listas,id_song,false);
     }
     else if(choice ==optionMenuSong[1]){
       List<User> amigos=await listarAmigos();
       mostrarAmigos(context,amigos,id_song);

     }
     else if(choice ==optionMenuSong[2]){

     }
     else if(choice == optionMenuSong[3]){
       launchInBrowser(songs[indice].cancion.devolverTitulo(),songs[indice].cancion.devolverArtista());
     }
     else if(choice == optionMenuSong[4]){
       agregada(context,Globals.id_fav,songs[indice].cancion.devolverTitulo(),false);
     }
     else{
       print ("Correct option was not found");

     }

   }



   Future <void> obtenerDatos() async{
     List<CompartidaPodcast> podcasts= await CompartidosPodcastConmigo();
     desNotificarLista( podcasts,'/unnotify_podcast');
     List<Peticion> prueba = await buscarPeticiones();
     List<CompartidaCancion> canciones=await canciones_compartidas_conmigo();
     List<CompartidaLista>  listas=await listasCompartidas();
     desNotificarLista(canciones,'/unnotify_song');
     desNotificarLista(listas,'/unnotify_list');

     setState(() {
       podcasts_future=podcasts;
       peticiones=prueba;
       songs=canciones;
       playlists=listas;
     });


   }



  @override
  void initState() {
    obtenerDatos();
    Globals.mensajes_nuevo=0;

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final size_width = MediaQuery.of(context).size.width;
    final size_height= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
        centerTitle: true,
      ),
      drawer: LateralMenu(),
      body:  SingleChildScrollView(
          child: Column(
              children:[
                SizedBox(height: size_height*0.01,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('  Peticiones de amistad', style: Theme.of(context).textTheme.subtitle,),
                ),
                SizedBox(height: size_height*0.01,),

                listaParaNotificaciones(context,peticiones,size_width,size_height),

                SizedBox(height: size_height*0.01,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('   Canciones compartidas', style: Theme.of(context).textTheme.subtitle,),
                ),
                SizedBox(height:  size_height*0.01,),

                 listaParaAudiosCompartidos(context,songs,"none",choiceAction),


                SizedBox(height:  size_height*0.01,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('  Listas de reproducción compartidas', style: Theme.of(context).textTheme.subtitle,),
                ),

                SizedBox(height:  size_height*0.01,),

                listaParaListasCompartidos(context,playlists),


                SizedBox(height:  size_height*0.01,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('  Podcasts compartidas', style: Theme.of(context).textTheme.subtitle,),
                ),

                SizedBox(height:  size_height*0.01,),
                listaPodcastCompartidos(context,podcasts_future),
                SizedBox(height:  size_height*0.01,),
              ]
          ),
        ),
      bottomNavigationBar: bottomExpandableAudio(),
    );
  }

   void onTapPlaylist (int index) {
     Navigator.of(context).push(MaterialPageRoute(
       builder: (context) => ShowList(indetificadorLista: playlists[index].id.toString(), list_title: playlists[index].lista.name,esAmigo: true,),
     ));
   }




}
