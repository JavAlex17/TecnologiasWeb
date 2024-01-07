import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokedex/favoritePage.dart';
import 'package:pokedex/favoritePro.dart';
import 'package:pokedex/pokemonCard.dart';
import 'package:pokedex/pokemonSearch.dart';
import 'package:pokedex/pokemonUtils.dart';
import 'package:pokedex/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_svg/flutter_svg.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final favoriteProvider = FavoriteProvider();
  await favoriteProvider.loadFavoritePokemonIds();

  runApp(
    ChangeNotifierProvider.value(
      value: favoriteProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(fontFamily: 'NeueMachina',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String selectedType = '';
  TextEditingController searchController = TextEditingController();
  List<dynamic>? pokemonList = [];
  List<dynamic>? filteredPokemonList;
  bool isPokemonSelected = false;
  bool isFavorite = false;
  String selectedPokemonId = '';
  late FavoriteProvider favoriteProvider;


  @override
  void initState() {
    super.initState();
    favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    getPokemon().then((data){
      setState((){
        pokemonList = data;
        filteredPokemonList = pokemonList;
        favoriteProvider.loadFavoritePokemonIds();
      });
    });
  }

  bool isFavoriteForPokemon(String pokemonId) {
    return favoriteProvider.isFavoriteForPokemon(pokemonId);
  }

  void updateFavorite(String pokemonId, bool newFavoriteState) {
    favoriteProvider.updateFavoriteStateForPokemon(pokemonId, newFavoriteState);
  }

  void selectPokemon(String pokemonId) {
    setState(() {
      isFavorite = isFavoriteForPokemon(pokemonId);
      selectedPokemonId = pokemonId;
    });
  }

  Future<void> _refreshPokemonList() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      getPokemon().then((data) {
        setState(() {
          pokemonList = data;
          filteredPokemonList = pokemonList;
          favoriteProvider.loadFavoritePokemonIds();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    final pokemonCard = PokemonCard(
      id: '',
      nombre: '',
      tipo: const [],
      imageUrl: '',
      peso: '',
      altura: '',
      descripcion: '',
      onTypeSelected: (selectedType) {
        setState(() {
          this.selectedType = selectedType;
          isPokemonSelected = false;
        });
      },
      isFavorited: favoriteProvider.isFavoriteForPokemon(selectedPokemonId),
      onFavoriteChanged: (bool newFavoriteState) {
        favoriteProvider.updateFavoriteStateForPokemon(selectedPokemonId, newFavoriteState);
      },
    );
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
              icon: const Icon(Icons.search, color: Colors.red,),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PokemonSearchDelegate(
                    pokemonList: pokemonList,
                    onTypeSelected: (type) {
                      setState(() {
                        selectedType = type;
                        filteredPokemonList = filterPokemonListByType(type);
                      });
                    },
                    favoritePokemonIds: favoriteProvider.favoritePokemonIds,
                    onFavoriteChanged: (String pokemonId, bool newFavoriteState) {
                      setState(() {
                        isFavorite = !isFavorite;
                        updateFavorite(pokemonId, newFavoriteState);
                      });

                    },
                  ),
                );
              }
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritePage()),);
            },
          )
        ],),
      body: RefreshIndicator(
        onRefresh: _refreshPokemonList,
        child: FutureBuilder(
          future: getPokemon(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List? pokemonList = snapshot.data;
              pokemonList?.sort((a, b) => int.parse(a['id'].substring(1))
                  .compareTo(int.parse(b['id'].substring(1))));

              List? filteredPokemonList = selectedType.isEmpty
                  ? pokemonList
                  : pokemonList
                          ?.where((pokemon) =>
                              List<String>.from(pokemon['tipo'])
                                  .contains(selectedType))
                          .toList() ?? [];

              return Column(
                children: [
                  Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: pokemonCard.tipo.map((type) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedType = type;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: PokemonUtils.getColorByTypeButton(type),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                PokemonUtils.getSvgIconType(type),
                                width: 14.0,
                                height: 14.0,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                type,
                                style: const TextStyle(
                                    fontSize: 15.0, color: Color(0xfffffbff)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPokemonList?.length,
                      itemBuilder: (context, index) {
                        final pokemonData = filteredPokemonList?[index];
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
                          isFavorited: isFavoriteForPokemon(pokemonData['id']),
                          onFavoriteChanged: (bool newFavoriteState) {
                            setState(() {
                              updateFavorite(
                                  pokemonData['id'], newFavoriteState);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  List<dynamic>? filterPokemonListByType(String type) {
    return type.isEmpty
        ? pokemonList
        : pokemonList
        ?.where(
          (pokemon) =>
          List<String>.from(pokemon['tipo']).contains(selectedType),
    )
        .toList();

  }
}


















