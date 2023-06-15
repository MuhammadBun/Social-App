class RequestFriend {
  late final String uidSender;
  late final String uidRecevier;
  late final String requestId;
  late final String imageUrlSender;
  late final String nameSender;

  RequestFriend({
    required this.uidSender,
    required this.uidRecevier,
    required this.requestId,
    required this.imageUrlSender,
    required this.nameSender,
  });

  Map<String, dynamic> toMap() {
    return {
      'uidSender': uidSender,
      'uidRecevier': uidRecevier,
      'requestId': requestId,
      'nameSender': nameSender,
      'imageUrlSender': imageUrlSender,
    };
  }

  factory RequestFriend.fromMap(Map<String, dynamic> data, String documentId) {
    String uidSender = data['uidSender'];
    String uidRecevier = data['uidRecevier'];
    String requestId = data['requestId'];
    String nameSender = data['nameSender'];
    String imageUrlSender = data['imageUrlSender'];

    return RequestFriend(
      uidSender: uidSender,
      uidRecevier: uidRecevier,
      requestId: requestId,
      nameSender: nameSender,
      imageUrlSender: imageUrlSender,
    );
  }
}
