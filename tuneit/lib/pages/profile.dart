import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/AutoScrollableText.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/textFields.dart';

class Profile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState ();
}


class _ProfilePageState extends State<Profile> {

  List<Playlist> list = List();

  void obtenerDatos() async{
    List<Playlist> lista = await listasUsuario();
    setState(() {
      list = lista;
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
          title: Text('PERFIL'),
          centerTitle: true,
        ),
        drawer: LateralMenu(),
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
                                image: new NetworkImage(Globals.image)
                            )
                        )
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(Globals.name, Icons.person),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(Globals.email, Icons.mail_outline),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(Globals.country, Icons.place),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(Globals.date, Icons.cake),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('   Tus listas de reproducción', style: Theme.of(context).textTheme.subtitle,),
                ),
                SizedBox(height: 7,),
                completeListNotScrollable(list, onTapPlaylists, []),
              ],
            ),
          ),
        ),
    );
  }

  void onTapPlaylists (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowList(indetificadorLista: list[index].id.toString(), list_title: list[index].name),
    ));
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

}
