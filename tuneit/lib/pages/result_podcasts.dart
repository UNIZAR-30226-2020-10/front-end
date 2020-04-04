import 'package:flutter/material.dart';
import 'package:tuneit/classes/Playlist.dart';
import 'package:tuneit/classes/Podcast.dart';
import 'package:tuneit/pages/playlists.dart';
import 'package:tuneit/pages/show_list.dart';
import 'package:tuneit/pages/show_podcast.dart';
class ResultListPodcast extends StatelessWidget {


  List<Podcast> list_p = List();
String list_title;

ResultListPodcast({this.list_p,this.list_title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title:Text( 'TuneIT'),
      centerTitle: true,
      backgroundColor: Colors.red[500],
      ),

      body: Column(
      children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Title(
            child: Text('Resultados de la busqueda de: $list_title',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 32
            ),
            ),
            color:Colors.black,
            ),
          ),

        content_list(),

        ]



      ),
      );

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

Widget list_box (BuildContext context, index) {
  return new GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowPodcast(podc: list_p[index].id),
        ));

    },
    child: template_list(
         list_p[index].image,
        list_p[index].title
    ),
  );
}

Widget content_list() {
  return Expanded(
    child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount:  list_p.length,
        itemBuilder: (BuildContext context, int index) {
          return list_box(context,index);
        }
    ),
  );
}



}
