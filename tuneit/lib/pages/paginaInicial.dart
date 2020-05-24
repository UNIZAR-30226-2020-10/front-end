import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Artist.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Category.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaCancion.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaLista.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';
import 'package:tuneit/classes/components/notificaciones/PushProvider.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/artistProfile.dart';
import 'package:tuneit/pages/podcast/showPodcast.dart';
import 'package:tuneit/pages/showCategory.dart';
import 'package:tuneit/pages/social/notificaciones.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionSongs.dart';
import 'package:tuneit/widgets/TuneITProgressIndicator%20.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../widgets/LateralMenu.dart';


class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Podcast> listaPodcast = List();
  List<Song> listaUltCanc = List();
  List<Category> listaCateg = List();
  List<Artist> listaArtistas = List();

  Future<bool> obtenerPodcasts() async{

    List<Podcast> listaPodc = await fetchBestPodcasts();

      setState(() {
        listaPodcast = listaPodc;
      });

     return true;

  }

  Future<bool> obtenerGeneros() async{
    List<Category> listaCat = await listCategories ();

    setState(() {
      listaCateg = listaCat;
    });

    return true;
  }

  Future<bool> obtenerArtistas() async{
    List<Artist> listaArt = await listArtists ();

    setState(() {
      listaArtistas = listaArt;
    });

    return true;
  }

  Future<bool> obtenerCanciones() async{
    List<Song> listaUC = await lastAddedSongs();
    setState(() {
      listaUltCanc = listaUC.sublist(listaUC.length - 11, listaUC.length - 1).reversed.toList();
    });

    return true;


  }

  Future<void> recuento() async{
    int dato= await contarNotificaciones();
    setState(() {

  Globals.mensajes_nuevo=dato;
    });


    final http.Response response = await http.get('https://' +baseURL, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader:Globals.seguridad,

    });

    if (response.statusCode == 200 ) {



    } else {

      print('Error con lo de la seguridad');

    }

  }

  void initState() {
    super.initState();

    reaccionarNotificacion();
    recuento();

    obtenerPodcasts();
    obtenerGeneros();
    obtenerArtistas();
    obtenerCanciones();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAGINA PRINCIPAL'),
        centerTitle: true,
      ),
      drawer: LateralMenu(),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('   Géneros musicales', style: Theme.of(context).textTheme.subtitle,),
              ),
              Container(
                height: 200,
                child: completeListHorizontal(listaCateg, onTapCategory, []),

              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('   Los mejores podcasts', style: Theme.of(context).textTheme.subtitle,),
              ),
              Container(
                height: 200,
                child: completeListHorizontal(listaPodcast, onTapPodcasts, []),
                ),

                //completeListHorizontal(listaPodcast, onTapPodcasts, []),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('   Artistas destacados', style: Theme.of(context).textTheme.subtitle,),
              ),
              Container(
                height: 200,
                child: completeListHorizontal(listaArtistas, onTapArtist, []),

                ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text('   Últimas canciones', style: Theme.of(context).textTheme.subtitle,),
              ),

              ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: listaUltCanc.length,
                          itemBuilder: (BuildContext context, int index) {
                            return listaParaAudiosCategorias(context, listaUltCanc, "NoLista",true, choiceAction,) [index];
                          }
                      ),

            ],
          ),
        ),
      ),
        bottomNavigationBar: bottomExpandableAudio(),
    );
  }

  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    String id_lista=hola[2];
    int indice=int.parse(hola[3]);

    if(choice == optionMenuSongCategory[0]){
      List<Playlist>listas=await fetchPlaylists(Globals.email);
      mostrarListas(context,listas,id_song,false);
    }
    else if(choice ==optionMenuSongCategory[1]){
      List<User> amigos=await listarAmigos();
      mostrarAmigos(context,amigos,id_song);
    }
    else if(choice == optionMenuSongCategory[2]){
      launchInBrowser(listaUltCanc[indice].devolverTitulo(),listaUltCanc[indice].devolverArtista());
    }
    else if(choice == optionMenuSongCategory[3]){
      agregada(context,Globals.id_fav,listaUltCanc[indice].devolverTitulo(),false);
      // Pedir la lista de favoritos actualizada
    }
    else{
      print ("Correct option was not found");

    }

  }

  void onTapPodcasts (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowPodcast(podcId: listaPodcast[index].id, podcName: listaPodcast[index].name),
    ));
  }

  void onTapCategory (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowCategory(name: listaCateg[index].name),
    ));
  }

  void onTapArtist (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArtistProfile(name: listaArtistas[index].name),
    ));
  }



  void reaccionarNotificacion() async {

    var pus1=PushProvider();
    pus1.mensaje.listen((argumento) async{
      String data = argumento.title;
      String cuerpo = argumento.body;
      if(data!=null && cuerpo!=null){
        setState(() {
          Globals.mensajes_nuevo=Globals.mensajes_nuevo+1;
        });

      }

    });


  }
}
