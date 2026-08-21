import 'address.dart';

enum BuyerStatus {
  approved,
  pending,
  rejected,
}

class BuyerProfile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String middleInitial;
  final String sex;
  final String contactNo;
  final String birthday;
  final int age;
  final PhilippineAddress address;
  final String kycIdType;
  final String kycIdFileName;
  final String? kycIdPreviewUrl;
  final String submittedAt;
  final BuyerStatus status;
  final bool isVip;
  final String avatarUrl;

  const BuyerProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.middleInitial = '',
    required this.sex,
    required this.contactNo,
    required this.birthday,
    required this.age,
    required this.address,
    required this.kycIdType,
    required this.kycIdFileName,
    this.kycIdPreviewUrl,
    required this.submittedAt,
    required this.status,
    this.isVip = false,
    this.avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
  });

  String get fullName => middleInitial.isNotEmpty
      ? '$firstName $middleInitial. $lastName'
      : '$firstName $lastName';

  BuyerProfile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? middleInitial,
    String? sex,
    String? contactNo,
    String? birthday,
    int? age,
    PhilippineAddress? address,
    String? kycIdType,
    String? kycIdFileName,
    String? kycIdPreviewUrl,
    String? submittedAt,
    BuyerStatus? status,
    bool? isVip,
    String? avatarUrl,
  }) {
    return BuyerProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleInitial: middleInitial ?? this.middleInitial,
      sex: sex ?? this.sex,
      contactNo: contactNo ?? this.contactNo,
      birthday: birthday ?? this.birthday,
      age: age ?? this.age,
      address: address ?? this.address,
      kycIdType: kycIdType ?? this.kycIdType,
      kycIdFileName: kycIdFileName ?? this.kycIdFileName,
      kycIdPreviewUrl: kycIdPreviewUrl ?? this.kycIdPreviewUrl,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      isVip: isVip ?? this.isVip,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
