
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/User.dart';

class yourFriends extends StatefulWidget {
  @override
  _yourFriendsState createState() => _yourFriendsState();
}

class _yourFriendsState extends State<yourFriends> {
  List<User> amigos=[];


  void devolverUsers() async{
    List<User> resultado=await listarAmigos();

    setState(() {
      amigos=resultado;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    devolverUsers();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: listaParaAmigos(context,amigos),
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

              },

              leading: GFAvatar(

                backgroundImage: NetworkImage(amigos[index].photo),
                backgroundColor: Colors.transparent,
                shape: GFAvatarShape.standard,

              ),
              title: Text(amigos[index].name),
              subtitle: Text(amigos[index].email),

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
