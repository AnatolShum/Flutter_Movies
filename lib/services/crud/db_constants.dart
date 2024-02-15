const dbName = 'movies.db';
const favouriteTable = 'favourite';
const userTable = 'user';
const idColumn = 'id';
const nameColumn = 'name';
const emailColumn = 'email';
const joinedColumn = 'joined';
const movieIdColumn = 'movie_id';
const userIdColumn = 'user_id';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	"joined"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createFavouriteTable = '''CREATE TABLE IF NOT EXISTS "favourite" (
	"id"	INTEGER NOT NULL,
	"movie_id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';