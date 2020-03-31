import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tuneit/classes/LateralMenu.dart';
import 'package:tuneit/classes/Podcast.dart';
import 'package:tuneit/classes/Podcast_Episode.dart';

class ShowPodcast extends StatefulWidget {

  String podc;

  @override
  _ShowPodcastState createState() => _ShowPodcastState(podc);

  ShowPodcast({Key key, @required this.podc}) : super(key: key);
}

class _ShowPodcastState extends State<ShowPodcast> {

  String podc;
  List<Podcast_Episode> list = List();

  _ShowPodcastState(this.podc);

  void obtener_datos() async{
    List<Podcast_Episode> lista = await fetchEpisodes(podc);
    setState(() {
      list = lista;
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
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: Text('Podcast'),
        centerTitle: true,
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return list_box(context, '/list', list[index].title, list[index].image, list[index].id);
          }
      ),
    );
  }

}

Widget template_list (String image, String playlist_name) {
  return new Container(
    decoration: new BoxDecoration(
        color: Colors.indigo[700],
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
          bottomLeft: const Radius.circular(8.0),
          bottomRight: const Radius.circular(8.0),
        )
    ),
    child: Center(
        child: Column(
            children: <Widget>[
              Flexible(
                  flex: 5,
                  child: new Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(

                        image: new NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ),
              Flexible(
                flex: 1,
                child: Center(
                    child: FittedBox(
                      child: Text(playlist_name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ),
            ]
        )
    ),
    margin: const EdgeInsets.all(4.0),
    padding: const EdgeInsets.all(1),
  );
}

Widget list_box (
    BuildContext context, String route, String name, String image, String id
    ) {
  return new GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowPodcast(podc: id),
      ));
    },
    child: template_list(image, name),
  );
}