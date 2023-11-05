class Channel {
  final String videoUrl;
  final String imageUrl;
  final String title;
  final String id;

  const Channel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json["id"] as String,
      title: json["title"] as String,
      imageUrl: json["imageUrl"] as String,
      videoUrl: json["videoUrl"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "imageUrl": imageUrl,
      "videoUrl": videoUrl,
    };
  }
}
