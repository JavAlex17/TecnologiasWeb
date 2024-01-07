import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/favoritePro.dart';
import 'package:pokedex/pokemonUtils.dart';
import 'package:provider/provider.dart';

class PokemonCard extends StatefulWidget {
  final String id;
  final String nombre;
  final List<String> tipo;
  final String imageUrl;
  final String peso;
  final String altura;
  final String descripcion;
  final Function(String) onTypeSelected;
  final bool isFavorited;
  final Function(bool) onFavoriteChanged;

  const PokemonCard({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.imageUrl,
    required this.peso,
    required this.altura,
    required this.descripcion,
    required this.onTypeSelected,
    required this.isFavorited,
    required this.onFavoriteChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard>{
  bool isExpanded = false;

  void updateFavoriteState(bool newFavoriteState) {
    widget.onFavoriteChanged(newFavoriteState);
    Provider.of<FavoriteProvider>(context, listen: false)
        .updateFavoriteStatePage(widget.id, newFavoriteState);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.tipo.isNotEmpty
          ? PokemonUtils.getColorByType(widget.tipo.first)
          : const Color(0xfffffbff),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              height: isExpanded ? 355.0 : 160.0,
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.id,
                                style: const TextStyle(fontSize: 18.0)),
                            const SizedBox(height: 10.0),
                            Text(widget.nombre,
                                style: const TextStyle(
                                    fontSize: 26.0, color: Color(0xfffffbff))),
                            const SizedBox(height: 10.0),
                            if (isExpanded)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Altura: ${widget.altura}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    'Peso: ${widget.peso}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                            if (!isExpanded)
                            Wrap(
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children: widget.tipo.map((type) {
                                return GestureDetector(
                                  onTap: () {
                                    widget.onTypeSelected(type);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: PokemonUtils.getColorByTypeButton(
                                          type),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          PokemonUtils.getSvgIconType(type),
                                          width: 14.0,
                                          height: 14.0,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(type,
                                            style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Color(0xfffffbff))),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Image.network(widget.imageUrl, height: isExpanded ? 210.0 : 150.0,),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                  if (isExpanded)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.descripcion,
                            style: const TextStyle(fontSize: 17.0),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15.0),
                          Wrap(
                            spacing: 30.0,
                            runSpacing: 15.0,
                            children: widget.tipo.map((type) {
                              return GestureDetector(
                                onTap: () {
                                  widget.onTypeSelected(type);
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
                                        width: 14.0,
                                        height: 14.0,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(type,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xfffffbff))),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            right: 10.0,
            child: IconButton(
              icon: Icon(
                widget.isFavorited ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  final newFavoriteState = !widget.isFavorited;
                  updateFavoriteState(newFavoriteState);
                });
              },
            ),
          ),
        ],
      ),


    );
  }
}
