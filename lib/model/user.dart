class User {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? phone;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? avatar;
  final String? bio;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? timezone;
  final String? language;
  final String? status;
  final String? phoneVerifiedAt;
  final bool? twoFactorEnabled;
  final String? lastLoginAt;
  final String? lastActivityAt;
  final dynamic metadata;
  final String? deletedAt;
  final String? fullName;
  final String? initials;
  final String? avatarUrl;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.phone,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.avatar,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.timezone,
    this.language,
    this.status,
    this.phoneVerifiedAt,
    this.twoFactorEnabled,
    this.lastLoginAt,
    this.lastActivityAt,
    this.metadata,
    this.deletedAt,
    this.fullName,
    this.initials,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      timezone: json['timezone'] as String?,
      language: json['language'] as String?,
      status: json['status'] as String?,
      phoneVerifiedAt: json['phone_verified_at'] as String?,
      twoFactorEnabled: json['two_factor_enabled'] as bool?,
      lastLoginAt: json['last_login_at'] as String?,
      lastActivityAt: json['last_activity_at'] as String?,
      metadata: json['metadata'],
      deletedAt: json['deleted_at'] as String?,
      fullName: json['full_name'] as String?,
      initials: json['initials'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'phone': phone,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'avatar': avatar,
      'bio': bio,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'timezone': timezone,
      'language': language,
      'status': status,
      'phone_verified_at': phoneVerifiedAt,
      'two_factor_enabled': twoFactorEnabled,
      'last_login_at': lastLoginAt,
      'last_activity_at': lastActivityAt,
      'metadata': metadata,
      'deleted_at': deletedAt,
      'full_name': fullName,
      'initials': initials,
      'avatar_url': avatarUrl,
    };
  }
}
