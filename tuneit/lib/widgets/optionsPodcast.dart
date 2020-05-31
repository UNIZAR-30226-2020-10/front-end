

import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/podcast/Podcast.dart';
import 'package:tuneit/classes/components/usuario/User.dart';
import 'package:tuneit/widgets/errors.dart';

void mostrarAmigosPodcast(BuildContext context,List<User> amigos, String id_podcast)async{

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: AlertDialog(
            content:Container(

              width: double.maxFinite,
              child:
              ListView.builder(

                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                itemCount: amigos.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: new ListTile(
                      onTap:() async {
                        bool resultado= await compartirPodcast(id_podcast,amigos[index].email);
                        Navigator.pop(context);
                        if(resultado){
                          operacionExito(context);
                        }
                        else{
                          mostrarError(context, "No se ha podido compartir el podcast");
                        }
                      },
                      title: Text(amigos[index].name),
                    ),
                  );

                },
              ),

            ),
          ),
        );
      }
  );

}