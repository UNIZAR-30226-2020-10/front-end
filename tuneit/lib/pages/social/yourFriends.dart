
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/social/friend.dart';
import 'package:tuneit/widgets/TuneITProgressIndicator%20.dart';
import 'package:tuneit/widgets/errors.dart';

import '../profile.dart';

class yourFriends extends StatefulWidget {
  @override
  _yourFriendsState createState() => _yourFriendsState();
}

class _yourFriendsState extends State<yourFriends> {
  List<User> amigos=[];
  bool encontrado;


 Future<bool> devolverUsers() async{
    List<User> resultado=await listarAmigos();


      amigos=resultado;
      return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Center(
      child:FutureBuilder(
        future:devolverUsers() ,
    builder: (BuildContext context, AsyncSnapshot snapshot){
    if(snapshot.hasData) {
        return ListView(
          children: listaParaAmigos(context,amigos));
    }
    else{
      return TuneITProgressIndicator();
    }
    }
        ),
      );
  }
}


List<Widget> listaParaAmigos(BuildContext context,List<User> amigos){
  if(amigos.length>0){
    return List.generate(
      amigos.length,
          (index) {
        return
          Card(
            key: Key('$index'),
            child: new ListTile(
              onTap:(){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(name:amigos[index].name,email:amigos[index].email,country: amigos[index].country,date: amigos[index].date,esUser: false,image: amigos[index].photo),
                  ),
                );

              },

              leading: GFAvatar(

                backgroundImage: NetworkImage(amigos[index].photo),
                backgroundColor: Colors.transparent,
                shape: GFAvatarShape.standard,

              ),
              title: Text(amigos[index].name),
              subtitle: Text(amigos[index].email),
              trailing: IconButton(
                onPressed: ()async{

                  bool prueba= await deleteFriend(Globals.email,amigos[index].email);
                  if(prueba){
                    operacionExito(context);

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Friend_List(),
                      ),
                    );
                  }
                else{
                  mostrarError(context, 'No se ha podido acabar su amistad con' + amigos[index].name);
                  }

                },
                icon: Icon(Icons.delete_forever),
                tooltip: 'Finalizar relación de amistad',
              ),

            ),
          );

      },
    );
  }
    else{
      return  <Widget>[

        Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("No encontrados amigos"),
        ))

      ];
  }


}
