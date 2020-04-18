import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Podcast.dart';

import 'package:tuneit/classes/components/PodcastEpisode.dart';
import 'package:tuneit/pages/audioPlayer.dart';
import 'package:tuneit/widgets/lists.dart';

class ShowPodcast extends StatefulWidget {

  String podc;
  String name;

  @override
  _ShowPodcastState createState() => _ShowPodcastState(podc, name);

  ShowPodcast({Key key, @required this.podc, @required this.name}) : super(key: key);
}

class _ShowPodcastState extends State<ShowPodcast> {

  String podc;
  String name;
  List<PodcastEpisode> list = List();
  bool fav = false;
  bool init_fav;

  _ShowPodcastState(this.podc, this.name);

  void obtener_datos() async{
    List<PodcastEpisode> lista = await fetchEpisodes(podc);
    //bool favorito = await askFav(podc);
    bool favorito = true;
    setState(() {
      list = lista;
      fav = favorito;
      init_fav = favorito;
    });
  }

  @override
  void initState() {
    super.initState();
    obtener_datos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PODCAST: ' + name),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            if (fav != init_fav) changeFav(podc);
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 26.0,
          ),
        ),
        actions: <Widget>[
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
      body: completeList (list, onTapEpisode, []),
    );
  }

  void onTapEpisode (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlayerPage(audios: list, indice: index ,escanciones: false ),
    ));
  }

}
