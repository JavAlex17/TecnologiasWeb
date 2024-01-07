import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/pokemonUtils.dart';


class PokemonSearchNotifier extends ChangeNotifier {
  void notifyStateChanged() {
    notifyListeners();
  }
}

class PokemonSearchDelegate extends SearchDelegate<String> {
  final List<dynamic>? pokemonList;
  final Function(String)? onTypeSelected;
  final List<String> favoritePokemonIds;
  final Function(String, bool) onFavoriteChanged;


  PokemonSearchDelegate({
    this.onTypeSelected,
    this.pokemonList,
    required this.favoritePokemonIds,
    required this.onFavoriteChanged
  });


  @override
  String get searchFieldLabel => 'Buscar por ID, Nombre o Tipo';


  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: const TextStyle(fontSize: 15.0, color: Colors.black38),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [

      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = pokemonList
        ?.where(
          (pokemon) =>
      pokemon['id'].contains(query) ||
          pokemon['nombre'].toLowerCase().contains(query.toLowerCase()) ||
          List<String>.from(pokemon['tipo']).contains(query),
    )
        .toList();

    results?.sort((a, b) {
      final idA = int.parse(a['id'].substring(1));
      final idB = int.parse(b['id'].substring(1));
      return idA.compareTo(idB);
    });

    return ListView.builder(
      itemCount: results?.length ?? 0,
      itemBuilder: (context, index) {
        final pokemonData = results?[index];
        return ListTile(
          title: Text(pokemonData['nombre']),
          subtitle: Text('ID: ${pokemonData['id']}'),
          onTap: () {
            showPokemonCardDialog(context, pokemonData, onTypeSelected!, favoritePokemonIds);
          },
        );
      },
    );
  }


  void showPokemonCardDialog(BuildContext context, dynamic pokemonData,
      Function(String) onTypeSelected,List<String> favoritePokemonIds) {
    Color bgColor = PokemonUtils.getColorByType(pokemonData['tipo'][0]);


    bool isFavorite = favoritePokemonIds.contains(pokemonData['id']);

    print("Is Favorite: $isFavorite");


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          content: Stack(
            children: [
              Container(
                width: 350.0,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(pokemonData['nombre'], style: const TextStyle(fontSize: 25.0)),
                    ),
                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'ID: ${pokemonData['id']}',
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                    if (pokemonData['imagen'] != null)
                      Image.network(
                        pokemonData['imagen'],
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    if (pokemonData['imagen'] == null)
                      const Text('No hay imagen'),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Altura: ${pokemonData['altura']}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(width: 60.0),

                        Text(
                          'Peso: ${pokemonData['peso']}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: Text(
                        pokemonData['desc'],
                        style: const TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const SizedBox(height: 10.0),
                    Center(
                      child: Wrap(
                        spacing: 10.0,
                        children: [
                          ...pokemonData['tipo'].map((type) {
                            return GestureDetector(
                              onTap: () {
                                onTypeSelected(type);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color:
                                      PokemonUtils.getColorByTypeButton(type),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      PokemonUtils.getSvgIconType(type),
                                      width: 13.0,
                                      height: 13.0,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      '$type',
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xfffffbff)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    final newFavoriteState = !isFavorite;
                    onFavoriteChanged(pokemonData['id'], newFavoriteState);
                    isFavorite = newFavoriteState;

                    final message = isFavorite
                        ? 'Añadiste el Pokemon a Favoritos, vuelve a entrar a la tarjeta para ver el cambio.'
                        : 'Eliminaste el Pokemon de Favoritos, vuelve a entrar a la tarjeta para ver el cambio.';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close, color: Colors.black54,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },

    );
  }
}
