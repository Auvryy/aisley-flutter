class PhilippineAddress {
  final String province;
  final String city;
  final String barangay;
  final String street;
  final String houseNumber;
  final String postalCode;

  const PhilippineAddress({
    required this.province,
    required this.city,
    required this.barangay,
    required this.street,
    required this.houseNumber,
    required this.postalCode,
  });

  String get formattedAddress {
    final parts = [
      if (houseNumber.isNotEmpty) houseNumber,
      if (street.isNotEmpty) street,
      if (barangay.isNotEmpty) 'Brgy. $barangay',
      if (city.isNotEmpty) city,
      if (province.isNotEmpty) province,
      if (postalCode.isNotEmpty) postalCode,
    ];
    return parts.join(', ');
  }

  PhilippineAddress copyWith({
    String? province,
    String? city,
    String? barangay,
    String? street,
    String? houseNumber,
    String? postalCode,
  }) {
    return PhilippineAddress(
      province: province ?? this.province,
      city: city ?? this.city,
      barangay: barangay ?? this.barangay,
      street: street ?? this.street,
      houseNumber: houseNumber ?? this.houseNumber,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}

class PhilippineCity {
  final String name;
  final String postalCode;
  final List<String> barangays;

  const PhilippineCity({
    required this.name,
    required this.postalCode,
    required this.barangays,
  });
}

class PhilippineProvince {
  final String province;
  final List<PhilippineCity> cities;

  const PhilippineProvince({
    required this.province,
    required this.cities,
  });
}
