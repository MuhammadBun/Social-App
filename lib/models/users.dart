class Users {
  final String uid;
  final String? name;
  final String? bio;
  final String? profileImage;

  const Users({
    required this.uid,
    this.name,
    this.bio,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'bio': bio,
      'profileImage': profileImage,
    };
  }

  factory Users.fromMap(Map<String, dynamic> data, String documentId) {
    String name = data['name'];
    String uid = data['uid'];
    String bio = data['bio'];
    String profileImage = data['profileImage'];
 
    return Users(
      name: name,
      uid: uid,
      bio: bio,
      profileImage: profileImage,
    );
  }
}
