import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/pages/showPodcast.dart';
import 'package:tuneit/widgets/lists.dart';

class ResultPodcasts extends StatefulWidget {

  List<Podcast> listPodcasts = List();
  String title;

  @override
  _ResultPodcastsState createState() => _ResultPodcastsState(listPodcasts, title);

  ResultPodcasts(this.listPodcasts,this.title);
}

class _ResultPodcastsState extends State<ResultPodcasts> {

  List<Podcast> listPodcasts = List();
  String title;

  _ResultPodcastsState(this.listPodcasts,this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('BUSQUEDA: ' + title),
        centerTitle: true,
      ),

      body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15, top: 10, bottom: 7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Resultados',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            Expanded(
              child: completeList(listPodcasts, onTap, []),
            )
          ]
      ),
    );
  }

  void onTap (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowPodcast(podc: listPodcasts[index].id),
    ));
  }
}
