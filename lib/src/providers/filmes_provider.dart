import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/filmes_model.dart';

class FilmesProvider {
  String _apikey = 'bce0836b4f187f5002315a95fa4bd2c3';
  String _url = 'api.themoviedb.org';
  String _language = 'pt-BR';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Filme> _populares = new List();

  final _popularesStreamController = StreamController<List<Filme>>.broadcast();

  Function(List<Filme>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Filme>> get popularesStream => _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController?.close();
  }

  Future<List<Filme>> _procesarRepuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = jsonDecode(resp.body);

    final filmes = new Filmes.fromJsonList(decodedData['results']);

    return filmes.items;
  }

  Future<List<Filme>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});
    return await _procesarRepuesta(url);
  }

  Future<List<Filme>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRepuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Filme>> buscarFilme(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});
    return await _procesarRepuesta(url);
  }
}
