class User {
  final String id;
  final String username;
  final String name;
  final String instagramUsername;
  final String twitterUsername;
  final String portfolioUrl;

  const User({
    this.id,
    this.username,
    this.name,
    this.instagramUsername,
    this.twitterUsername,
    this.portfolioUrl,
  });

  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data['id'],
        username: data['username'],
        name: data['name'],
        instagramUsername: data['instagram_username'],
        twitterUsername: data['twitter_username'],
        portfolioUrl: data['portfolio_url'],
      );
}
