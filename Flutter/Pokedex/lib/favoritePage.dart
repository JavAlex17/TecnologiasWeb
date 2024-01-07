import 'package:flutter/material.dart';
import 'package:pokedex/favoritePro.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/pokemonCard.dart';
import 'package:pokedex/services/firebase_service.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String selectedType = '';
  late FavoriteProvider favoriteProvider;
  late Future<List<dynamic>> pokemonListFuture;
  List<dynamic>? pokemonList = [];

  @override
  void initState() {
    super.initState();
    favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    pokemonListFuture = getPokemon();
    getPokemon().then((data){
      setState((){
        pokemonList = data;
      });
    });
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            padding: const EdgeInsets.only(left: 17.0),
            icon: Image.asset('lib/assets/img/pelota.png',
                width: 30,
                height: 30
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),);
            },
          );
        }
        ),
        title: const Text('Pokédex', style: TextStyle(fontSize: 29.0),),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),);
            },
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: pokemonListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());

          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los Pokémon.'));

          } else {
            final favoriteProvider = Provider.of<FavoriteProvider>(context);

            return ListView.builder(
              itemCount: favoriteProvider.favoritePokemonIds.length,
              itemBuilder: (context, index) {
                final pokemonId = favoriteProvider.favoritePokemonIds[index];
                final pokemonData = pokemonList?.firstWhere(
                  (pokemon) => pokemon['id'] == pokemonId,
                  orElse: () => null,
                );

                if (pokemonData != null) {
                  return PokemonCard(
                    id: pokemonData['id'],
                    nombre: pokemonData['nombre'],
                    tipo: List<String>.from(pokemonData['tipo']),
                    imageUrl: pokemonData['imagen'],
                    peso: pokemonData['peso'],
                    altura: pokemonData['altura'],
                    descripcion: pokemonData['desc'],
                    onTypeSelected: (selectedType) {
                      setState(() {
                        this.selectedType = selectedType;
                      });
                    },
                    isFavorited: favoriteProvider
                        .isFavoriteForPokemon(pokemonData['id']),
                    onFavoriteChanged: (bool newFavoriteState) {
                      setState(() {
                        favoriteProvider.updateFavoriteStateForPokemon(
                            pokemonData['id'], newFavoriteState);
                      });
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}