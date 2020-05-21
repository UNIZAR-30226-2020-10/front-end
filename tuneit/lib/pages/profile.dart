import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/pages/register/options.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/AutoScrollableText.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/errors.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/textFields.dart';
import 'package:tuneit/widgets/usuarios/iconText.dart';

class Profile extends StatefulWidget {

  String name;
  String email;
  String country;
  String date;
  String image;
  String token;
  bool esUser;

  Profile({Key key, @required this.name,@required this.email,@required this.country,@required this.date,@required this.image,@required this.esUser,@required this.token}):super(key : key);

  @override
  _ProfilePageState createState() => _ProfilePageState (name, email,country,date,image,esUser,token);


}


class _ProfilePageState extends State<Profile> {

  List<Playlist> list = List();
  String name;
  String email;
  String country;
  String date;
  String image;
  String token;
  bool esUser;
  bool encontrado;
  _ProfilePageState( this.name, this.email,this.country,this.date,this.image,this.esUser,this.token);

  void obtenerDatos() async{
    List<Playlist> lista = await listasUsuario(email);
    setState(() {
      list = lista;
    });
  }

  Future<void> recuento() async{
    int dato= await contarNotificaciones();
    setState(() {
      Globals.mensajes_nuevo=dato;
    });
  }

  @override
  void initState() {
    super.initState();
    obtenerDatos();
    recuento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PERFIL'),
          centerTitle: true,
          actions: <Widget>[
            esUser  ? IconButton(
              tooltip: 'Configurar perfil',
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => opcionesPerfil(),
                  ),
                );

              },
            ): IconButton(
                tooltip: 'Agregar amigo',
                onPressed: ()async{

                  bool resultado = await enviarSolicitud(Globals.email, email);

                  setState(() {
                    encontrado=resultado;
                  });
                  if(encontrado){
                    solicitudEnviada(context,name.toString());

                  }
                  else{
                    mostrarError(context,"No se ha podido entregar la solicitud");
                  }
                },
                icon: Icon(Icons.group_add),
              ),
          ],
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
                                image: new NetworkImage(image)
                            )
                        )
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(context,name, Icons.person),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(context,email, Icons.mail_outline),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(context,country, Icons.place),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: iconText(context,date, Icons.cake),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Listas de reproducción', style: Theme.of(context).textTheme.subtitle,),
                ),
                SizedBox(height: 7,),
                completeListNotScrollable(list, onTapPlaylists, []),
              ],
            ),
          ),
        ),
      bottomNavigationBar: bottomExpandableAudio(),
    );
  }

  void onTapPlaylists (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowList(indetificadorLista: list[index].id.toString(), list_title: list[index].name,esAmigo:true),
    ));
  }



}
