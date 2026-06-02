// lib/features/auth/data/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String aboutMe;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.address = '',
    this.aboutMe = '',
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      aboutMe: json['aboutMe'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'aboutMe': aboutMe,
    'createdAt': createdAt?.toIso8601String(),
  };

  /// Mock user for development
  static const UserModel mock = UserModel(
    id: 'mock-user-001',
    name: 'Budi Santoso',
    email: 'budi@agrotani.id',
    phone: '081234567890',
    address: 'Desa Suka Maju, Karawang',
    aboutMe: 'Petani padi sejak 1990.',
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? aboutMe,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      aboutMe: aboutMe ?? this.aboutMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
