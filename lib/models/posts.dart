class Post {
  final String? publisherUid;
  final String postId;
  final String content;
  final String? date;
  final String? imageUrl;
  final String? imagePublicsher;
  final String? namePublicsher;
  final bool? isPublic;

  const Post(
      {this.publisherUid,
      required this.content,
      this.date,
      this.imageUrl,
      required this.postId,
      required this.isPublic,
      required this.namePublicsher,
      required this.imagePublicsher});

  Map<String, dynamic> toMap() {
    return {
      'publisherUid': publisherUid,
      'content': content,
      'date': date,
      'imageUrl': imageUrl,
      'postId': postId,
      'isPublic': isPublic,
      'namePublicsher': namePublicsher,
      'imagePublicsher': imagePublicsher,
    };
  }

  factory Post.fromMap(Map<String, dynamic> data, String documentId) {
    String publisherUid = data['publisherUid'];
    String content = data['content'];
    String date = data['date'];
    String imageUrl = data['imageUrl'];
    String postId = data['postId'];
    bool isPublic = data['isPublic'];
    String namePublicsher = data['namePublicsher'];
    String imagePublicsher = data['imagePublicsher'];

    return Post(
      publisherUid: publisherUid,
      content: content,
      date: date,
      imageUrl: imageUrl,
      postId: postId,
      isPublic: isPublic,
      namePublicsher: namePublicsher,
      imagePublicsher: imagePublicsher,
    );
  }
}
