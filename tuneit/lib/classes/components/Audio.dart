import 'package:url_launcher/url_launcher.dart';

abstract class  Audio{

 String devolverSonido();

 String devolverImagen();

 String devolverTitulo();

 String devolverArtista();

 String devolverID();

 String devolverGenero();

}

List<Audio> ordenarPorTituloAudios( List<Audio> songs){

 Comparator<Audio> titleComparator = (a, b) => a.devolverTitulo().compareTo(b.devolverTitulo());

 songs.sort(titleComparator);
 return songs;

}

List<Audio> ordenarPorArtistaAudios( List<Audio> songs){

 Comparator<Audio> artistComparator = (a, b) => a.devolverArtista().compareTo(b.devolverArtista());

 songs.sort(artistComparator);
 return songs;

}

Future<void> launchInBrowser(String cancion,String artista) async {
 cancion=cancion.replaceAll('-', '');
 cancion=cancion.replaceAll(' ', '+');
 artista=artista.replaceAll('-', '');
 artista=artista.replaceAll(' ', '+');

 String url= 'https://google.com/search?q=';
 url= url + artista+'+'+cancion;
 if (await canLaunch(url)) {
  await launch(
   url,
   forceSafariVC: false,
   forceWebView: false,
  );
 } else {
  throw 'Could not launch $url';
 }
}
