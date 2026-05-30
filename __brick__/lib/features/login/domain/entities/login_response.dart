import 'bootstrap_class.dart';
import '/core/helpers/json_validators.dart';
import '/core/helpers/nullable.dart';

class LoginResponseData {
  final String accessToken;
  final UserEntity user;
  // final Bootstrap bootstrap;

  LoginResponseData({
    required this.accessToken,
    required this.user,
    // required this.bootstrap,
  });

  LoginResponseData copyWith({
    String? accessToken,
    UserEntity? user,
    BootstrapData? bootstrap,
  }) => LoginResponseData(
    accessToken: accessToken ?? this.accessToken,
    user: user ?? this.user,
    // bootstrap: bootstrap ?? this.bootstrap,
  );

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => LoginResponseData(
    accessToken: expectString(json, 'AccessToken'),
    user: UserEntity.fromJson(expectMap(json, 'User')),
    // bootstrap: Bootstrap.fromJson(json["Bootstrap"]),
  );

  Map<String, dynamic> toJson() => {
    'AccessToken': accessToken,
    'User': user.toJson(),
    // "Bootstrap": bootstrap.toJson(),
  };
}





class UserEntity {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String? bio;
  final String? profileImageUrl;
  final int professionType;
  final String professionTitle;

  UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.bio,
    required this.profileImageUrl,
    required this.professionType,
    required this.professionTitle,
  });

  UserEntity copyWith({
    String? id,
    String? phoneNumber,
    String? fullName,
    Nullable<String?>? bio,
    int? professionType,
    String? professionTitle,
    Nullable<String?>? profileImageUrl,
  }) => UserEntity(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    fullName: fullName ?? this.fullName,
    bio: bio != null ? bio.value : this.bio,
    profileImageUrl: profileImageUrl != null ? profileImageUrl.value : this.profileImageUrl,
    professionType: professionType ?? this.professionType,
    professionTitle: professionTitle ?? this.professionTitle,
  );

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: expectString(json, 'Id'),
    phoneNumber: expectString(json, 'PhoneNumber'),
    fullName: expectString(json, 'FullName', defaultValue: ''),
    bio: expectNullableString(json, 'Bio'),
    profileImageUrl: expectNullableString(json, 'ProfileImageUrl'),
    professionType: expectInt(json, 'ProfessionTypeId', defaultValue: 1),
    professionTitle: expectString(json, 'ProfessionTitle', defaultValue: ''),
  );

  Map<String, dynamic> toJson() => {
    'Id': id,
    'PhoneNumber': phoneNumber,
    'FullName': fullName,
    'Bio': bio,
    'ProfessionTypeId': professionType,
    'ProfileImageUrl': profileImageUrl,
    'ProfessionTitle': professionTitle,
  };
}
