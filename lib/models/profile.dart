import 'dart:typed_data';

class Profile {
  const Profile({required this.name, required this.contact, this.avatarUrl, this.avatarImage});

  final String name;
  final String contact;
  final String? avatarUrl;
  final Uint8List? avatarImage;
}
