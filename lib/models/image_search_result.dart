class ImageSearchResult {
  final String imageUrl;
  final String thumbnailUrl;
  final String title;
  final String contextLink;
  
  ImageSearchResult({
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.contextLink,
  });
  
  factory ImageSearchResult.fromJson(Map<String, dynamic> json) {
    return ImageSearchResult(
      imageUrl: json['link'] ?? '',
      thumbnailUrl: json['image']['thumbnailLink'] ?? '',
      title: json['title'] ?? '',
      contextLink: json['image']['contextLink'] ?? '',
    );
  }
}