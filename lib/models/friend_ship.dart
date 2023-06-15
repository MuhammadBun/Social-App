class FriendShip {
  final String uidSender;
  final String uidRecevier;

  const FriendShip({
    required this.uidSender,
    required this.uidRecevier,
  });

  Map<String, dynamic> toMap() {
    return {
      'uidRecevier': uidRecevier,
      'uidSender': uidSender,
    };
  }

  factory FriendShip.fromMap(Map<String, dynamic> data, String documentId) {
    String uidRecevier = data['uidRecevier'];
    String uidSender = data['uidSender'];

    return FriendShip(
      uidRecevier: uidRecevier,
      uidSender: uidSender,
    );
  }
}
