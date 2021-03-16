class Url {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  const Url({this.raw, this.full, this.regular, this.small, this.thumb});

  factory Url.fromJson(Map<String, dynamic> data) => Url(
        raw: data['raw'],
        full: data['full'],
        regular: data['regular'],
        small: data['small'],
        thumb: data['thumb'],
      );
}
