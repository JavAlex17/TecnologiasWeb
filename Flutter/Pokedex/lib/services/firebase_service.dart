import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore bd = FirebaseFirestore.instance;

Future<List> getPokemon() async {
  List pokemon = [];
  CollectionReference collectionPokemon = bd.collection('pokemon');

  QuerySnapshot queryPokemon = await collectionPokemon.get();

  queryPokemon.docs.forEach((documentoP){
    pokemon.add(documentoP.data());
  });


  return pokemon;
}