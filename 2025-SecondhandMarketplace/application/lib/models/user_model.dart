class User {
  // This is where necessary user information will go 

  final String id;
  final String username;
  final String location;
  final String postalCode;
  final double ratingScore;
  final int ratingCount;
  final String avatarUrl;
  final String bio;
  final int level;
  final int xp;

  User({
    required this.id,
    required this.username,
    required this.location,
    required this.postalCode,
    required this.ratingScore,
    required this.ratingCount,
    required this.avatarUrl,
    required this.bio,
    required this.level,
    required this.xp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      location: json['location'] ?? '',
      postalCode: json['postal_code'] ?? '',
      ratingScore: (json['rating_score'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      avatarUrl: json['avatar_url'] ?? '',
      bio: json['bio'] ?? '',
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
    );
  }
}