import 'package:collection/collection.dart';
import 'dart:async';
import 'package:movies/services/crud/db_constants.dart';
import 'package:movies/services/crud/db_exceptions.dart';
import 'package:movies/services/crud/db_favourite.dart';
import 'package:movies/services/crud/db_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class DatabaseService {
  Database? _db;

  List<DatabaseFavourites> _favourites = [];

  static final _shared = DatabaseService._sharedInstance();
  DatabaseService._sharedInstance();
  factory DatabaseService() => _shared;

  final _favouritesStreamController =
      StreamController<List<DatabaseFavourites>>.broadcast();

  Stream<List<DatabaseFavourites>> get allFavourites =>
      _favouritesStreamController.stream;

  Future<DatabaseUser> getOrCreateUser(
      {required String name, required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final createdUser = await createUser(name: name, email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFavourites({
    required DatabaseUser owner,
    required int movieId,
  }) async {
    final Iterable<DatabaseFavourites> favourites = await getAllFavourites();
    final DatabaseFavourites? exist = favourites
        .firstWhereOrNull((favourite) => favourite.movieId == movieId);
    if (exist != null) {
      await deleteFavourite(id: exist.id);
    } else {
      await createFavourite(owner: owner, movieId: movieId);
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //
    }
  }

  Future<void> _cacheFavourites() async {
    final allFavourites = await getAllFavourites();
    _favourites = allFavourites.toList();
    _favouritesStreamController.add(_favourites);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<Iterable<DatabaseFavourites>> getAllFavourites() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final favourites = await db.query(favouriteTable);
    return favourites
        .map((favouriteRow) => DatabaseFavourites.fromRow(favouriteRow));
  }

  Future<DatabaseFavourites> getFavourite({required int movieID}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final favourites = await db.query(
      favouriteTable,
      limit: 1,
      where: 'movie_id = ?',
      whereArgs: [movieID],
    );

    if (favourites.isEmpty) {
      throw CouldNotFindFavouriteException();
    } else {
      final favourite = DatabaseFavourites.fromRow(favourites.first);
      _favourites.removeWhere((favourite) => favourite.movieId == movieID);
      _favourites.add(favourite);
      _favouritesStreamController.add(_favourites);
      return favourite;
    }
  }

  Future<int> deleteAllfavourites() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(favouriteTable);
    _favourites = [];
    _favouritesStreamController.add(_favourites);
    return numberOfDeletions;
  }

  Future<void> deleteFavourite({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      favouriteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deleteCount == 0) {
      throw CouldNotDeleteFavouriteException();
    } else {
      _favourites.removeWhere((favourite) => favourite.id == id);
      _favouritesStreamController.add(_favourites);
    }
  }

  Future<DatabaseFavourites> createFavourite({
    required DatabaseUser owner,
    required int movieId,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);

    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }

    final favouriteId = await db.insert(favouriteTable, {
      userIdColumn: owner.id,
      movieIdColumn: movieId,
    });

    final favourite = DatabaseFavourites(
      id: favouriteId,
      movieId: movieId,
      userId: owner.id,
    );

    _favourites.add(favourite);
    _favouritesStreamController.add(_favourites);

    return favourite;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser(
      {required String name, required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});

    final joined = DateTime.now().toString();

    return DatabaseUser(id: userId, name: name, email: email, joined: joined);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    } else {
      try {
        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);
        final db = await openDatabase(dbPath);
        _db = db;
        await db.execute(createUserTable);
        await db.execute(createFavouriteTable);
        await _cacheFavourites();
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentsDirectoryException();
      }
    }
  }
}
