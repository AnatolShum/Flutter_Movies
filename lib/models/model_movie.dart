class Movie {
  final String? title;
  final int? id;
  final String? backdrop;
  final String? poster;
  final String? releaseDate;
  final String? overview;
  final double? vote;

  const Movie({
    required this.title,
    required this.id,
    required this.backdrop,
    required this.poster,
    required this.releaseDate,
    required this.overview,
    required this.vote,
  });

  factory Movie.fromJson(Map<String?, dynamic> json) {
    return Movie(
      title: json['title'] as String?,
      id: json['id'] as int?,
      backdrop: json['backdrop_path'] as String?,
      poster: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      overview: json['overview'] as String?,
      vote: json['vote_average'] as double?,
    );
  }

  @override
  String toString() =>
      'Movie: ID = $id, title = $title';

  @override
  bool operator ==(covariant Movie other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}