import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Artist.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/lists.dart';
import 'artistProfile.dart';

class Artists extends StatefulWidget {
  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {

  List<Artist> listaArtistas = List();

  void obtenerDatos() async{
    List<Artist> listaArt = await fetchMyArtists(Globals.email);
    setState(() {
      listaArtistas = listaArt;
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
        drawer: LateralMenu(),
        appBar: AppBar(
          title: Text('ARTISTAS'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            new SizedBox(height: 10),
            new Row(
              children: <Widget>[
                Expanded(
                  flex:  4,
                  child: SizedBox(
                  ),
                ),
                /*Expanded(
                  flex: 70,
                  child: Searcher(musNpod),
                ),*/
                Expanded(
                  flex:  4,
                  child: SizedBox(
                  ),
                ),
              ],
            ),

            new SizedBox(height: 10),

            new Expanded(
              child: listaArtistas.isEmpty? informacion() : completeList (listaArtistas, onTapArtist, [])
            )
          ],
        ),
        bottomNavigationBar: bottomExpandableAudio(),
    );
  }

  void onTapArtist (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArtistProfile(name: listaArtistas[index].name),
    ));
  }

  Widget informacion () {
    return Column(
      children: <Widget>[
        new SizedBox(height: 50),
        new Expanded(
          child: Text('Todavía no te has suscrito a ningún artista', style: Theme.of(context).textTheme.body1,),
        )
      ],
    );
  }

}