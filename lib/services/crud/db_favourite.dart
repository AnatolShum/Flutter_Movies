import 'package:flutter/foundation.dart';
import 'package:movies/services/crud/db_constants.dart';

@immutable
class DatabaseFavourites {
  final int id;
  final int movieId;
  final int userId;

  DatabaseFavourites({
    required this.id,
    required this.movieId,
    required this.userId,
  });

  DatabaseFavourites.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        movieId = map[movieIdColumn] as int,
        userId = map[userIdColumn] as int;

  @override
  String toString() =>
      'Favourite: ID = $id, movieID = $movieId, userID = $userId';

  @override
  bool operator ==(covariant DatabaseFavourites other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
