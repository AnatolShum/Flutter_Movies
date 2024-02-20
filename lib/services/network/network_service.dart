import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:movies/models/model_movie.dart';
import 'package:movies/services/network/network_exceptions.dart';
import 'package:movies/services/network/network_types.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static final _shared = NetworkService._sharedInstance();
  NetworkService._sharedInstance();
  factory NetworkService() => _shared;

  final MethodChannel _keyMethodChannel = MethodChannel('apiKey');
  final _client = http.Client();

  Future<String> _getApiKey() async {
    try {
      final result = await _keyMethodChannel.invokeMethod('getKey');
      return result;
    } on PlatformException {
      throw ApiKeyNotFoundException();
    }
  }

  Future<String?> _getUrl(
    ArgumentType type, {
    int? id,
    String? query,
    int? page,
  }) async {
    final apiKey = await _getApiKey();
    const baseUrl = 'https://api.themoviedb.org';
    final apiQueryItem = 'api_key=$apiKey';

    switch (type) {
      case ArgumentType.movie:
        if (id == null) return null;
        return '$baseUrl/3/movie/$id?$apiQueryItem';
      case ArgumentType.videos:
        if (id == null) return null;
        return '$baseUrl/3/movie/$id/videos?$apiQueryItem';
      case ArgumentType.photos:
        if (id == null) return null;
        return '$baseUrl/3/movie/$id/images?$apiQueryItem';
      case ArgumentType.search:
        if (query == null) return null;
        return '$baseUrl/3/search/movie?$apiQueryItem&query=$query';
      case ArgumentType.nowPlaying:
        if (page == null) return null;
        return '$baseUrl/3/movie/now_playing?$apiQueryItem&page=$page';
      case ArgumentType.topRated:
        if (page == null) return null;
        return '$baseUrl/3/movie/top_rated?$apiQueryItem&page=$page';
      case ArgumentType.popular:
        if (page == null) return null;
        return '$baseUrl/3/movie/popular?$apiQueryItem&page=$page';
    }
  }

  Future<http.Response> _networkRequest({
    required ArgumentType type,
    int? id,
    String? query,
    int? page,
  }) async {
    final uri = await _getUrl(type, id: id, query: query, page: page);
    if (uri != null) {
      final response = await _client.get(Uri.parse(uri));
      return response;
    } else {
      throw UrlNotFoundException();
    }
  }

  List<Movie> _parseMovies(String responseBody) {
    final parsed = (jsonDecode(responseBody));
    final resultList = parsed['results'] as List;
    return resultList.map<Movie>((json) => Movie.fromJson(json as Map<String?, dynamic>)).toList();
  }

  Future<List<Movie>> fetchMovies({
    required ArgumentType type,
    int? id,
    String? query,
    int? page,
  }) async {
    try {
      final response = await _networkRequest(
        type: type,
        id: id,
        query: query,
        page: page,
      );
      return _parseMovies(response.body);
    } on UrlNotFoundException {
      throw ResponseErrorException();
    }
  }
}
