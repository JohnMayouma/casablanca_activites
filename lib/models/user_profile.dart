// lib/models/user_profile.dart

class UserProfile {
  final String firstName;
  final String lastName;
  final String location;
  final String imageUrl;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.imageUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
