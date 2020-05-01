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