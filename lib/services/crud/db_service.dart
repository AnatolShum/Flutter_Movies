import 'package:movies/services/crud/db_constants.dart';
import 'package:movies/services/crud/db_exceptions.dart';
import 'package:movies/services/crud/db_favourite.dart';
import 'package:movies/services/crud/db_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class DatabaseService {
  Database? _db;

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<Iterable<DatabaseFavourites>> getAllFavourites() async {
    final db = _getDatabaseOrThrow();
    final favourites = await db.query(favouriteTable);
    return favourites
        .map((favouriteRow) => DatabaseFavourites.fromRow(favouriteRow));
  }

  Future<DatabaseFavourites> getFavourite({required int movieID}) async {
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
      return DatabaseFavourites.fromRow(favourites.first);
    }
  }

  Future<int> deleteAllfavourites() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(favouriteTable);
  }

  Future<void> deleteFavourite({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      favouriteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deleteCount == 0) {
      throw CouldNotDeleteFavouriteException();
    }
  }

  Future<DatabaseFavourites> createFavourite({
    required DatabaseUser owner,
    required int movieId,
  }) async {
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

    return favourite;
  }

  Future<DatabaseUser> getUser({required String email}) async {
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
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentsDirectoryException();
      }
    }
  }
}
