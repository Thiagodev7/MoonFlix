import 'package:flutter/material.dart';
import 'package:peliculas/src/models/filmes_model.dart';
import 'package:peliculas/src/providers/filmes_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final filmesProvider = new FilmesProvider();

  final filmes = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ironman',
    'Capitan America',
    'Superman'
  ];

  final filmesRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del appbar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando escriben
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: filmesProvider.buscarFilme(query),
      builder: (BuildContext context, AsyncSnapshot<List<Filme>> snapshot) {
        if (snapshot.hasData) {
          final filmes = snapshot.data;

          return ListView(
              children: filmes.map((filmes) {
            return ListTile(
              leading: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                image: NetworkImage(filmes.getPosterImg()),
                fit: BoxFit.cover,
              ),
              title: Text(filmes.title),
              subtitle: Text(filmes.originalTitle),
              onTap: () {
                close(context, null);
                filmes.uniqueId = '${filmes.id}-search';
                Navigator.pushNamed(context, 'detalle', arguments: filmes);
              },
            );
          }).toList());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
    // final listaSugerida = (query.isEmpty) ? filmesRecientes : filmes.where( (p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    //   return ListView.builder(
    //     itemCount: listaSugerida.length,
    //     itemBuilder: (context, i) {
    //       return ListTile(
    //         leading: Icon(Icons.movie),
    //         title: Text(listaSugerida[i]),
    //         onTap: () {
    //           seleccion = listaSugerida[i];
    //           showResults(context);
    //         },
    //       );
    //     }
    //   );
  }
}
