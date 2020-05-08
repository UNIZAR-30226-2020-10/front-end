import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Artist.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/pages/register/options.dart';
import 'package:tuneit/pages/showAlbum.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/AutoScrollableText.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/textFields.dart';

class ArtistProfile extends StatefulWidget {

  String name;

  ArtistProfile({this.name});

  @override
  _ArtistProfileState createState() => _ArtistProfileState(name: name);
}

class _ArtistProfileState extends State<ArtistProfile> {

  String name;
  Artist artist;

  _ArtistProfileState({this.name});

  void obtenerDatos() async{
    Artist aux = await artistByName(name);
    setState(() {
      artist = aux;
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
        title: Text('PERFIL DEL ARTISTA'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        width: 400,
        height: 750,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorSets.colorDarkPurple,
                            width: 2,
                          ),
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(artist.image)
                          )
                      )
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                          artist.alias == ''?
                          iconText(name, Icons.person)
                              :
                          iconText(name + ' \'' + artist.alias + '\'', Icons.person),
                        ),
                        SizedBox(height: 5,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: iconText(artist.country, Icons.place),
                        ),
                        SizedBox(height: 5,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: iconText(artist.date, Icons.cake),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('   Albumes del artista', style: Theme.of(context).textTheme.subtitle,),
              ),
              SizedBox(height: 7,),
              completeListNotScrollable(artist.albums, onTapAlbum, []),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomExpandableAudio(),
    );
  }

  Widget iconText (String text, IconData ic) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10,),
        Icon(ic, size: 20,),
        SizedBox(width: 10,),
        Expanded(
          child: MarqueeWidget(
            child: Text(text, style: Theme.of(context).textTheme.body1,),
          ),
        )
      ],
    );
  }

  void onTapAlbum (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowAlbum(artist.albums[index].name),
    ));
  }
}
