import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/classes/components/PodcastEpisode.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/pages/audio/audioPlayer.dart';
import 'package:tuneit/pages/audio/playlists.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionsPodcast.dart';

class ShowPodcast extends StatefulWidget {

  String podcId;
  String podcName;

  @override
  _ShowPodcastState createState() => _ShowPodcastState(podcId, podcName);

  ShowPodcast({Key key, @required this.podcId, @required this.podcName}) : super(key: key);
}

class _ShowPodcastState extends State<ShowPodcast> {

  String podcId;
  String podcName;
  List<PodcastEpisode> list = List();
  bool fav = false;
  bool initFav;
  List<User> amigos=[];

  _ShowPodcastState(this.podcId, this.podcName);

  void obtenerDatos() async{
    List<User> ff=await listarAmigos();

    List<PodcastEpisode> lista = await fetchEpisodes(podcId);
    bool favorito = await checkFav(podcId);
    setState(() {
      list = lista;
      fav = favorito;
      initFav = favorito;
      amigos=ff;
    });
  }

  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PODCASTS'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            if (fav != initFav) {
              if (fav) isFav(podcId, podcName);
              else isNotFav(podcId);
            }
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 26.0,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon:Icon(Icons.share),
              tooltip: 'Compartir podcast',
              onPressed: (){

                mostrarAmigosPodcast(context, amigos,podcId,);


              },

            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  fav = !fav;
                });
              },
              child: Icon(
                fav? Icons.star : Icons.star_border,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: listaParaAudios(context,list,podcId.toString(),false,null),
            ),
          ),
        ],
      ),

      bottomNavigationBar: bottomExpandableAudio(),
     // completeList (list, onTapEpisode, []),
    );
  }

  void onTapEpisode (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlayerPage(audios: list, indice: index ,escanciones: false ),
    ));
  }

}
