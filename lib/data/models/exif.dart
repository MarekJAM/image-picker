class Exif {
  final String make;
  final String model;
  final String expoosureTime;
  final String aperture;
  final String focalLength;
  final int iso;

  const Exif({
    this.make,
    this.model,
    this.expoosureTime,
    this.aperture,
    this.focalLength,
    this.iso,
  });

  factory Exif.fromJson(Map<String, dynamic> data) => Exif(
        make: data['make'],
        model: data['model'],
        expoosureTime: data['expoosure_time'],
        aperture: data['aperture'],
        focalLength: data['focal_length'],
        iso: data['iso'],
      );
}
