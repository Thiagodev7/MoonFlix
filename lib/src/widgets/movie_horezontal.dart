import 'package:flutter/material.dart';
import 'package:peliculas/src/models/filmes_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Filme> filmes;
  final Function siguientePagina;

  MovieHorizontal({@required this.filmes, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: filmes.length,
          itemBuilder: (context, i) => _tarjeta(context, filmes[i])),
    );
  }

  Widget _tarjeta(BuildContext context, Filme filme) {
    filme.uniqueId = '${filme.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: filme.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 160.0,
                  image: NetworkImage(filme.getPosterImg())),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            filme.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: filme);
      },
    );
  }

  // List<Widget> _tarjetas(BuildContext context) {

  //   return filmes.map( (filme) {

  //   }).toList();
  // }

}
