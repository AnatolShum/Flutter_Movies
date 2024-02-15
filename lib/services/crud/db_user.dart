import 'package:flutter/foundation.dart';
import 'package:movies/services/crud/db_constants.dart';

@immutable
class DatabaseUser {
  final int id;
  final String name;
  final String email;
  final String joined;

  DatabaseUser({
    required this.id,
    required this.name,
    required this.email,
    required this.joined,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        email = map[emailColumn] as String,
        joined = map[joinedColumn] as String;

  @override
  String toString() =>
      'USER: ID = $id, name = $name, email = $email, joined = $joined';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}