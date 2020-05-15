import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/profile.dart';
import 'package:tuneit/widgets/errors.dart';

class buscarAmigos extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<buscarAmigos> {
  bool encontrado=false;
  List list = [
    "Flutter",
    "Angular",
    "Node js",
  ];
  @override
  Widget build(BuildContext context) {
return Center(
  child:   Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: searchFriends(context),
  ),
);
  }

  Widget searchFriends(BuildContext context){
    return SearchBar<User>(
      hintText: "Buscar amigos",
      searchBarStyle: SearchBarStyle(
        backgroundColor: ColorSets.colorButtonPurple,
        padding: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
      ),


      hintStyle: TextStyle(
        color: ColorSets.colorWhite,
      ),
      textStyle: TextStyle(
        color: ColorSets.colorWhite,
        fontWeight: FontWeight.bold,
      ),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,

      onSearch: searchUsers,
      loader: Text("Buscando en la base de datos..."),

      onError: (error) {
        return Center(
          child: Text("No se han encontrado resultados"),
        );
      },
      emptyWidget: Center(
        child: Text("No se han encontrado resultados"),
      ),

      onItemFound: (User user,int index){
        return ListTile(
          leading: GFAvatar(
            shape: GFAvatarShape.circle,
            backgroundImage: NetworkImage(user.photo,
            ),

          ),
          title:Text( user.name.toString()),

          onTap: (){
            //mostrarError(context,"Tienes que ser amigo de " +user.name.toString() +" para ver su perfil.");
          },
          trailing: IconButton(
            tooltip: 'Agregar amigo',
            onPressed: ()async{
              bool resultado = await enviarSolicitud(Globals.email, user.email);

              setState(() {
                encontrado=resultado;
              });
              if(encontrado){

                solicitudEnviada(context,user.name.toString());

              }
              else{
                mostrarError(context,"No se ha podido entregar la solicitud");
              }
            },
            icon: Icon(Icons.group_add),
          ),


        );
      },
    );
  }
}

