class Address {
  final int id;
  final int zoneId;
  final String address;
  final String street;
  final String buildingNum;
  final String floorNum;
  final String? apartment;
  final String? additionalData;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Zone zone;

  Address({
    required this.id,
    required this.zoneId,
    required this.address,
    required this.street,
    required this.buildingNum,
    required this.floorNum,
    this.apartment,
    this.additionalData,
    required this.type,
    this.createdAt,
    this.updatedAt,
    required this.zone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      zoneId: json['zone_id'] ?? 0,
      address: json['address'] ?? '',
      street: json['street'] ?? '',
      buildingNum: json['building_num'] ?? '',
      floorNum: json['floor_num'] ?? '',
      apartment: json['apartment'],
      additionalData: json['additional_data'],
      type: json['type'] ?? 'unknown',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      zone: Zone.fromJson(json['zone'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zone_id': zoneId,
      'address': address,
      'street': street,
      'building_num': buildingNum,
      'floor_num': floorNum,
      'apartment': apartment,
      'additional_data': additionalData,
      'type': type,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'zone': zone.toJson(),
    };
  }
}

class Zone {
  final int? id;
  final int cityId;
  final int? branchId;
  final double price;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String zone;

  Zone({
    this.id,
    required this.cityId,
    this.branchId,
    required this.price,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.zone,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'],
      cityId: json['city_id'] ?? 0,
      branchId: json['branch_id'],
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      zone: json['zone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'branch_id': branchId,
      'price': price,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'zone': zone,
    };
  }
}

class Branch {
  final int id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String image;
  final String coverImage;
  final String foodPreparationTime;
  final dynamic latitude; // Can be int or String based on your data
  final String longitude;
  final String coverage;
  final int status;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int cityId;
  final int main;
  final String role;
  final String imageLink;
  final String coverImageLink;
  final String map;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.image,
    required this.coverImage,
    required this.foodPreparationTime,
    required this.latitude,
    required this.longitude,
    required this.coverage,
    required this.status,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.cityId,
    required this.main,
    required this.role,
    required this.imageLink,
    required this.coverImageLink,
    required this.map,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      coverImage: json['cover_image'] ?? '',
      foodPreparationTime: json['food_preparion_time'] ?? '00:00',
      latitude: json['latitude'],
      longitude: json['longitude'] ?? '',
      coverage: json['coverage'] ?? '0',
      status: json['status'] ?? 1,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      cityId: json['city_id'] ?? 0,
      main: json['main'] ?? 0,
      role: json['role'] ?? '',
      imageLink: json['image_link'] ?? '',
      coverImageLink: json['cover_image_link'] ?? '',
      map: json['map'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'email': email,
      'phone': phone,
      'image': image,
      'cover_image': coverImage,
      'food_preparion_time': foodPreparationTime,
      'latitude': latitude,
      'longitude': longitude,
      'coverage': coverage,
      'status': status,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'city_id': cityId,
      'main': main,
      'role': role,
      'image_link': imageLink,
      'cover_image_link': coverImageLink,
      'map': map,
    };
  }
}

class City {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int status;

  City({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
    };
  }
}

// Response wrapper class for the entire JSON structure
class LocationResponse {
  final List<Address> addresses;
  final List<Zone> zones;
  final List<Branch> branches;
  final List<City> cities;

  LocationResponse({
    required this.addresses,
    required this.zones,
    required this.branches,
    required this.cities,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((item) => Address.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      zones: (json['zones'] as List<dynamic>?)
              ?.map((item) => Zone.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      branches: (json['branches'] as List<dynamic>?)
              ?.map((item) => Branch.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      cities: (json['cities'] as List<dynamic>?)
              ?.map((item) => City.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'zones': zones.map((zone) => zone.toJson()).toList(),
      'branches': branches.map((branch) => branch.toJson()).toList(),
      'cities': cities.map((city) => city.toJson()).toList(),
    };
  }
}

// Simplified branch model (keeping your BranchStarter class)
class BranchStarter {
  final int id;
  final String name;
  final String address;

  BranchStarter({
    required this.id,
    required this.name,
    required this.address,
  });

  factory BranchStarter.fromJson(Map<String, dynamic> json) {
    return BranchStarter(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }
}
