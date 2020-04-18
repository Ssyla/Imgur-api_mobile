class Post {
  final List<dynamic> links;

  Post({this.links});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      links: json['data'],
    );
  }
}
